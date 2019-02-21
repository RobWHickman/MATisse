function results = pay_notpay(results)
%in blind pavlovian task always 50% chance to be paid or not
if strcmp(results.single_trial.subtask, 'Blind_Pav')
    if rand > 0.5
        results.outputs.reward = results.single_trial.reward_value;
        results.outputs.paid = 1;
        results.outputs.results = [results.outputs.results, '_paid'];
    else
        results.outputs.reward = 0;
        results.outputs.paid = 0;
        results.outputs.results = [results.outputs.results, '_notpaid'];
    end
%otherwise calcualte from the fractal properties
else
    if(results.single_trial.reward_chance ~= 1)
        random_number_check = rand;
        if(random_number_check < results.single_trial.reward_chance)
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
end
