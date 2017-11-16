function parameters = get_all_parameters(parameters, hardware)

%get the basic parameters for the experiment
parameters = set_experiment_parameters(parameters, hardware);

%get the rest of the parameters
%timings- which need to be multiplied by the monitor refresh rate
directory = dir;
if ~any(strcmp('interval_times.mat', {directory(~[directory.isdir]).name}))
    parameters.timings = set_interval_timings();
else
    load interval_times.mat;
    parameters.timings = interval_times;
end

%add a frames column to the interval times table to reflect the monitor
%refresh rate (usually 60hz)
parameters.timings.Frames = parameters.timings.Time * hardware.outputs.screen_info.hz;
