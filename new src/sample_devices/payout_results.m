function results = payout_results(parameters, modifiers, hardware, results, payout)
%if the budget is being paid
if strcmp(payout, 'budget')
    %always give percentage of a fixed budget
    results.output.budget_liquid = results.output.budget * modifiers.budget.magnitude;
    %if testmode- use speakers to indicate payout
    if parameters.break.testmode
        sound_payout(results, 'budget');
    else
        %get the tap and use this taps calibration to get the open time
        tap = hardware.solenoid.release.budget_tap;
        tap_open_time = calculate_open_time(tap, results.output.budget_liquid);
        %release the liquid
        release_liquid(hardware, tap, tap_open_time)
    end
elseif strcmp(payout, 'reward')
    %calculate the amount of reward to give
    if results.trial_results.reward > 0
        results.output.reward_liquid = modifiers.fractals.magnitude_vector(results.trial_results.reward); %increments of 0.15ml of juice
    else
        results.output.reward_liquid = 0;
    end
    %if testmode- use speakers to indicate payout
    if parameters.break.testmode
        sound_payout(results, 'budget');
    else
        %get the tap and use this taps calibration to get the open time
        tap = hardware.solenoid.release.budget_tap;
        tap_open_time = calculate_open_time(tap, results.output.budget_liquid);
        %release the liquid
        release_liquid(hardware, tap, tap_open_time)
    end
end


    
   
       
        


        