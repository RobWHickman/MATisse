function dataToGetty = getty_create_array(trial, trial_variables, parameters, results_table)

%trial number in two bits
getty_trial_number = fi_numTo2bytes(trial);

%the task the trial will run
if strcmp(parameters.task.type, 'BDM')
    getty_task = 1;
    if strcmp(trial_variables.subtask, 'BDM')
        getty_subtask = 1;
    elseif strcmp(trial_variables.subtask, 'FP')
        getty_subtask = 2;
    elseif strcmp(trial_variables.subtask, 'BDM_FP')
        getty_subtask = 3;
    end
elseif strcmp(parameters.task.type, 'BC')
    getty_task = 2;
    getty_subtask = 6;
    if strcmp(trial_variables.subtask, 'binary_fractal_choice')
        getty_subtask = 4;
    elseif strcmp(trial_variables.subtask, 'binary_budget_choice')
        getty_subtask = 5;
    elseif strcmp(trial_variables.subtask, 'binary_choice')
        getty_subtask = 6;
    end
elseif strcmp(parameters.task.type, 'PAV')
    getty_task = 3;
    if strcmp(trial_variables.subtask, 'Pav')
        getty_subtask = 7;
    elseif strcmp(trial_variables.subtask, 'Blind_Pav')
        getty_subtask = 8;
    end
else
    disp('unknown task- set subtask to 9');
    getty_subtask = 9;
end

if ~isnan(trial_variables.reward_value)
    trial_reward_value = trial_variables.reward_value;
else
    trial_reward_value = 0;
end
if ~isnan(trial_variables.budget_value)
    trial_budget_value = round(trial_variables.budget_value * 100);
else
    trial_budget_value = 0;
end

%set the starting bid for the monkey and compute rbid as values
%times 100 and rounded to give approximate integer
if ~isnan(trial_variables.starting_bid)
    trial_starting_bid = round(trial_variables.starting_bid * 100);
else
    trial_starting_bid = 2;
end
if ~isnan(trial_variables.computer_bid)
    trial_computer_bid = round(trial_variables.computer_bid * 100);
else
    trial_computer_bid = 2;
end

%add in variables from the last trials results
results_addvals = generate_results_addvals(trial, {'percent_correct', 'reward'}, results_table);

%set up the situation
%situation = str2num(strcat(num2str(getty_task), num2str(getty_subtask), num2str(trial_reward_value)));
if strcmp(parameters.task.type, 'BDM')
    if trial_reward_value == 1
        situation = 1;
    elseif trial_reward_value == 2
        situation = 2;
    elseif trial_reward_value == 3
        situation = 3;
    end
elseif strcmp(trial_variables.subtask, 'Pav')
    if trial_reward_value == 1
        situation = 5;
    elseif trial_reward_value == 2
        situation = 6;
    elseif trial_reward_value == 3
        situation = 7;
    end
elseif strcmp(trial_variables.subtask, 'Blind_Pav')
    situation = 4;
else
    disp('unknown task- set situation to 9');
    situation = 9;
end

disp('the situation for getty is');
disp(situation);


% generate final array (bytes 3 and 4 are used by getty to save the trial duration)
dataToGetty=[];
dataToGetty(1:2) = getty_trial_number;
dataToGetty(3:4) = [0 0];
dataToGetty(5) = situation;
dataToGetty(6) = getty_task;
dataToGetty(7) = getty_subtask;
dataToGetty(8) = trial_reward_value;
dataToGetty(9) = trial_budget_value;
dataToGetty(10) = trial_starting_bid;
dataToGetty(11) = trial_computer_bid;
dataToGetty = [dataToGetty, results_addvals];

% add first value (array length)
dataToGetty = [length(dataToGetty)+1 dataToGetty];

end

function nb = fi_numTo2bytes(n)
    if n>2^16, error(['n. out of range (max 65536): ',n2str(n)]); end
    nb = [fix(n/256) mod(n,256)];
end

