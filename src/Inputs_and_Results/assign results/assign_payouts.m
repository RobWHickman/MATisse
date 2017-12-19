%small function to calculate the remaining budget and reward the monkey
%gets after an auction depending on whether it beats the computer or not
function results = assign_payouts(parameters, results)
%assignment depending on task type #MARIUS
if strcmp(parameters.task_type,'base')
    %if the monkey wins the auction
    if(parameters.single_trial_values.computer_bid_value < results.trial_results.monkey_bid)
        results.trial_results.remaining_budget = (1 -  parameters.single_trial_values.computer_bid_value);
        results.trial_results.reward = parameters.single_trial_values.offer_value;
    %if the computer wins the auction
    else
        results.trial_results.remaining_budget = 1;
        results.trial_results.reward = 0;
    end
elseif strcmp(parameters.task_type,'first')
    %if the monkey wins the auction
    if(parameters.single_trial_values.computer_bid_value < results.trial_results.monkey_bid)
        results.trial_results.remaining_budget = (1 -  results.trial_results.monkey_bid);
        results.trial_results.reward = parameters.single_trial_values.offer_value;
    %if the computer wins the auction
    else
        results.trial_results.remaining_budget = 1;
        results.trial_results.reward = 0;
    end
elseif strcmp(parameters.task_type,'12price')
    if parameters.single_trial_values.auction_type == 1
        %if the monkey wins the auction
        if(parameters.single_trial_values.computer_bid_value < results.trial_results.monkey_bid)
        results.trial_results.remaining_budget = (1 -  results.trial_results.monkey_bid);
        results.trial_results.reward = parameters.single_trial_values.offer_value;
        %if the computer wins the auction
        else
            results.trial_results.remaining_budget = 1;
            results.trial_results.reward = 0;
        end
    elseif parameters.single_trial_values.auction_type == 2
        %if the monkey wins the auction
        if(parameters.single_trial_values.computer_bid_value < results.trial_results.monkey_bid)
            results.trial_results.remaining_budget = (1 -  parameters.single_trial_values.computer_bid_value);
            results.trial_results.reward = parameters.single_trial_values.offer_value;
        %if the computer wins the auction
        else
            results.trial_results.remaining_budget = 1;
            results.trial_results.reward = 0;
        end
    end
end

%also chuck in the computer bid as a field to be analysed later
results.trial_results.computer_bid = parameters.single_trial_values.computer_bid_value;
results.trial_results.offer_value = parameters.single_trial_values.offer_value;
results.trial_results.auction_type = parameters.single_trial_values.auction_type;