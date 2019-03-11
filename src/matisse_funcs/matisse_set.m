%first function for any task
%will reset stuff and set the keys for inputs
%also opens a folder to save output to
function [parameters] = matisse_set(parameters)

%close any open screen
%Screen('CloseAll');

%open a directory within which to save the trials
%parameters.directories.save = uigetdir(pwd, 'save directory');
parameters.directories.save = uigetdir('C:\Users\Alaa\Desktop\MATisse\savefiles', 'save directory');

cd(parameters.directories.save)

%check if a file exists in this directory
human = parameters.participants.experimenter;
monkey = parameters.participants.primate;
block = parameters.participants.block_no;
date = datestr(now,'yyyy-dd-mm');
if isfile(regexprep(char(strcat(date, human, '_', monkey, '_block', num2str(block), 'COMPACT_RESULTS.csv')), ':', ''))
    error('file already exists! make sure block no is unique!');
end

%open a directory from which to run the experiment scripts
%parameters.directories.run = uigetdir(pwd, 'task scripts directory');
parameters.directories.run = uigetdir('C:\Users\Alaa\Desktop\MATisse\task\', 'task scripts directory');

%change into this directory
cd(parameters.directories.run)
