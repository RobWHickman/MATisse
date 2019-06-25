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
date = datestr(now,'yyyy-mm-dd');
block = parameters.participants.block_no;
trial_no = num2str(results.block_results.completed);

if strcmp(type, 'task_results')
    %save as .csv
    %order the table columns alphabetically
    sorted_table = results.full_output_table(:,sort(results.full_output_table.Properties.VariableNames));
    writetable(sorted_table, fullfile(dir, regexprep(char(strcat(trial_no, '_', date, human, '_', monkey, '_block', num2str(block), 'COMPACT_RESULTS.csv')), ':', '')));
end
if strcmp(type, 'behaviour_data')
    behaviour_data = results.behaviour_table;
    writetable(behaviour_data, fullfile(dir, regexprep(char(strcat(trial_no, '_', date, human, '_', monkey, '_block', num2str(block), 'TRIAL_BEHAVIOUR.csv')), ':', '')));
end

if strcmp(type, 'task_metadata')
    disp('saving trial metadata')
    %save metadata as .mat
    metadata = results;
    save(fullfile(dir, regexprep(char(strcat(date, human, '_', monkey, '_block', num2str(block), 'METADATA.mat')), ':', '')), 'metadata');
end

%manually save on a trial
if strcmp(type, 'manual')
    disp('manaully saving')
    %save as .csv
    sorted_table = results.full_output_table(:,sort(results.full_output_table.Properties.VariableNames));
    writetable(sorted_table, fullfile(dir, regexprep(char(strcat('MANUAL', results.block_results.completed, date, human, '_', monkey, '_block', num2str(block), 'COMPACT_RESULTS.csv')), ':', '')));
end

