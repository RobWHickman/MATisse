%function to get the basic parameters for the task
%first part creates a table of the ask requirements for the block
%secondly load or create the times for each epoch in the task
function parameters = get_all_parameters(parameters, hardware)

%create a table from the parameters
task_checks = table([repmat(0, 1, length(parameters.task_checks.requirements))'],...
    [parameters.task_checks.requirements],...
    {'monkey_fixated_on_cross';'monkey_holding_joystick_still';'monkey_bidding_activity';'monkey_bid_stabilised';'monkey_bid_targeted'},...
    'VariableNames',{'Status','Requirement','Description'},...
    'RowNames',{'fixation';'hold_joystick';'no_bid_activity';'stabilised_offer';'targeted_offer'});
%if in testmode, don't check for hold_joystick no matter what
if parameters.break.testmode
    task_checks.Status('fixation') = 0;
end
%overwrite the vector set by the GUI with the table for neatness
parameters.task_checks.table = task_checks;

%get the rest of the parameters
%timings- which need to be multiplied by the monitor refresh rate
%either finds a file called interval timings 
timing_files = dir('../../decorators/timings');
if ~any(ismember({timing_files.name}, 'interval_times.mat'))
    disp('did not find timing file- generating own timings!');
    parameters.timings = set_interval_timings();
%will by default load interval_times.mat unless otherwise specified
else
    if ismissing(parameters.timing.load_filestring)
        load('../../decorators/timings/interval_times.mat');
        parameters.timings = interval_times;
    else
        load(parameters.timing.load_filestring);
        parameters.timings = interval_times;
    end
end

%add a frames column to the interval times table to reflect the monitor
%refresh rate (usually 60hz)
parameters.timings.Frames = round(parameters.timings.Time * hardware.screen.refresh_rate);
parameters.timings.Variance = round(parameters.timings.PlusMinus * hardware.screen.refresh_rate);