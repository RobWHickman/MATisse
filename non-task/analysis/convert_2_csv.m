function [] = convert_2_csv(filename)
input_folder = 'C:/Users/WS-Guest/Desktop/task data/';
output_folder = [input_folder, 'joystick_vectors/'];

input_filename = [input_folder, filename, '.mat'];
load(input_filename);

bidding_vector_output = results.full_output_table.trial_values.bidding_vector;
trials = length(bidding_vector_output);

for trial = 1:trials
    joystick_vector = bidding_vector_output{trial};
    length_vector = length(joystick_vector);
    
    missing_pad = NaN(1, max(cellfun('length',bidding_vector_output)) - length_vector);
    
    output_vector = [joystick_vector, missing_pad];

    if trial == 1
        output_matrix = output_vector;
    else
        output_matrix = vertcat(output_matrix, output_vector);
    end
end

output_file = [output_folder, filename, '.csv'];
csvwrite(output_file, output_matrix);
end

