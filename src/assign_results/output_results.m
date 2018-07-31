function results = output_results(results, parameters)

%update the results for the block
results.block_results.completed = results.block_results.completed + 1;
%whether or not the trial was completed succesfully
if results.trial_results.task_error ~= 1
    results.block_results.correct = results.block_results.correct + 1;
else
    results.block_results.error = results.block_results.error + 1;
end
results.block_results.percent_correct = (results.block_results.correct / results.block_results.completed) * 100;
%update whether or not block was rewarded with juice
if results.outputs.reward ~= 0
    results.block_results.rewarded = results.block_results.rewarded + 1;
else
    results.block_results.unrewarded = results.block_results.unrewarded + 1;
end
%update the amounts of liquid given out
results.block_results.water = results.block_results.water + results.outputs.budget_liquid;
results.block_results.juice = results.block_results.juice + results.outputs.reward_liquid;

%assign names to the fields in the results structs for the output
%fieldnames(results.trial_results) = strcat(repmat({'trial_results_'}, 1, length(fieldnames(results.trial_results))), fieldnames(results.trial_results)');
%fieldnames(results.outputs) = strcat(repmat({'trial_output_'}, 1, length(fieldnames(results.outputs))), fieldnames(results.outputs)');
%fieldnames(results.single_trial) = strcat(repmat({'trial_value_'}, 1, length(fieldnames(results.single_trial))), fieldnames(results.single_trial)');
%fieldnames(results.block_results) = strcat(repmat({'block_results_'}, 1, length(fieldnames(results.block_results))), fieldnames(results.block_results)');

%convert to tables and horzcat
trial_output_table = horzcat(struct2table(results.trial_results,'AsArray',true),...
    struct2table(results.outputs,'AsArray',true),...
    struct2table(results.single_trial,'AsArray',true),...
    struct2table(results.block_results,'AsArray',true),...
    struct2table(parameters.task));

%vertcat unless the first trial
if results.block_results.completed == 1
    full_output_table = trial_output_table;
else
    trial_output_table = removevars(trial_output_table,{'fractal_means','graph_output'});
    full_output_table = vertcat(results.full_output_table, trial_output_table);
end

%calculate the results to be graphed
if strcmp(parameters.task.type, 'BDM')
    results.experiment_summary.means = grpstats(full_output_table.trial_results.monkey_final_bid, full_output_table.trial_results.offer_value);
elseif strcmp(parameters.task.type, 'BC')
    results.block_results.fractal_means = grpstats(full_output_table.monkey_bid, full_output_table.reward);
    results.block_results.graph_output = grpstats(full_output_table.reward, results.block_results.fractal_means, 'numel');
elseif strcmp(parameters.task.type, 'PAV')
    %dont care about means of anything for pavlovian
    results.block_results.fractal_means = NaN;
    %get the numbers of each reward given
    results.block_results.graph_output = grpstats(full_output_table.reward, full_output_table.reward, 'numel');
end

%if doing the binary choice update whether the monkey went left or right
if strcmp(parameters.task.type, 'BC')
    if results.movement.total_movement > 0
        results.block_results.left = results.block_results.left + 1;
    else
        results.block_results.right = results.block_results.right + 1;
    end
end

%remove all fields from results except block_results and full_putput_table
fields = {'trial_results','outputs','single_trial'};
%fields = {'trial_results','outputs','single_trial','movement'};
results = rmfield(results,fields);
results.full_output_table = full_output_table;
disp(full_output_table);


        

