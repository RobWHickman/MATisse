%first function for any task
%will reset stuff and set the keys for inputs
%also opens a folder to save output to
function [parameters] = matisse_set(parameters)

%close any open screen
%Screen('CloseAll');

%open a directory within which to save the trials
parameters.directories.save = uigetdir(pwd, 'save directory');

%open a directory from which to run the experiment scripts
parameters.directories.run = uigetdir(pwd, 'task scripts directory');

%change into this directory
cd(parameters.directories.run)
