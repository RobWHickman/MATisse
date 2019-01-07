%quick function to save the output from experiment
%a mat file with three subfields- metadata which shows the parameters on
%the LAST TRIAL (be careful this doesnt change trial to trial), the data
%from the last trial run (useful for debugging), and the full results from
%the every trial that has been run
%it is saved based on the experimenter, monkey and and current system time
%in a folder selected when Set was run
function [] = save_data(parameters, results, type)
%redefine the parameters.save_info to clear up saving string
dir = parameters.directories.save;
human = parameters.participants.experimenter;
monkey = parameters.participants.primate;

if strcmp(type, 'task_results')
    %save as .csv
    writetable(results.full_output_table, fullfile(dir, regexprep(char(strcat(string(datetime('now')), human, '_', monkey, 'COMPACT_RESULTS.csv')), ':', '')));
end

if strcmp(type, 'task_metadata')
    disp('saving trial metadata after first trial')
    %save metadata as .mat
    metadata = results.experiment_metadata;
    save(fullfile(dir, regexprep(char(strcat(string(datetime('now')), human, '_', monkey, 'METADATA.mat')), ':', '')), 'metadata');
end


