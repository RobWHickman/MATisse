%quick function to save the output from experiment
%a mat file with three subfields- metadata which shows the parameters on
%the LAST TRIAL (be careful this doesnt change trial to trial), the data
%from the last trial run (useful for debugging), and the full results from
%the every trial that has been run
%it is saved based on the experimenter, monkey and and current system time
%in a folder selected when Set was run
function [] = save_data(parameters, results)
%redefine the parameters.save_info to clear up saving string
save_info = parameters.save_info;

%smaller results of just the trial results
compact_results = results.full_output_table.trial_results;

%save the data
%compact results is just the 'results'- if the monkey won, and by how much
%etc.
%full results contains all the information about the task and every trial

%clear out the save directory to keep only the most recent file
folder_contents = dir(save_info.output_folder);


for file = 1:length(folder_contents);
    filename = folder_contents(file).name;
    if length(strfind(filename, 'RESULTS')) == 1
        fullfilename = fullfile(save_info.output_folder, filename);
        delete(fullfilename);
    end
end

%save as .mat
%save(fullfile(save_info.output_folder, regexprep(char(strcat(string(datetime('now')), save_info.experimenter, '_', save_info.primate, 'COMPACT_RESULTS.mat')), ':', '')), 'compact_results');
save(fullfile(save_info.output_folder, regexprep(char(strcat(string(datetime('now')), save_info.experimenter, '_', save_info.primate, 'FULL_RESULTS.mat')), ':', '')), 'results');

%save as .xlsx
writetable(compact_results, fullfile(save_info.output_folder, regexprep(char(strcat(string(datetime('now')), save_info.experimenter, '_', save_info.primate, 'COMPACT_RESULTS.csv')), ':', '')));
%writetable(results, fullfile(save_info.output_folder, regexprep(char(strcat(string(datetime('now')), save_info.experimenter, '_', save_info.primate, 'FULL_RESULTS.csv')), ':', '')));

