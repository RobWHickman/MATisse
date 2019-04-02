function results = pay_notpay(results)

%find last three results
if results.single_trial.reward_chance ~= 1
    if isfield(results, 'full_output_table') && height(results.full_output_table) > 2
        recent_payout = results.full_output_table.results((height(results.full_output_table)-2):height(results.full_output_table));
        if length(find(contains(recent_payout, '_paid'))) == length(recent_payout)
            results.outputs.reward = 0;
            results.outputs.paid = 0;
            results.outputs.results = [results.outputs.results, '_notpaid'];
            disp('overwriting payout to not pay!');
        elseif length(find(contains(recent_payout, '_notpaid'))) == length(recent_payout)
            results.outputs.reward = results.single_trial.reward_value;    
            results.outputs.paid = 1;
            results.outputs.results = [results.outputs.results, '_paid'];
                disp('overwriting payout to pay!');
        else
            % %in blind pavlovian task always 50% chance to be paid or not
            % if strcmp(results.single_trial.subtask, 'Blind_Pav')
            %     if rand > 0.5
            %         results.outputs.reward = results.single_trial.reward_value;
            %         results.outputs.paid = 1;
            %         results.outputs.results = [results.outputs.results, '_paid'];
            %     else
            %         results.outputs.reward = 0;
            %         results.outputs.paid = 0;
            %         results.outputs.results = [results.outputs.results, '_notpaid'];
            %     end
            % %otherwise calcualte from the fractal properties
            % else
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
            %end
        end
    else
        %if trial no. 1 always pay
        results.outputs.reward = results.single_trial.reward_value;    
        results.outputs.paid = 1;
        results.outputs.results = [results.outputs.results, '_paid'];
    end
else
    results.outputs.reward = results.single_trial.reward_value;
    results.outputs.paid = 1;
    results.outputs.results = [results.outputs.results, '_paid'];
end

   