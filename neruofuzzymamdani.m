clc, clear, close all
%% Read FIS system
fis = readfis('Spare_Part_Centre_Rulebase2')

%% Generate random input dataset within the specified ranges
num_samples = 1000;
input1 = rand(num_samples, 1)*0.7;   % Range: [0, 0.7]
input2 = rand(num_samples, 1);       % Range: [0, 1]
input3 = rand(num_samples, 1);       % Range: [0, 1]

targets = evalfis([input1, input2, input3], fis);

%Divide the dataset
data = [input1, input2, input3, targets];
shuffled_data = data(randperm(size(data, 1)), :); % Shuffle the data randomly

% Split into train and test sets (80% train, 20% test)
train_size = round(0.8 * num_samples);
train_data = shuffled_data(1:train_size, :);
test_data = shuffled_data(train_size+1:end, :);

%% Load training and test data from workspace into neuro fuzzy logic designer

%% Load NFIS
nfis = readfis('NeuroFIS')

%% Generate targets with NFIS
nfis_outputs = evalfis(test_data(:, 1:3), nfis);

%% Calculate testing dataset metrics
targets = test_data(:, 4);
errors = targets - nfis_outputs;
mse = mean(errors.^2);
rmse = sqrt(mse);
mean_value = mean(errors);
std_dev = std(errors);

%% Plot Test Target vs. Test Output
figure;
plot(targets, 'b', 'LineWidth', 2);
hold on;
plot(nfis_outputs, 'r', 'LineWidth', 2);
xlabel('Sample Index');
ylabel('Value');
title('Test Target vs. NFIS Output');
legend('Test Target', 'NFIS Output');
grid on;
hold off;

%% Compare Outputs Beyond Range
input_beyond_range = [1.8, 0.8, -0.2];
output_fis = evalfis(input_beyond_range, fis);
output_nfis = evalfis(input_beyond_range, nfis);

disp('Output of FIS for input beyond range:');
disp(output_fis);
disp('Output of NFIS for input beyond range:');
disp(output_nfis);