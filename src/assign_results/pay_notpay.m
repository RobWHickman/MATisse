function results = pay_notpay(results)

if(results.single_trial.reward_chance ~= 1)
    random_number_check = rand;
    if(random_number_check > results.single_trial.reward_chance)
        results.outputs.reward = results.single_trial.reward_value;
        results.outputs.paid = 1;
        results.outputs.results = [results.outputs.results, '_paid'];
    else
        results.outputs.reward = 0;
        results.outputs.paid = 0;
        results.outputs.results = [results.outputs.results, '_notpaid'];
    end
else
    results.outputs.reward = results.single_trial.reward_value;
    results.outputs.paid = 1;
    results.outputs.results = [results.outputs.results, '_paid'];
end
