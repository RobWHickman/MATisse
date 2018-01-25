%function to get the basic parameters for the task
%
function parameters = get_all_parameters(parameters, hardware)

%create a table from the parameters 
task_checks = table([false;false;false;false;true],...
    {'monkey_fixated_on_cross';'monkey_holding_joystick_still';'monkey_bidding_activity';'monkey_bid_stabilised';'monkey_bid_targeted'},...
    'VariableNames',{'Status','Description'},...
    'RowNames',{'fixation';'hold_joystick';'no_bid_activity';'stabilised_offer';'targeted_offer'});

%get the rest of the parameters
%timings- which need to be multiplied by the monitor refresh rate
%either finds a file called interval timings 
directory = dir;
if ~any(strcmp('interval_times.mat', {directory(~[directory.isdir]).name}))
    parameters.timings = set_interval_timings();
%will by default load interval_times.mat unless otherwise specified
else
    load interval_times.mat;
    parameters.timings = interval_times;
end

%add a frames column to the interval times table to reflect the monitor
%refresh rate (usually 60hz)
parameters.timings.Frames = parameters.timings.Time * hardware.outputs.screen_info.hz;
