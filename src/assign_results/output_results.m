function results = output_results(results, parameters, hardware, open_float)
%update the results for the block
results.block_results.completed = results.block_results.completed + 1;
%whether or not the trial was completed succesfully
if results.single_trial.task_failure ~= 1
    results.block_results.correct = results.block_results.correct + 1;
else
    results.block_results.error = results.block_results.error + 1;
end
results.block_results.percent_correct = (results.block_results.correct / results.block_results.completed) * 100;

%update whether or not block was rewarded with juice
if results.single_trial.task_failure ~= 1
    if results.outputs.reward ~= 0
        results.block_results.rewarded = results.block_results.rewarded + 1;
    else
        if  ~results.single_trial.task_failure
            results.block_results.unrewarded = results.block_results.unrewarded + 1;
        end
    end
end
%update the amounts of liquid given out
if(strcmp(parameters.solenoid.release.free_liquid, 'juice'))
    results.block_results.water = results.block_results.water + results.outputs.budget_liquid;
    results.block_results.juice = results.block_results.juice + results.outputs.reward_liquid + open_float.trial_free_reward;
elseif(strcmp(parameters.solenoid.release.free_liquid, 'water'))
    results.block_results.water = results.block_results.water + results.outputs.budget_liquid + open_float.trial_free_reward;
    results.block_results.juice = results.block_results.juice + results.outputs.reward_liquid;
end
%for binary choice tasks include the left/right proportion
if strcmp(parameters.task.type, 'BC')
    if results.trial_results.monkey_bid > 0.5
        results.block_results.right = results.block_results.right + 1;
    else
        results.block_results.left = results.block_results.left + 1;
    end
end

timing_cols = table2array(parameters.timings(:,6)) / hardware.screen.refresh_rate;
timing_cols = array2table(timing_cols.');
timing_cols.Properties.VariableNames = parameters.timings.Properties.RowNames;

trial_col = array2table(results.block_results.completed);
trial_col.Properties.VariableNames = {'trial_no'};

%convert to tables and horzcat
results.outputs.free_reward = open_float.trial_free_reward;
trial_output_table = horzcat(struct2table(results.trial_results,'AsArray',true),...
    struct2table(results.outputs,'AsArray',true),...
    struct2table(results.single_trial,'AsArray',true),...
    struct2table(results.block_results,'AsArray',true),...
    struct2table(parameters.task),...
    timing_cols,...
    trial_col);

%vertcat unless the first trial
trial_output_table = trial_output_table(:,sort(trial_output_table.Properties.VariableNames));
%type is superfluous- have subtask and can cause crashes
trial_output_table = removevars(trial_output_table, {'type'});
if strcmp(parameters.task.type, 'BC')
    trial_output_table.primary_side = NaN;
end
if results.block_results.completed == 1
    full_output_table = trial_output_table;
else
    trial_output_table = removevars(trial_output_table,{'fractal_means','graph_output'});
    full_output_table = vertcat(results.full_output_table, trial_output_table);
end

%calculate the results to be graphed
if strcmp(parameters.task.type, 'BDM')
    results.block_results.fractal_means = grpstats(full_output_table.monkey_bid, full_output_table.reward_value);
    results.block_results.graph_output = results.block_results.fractal_means;
elseif strcmp(parameters.task.type, 'BC')
    if strcmp(results.single_trial.subtask, 'bundle_choice')
        if parameters.binomial_graphs
            disp('CALCING BINOMAIL GRAPHS');
            results.block_results.fractal_means = binomial_smooth_graph(full_output_table);
            results.block_results.graph_output = results.block_results.fractal_means;
        else
            results.block_results.fractal_means = grpstats(full_output_table.monkey_bid, full_output_table.reward_value);
            results.block_results.graph_output = results.block_results.fractal_means;
        end
    else
        results.block_results.fractal_means = grpstats(full_output_table.monkey_bid, full_output_table.second_budget_value);
        results.block_results.graph_output = results.block_results.fractal_means;
    end
elseif strcmp(parameters.task.type, 'PAV')
    %dont care about means of anything for pavlovian
    results.block_results.fractal_means = NaN;
    %get the numbers of each reward given
    results.block_results.graph_output = grpstats(full_output_table.reward, full_output_table.reward, 'numel');
end

%if doing the binary choice update whether the monkey went left or right
% if strcmp(parameters.task.type, 'BC')
%     if results.single_trial.starting_bid + nansum(results.behaviour_table.stimuli_movement(find(strcmp(results.behaviour_table.epoch, 'bidding')),:)) > 0
%         results.block_results.left = results.block_results.left + 1;
%     else
%         results.block_results.right = results.block_results.right + 1;
%     end
% end

%remove all fields from results except block_results and full_putput_table
fields = {'trial_results','outputs','single_trial'};
%fields = {'trial_results','outputs','single_trial','movement'};
results = rmfield(results,fields);
results.full_output_table = full_output_table;
disp(full_output_table);


        

