%function that sets and saves the active fractal sheet depending on task
%hard code fractal names to select here
%will fail if any two fractals in the sheet have the same name so watch for
%that
function recording_set_fractals(modifiers, parameters, hardware)

%modify active fractals per task here
pav_fractals = ['RU31'; 'RU32'; 'RU33'];
water_fractals = ['RU51'; 'RU52'; 'RU53'];
%this is a file called blank, not that it has been left blank
blank_fractals = ['blank'];
bdm_fractals = ['RU61'; 'RU62'; 'RU63'];
bcb_fractals = ['RU61'; 'RU62'; 'RU63'];

%load fractals data
folder = '../decorators/images';
fractals_table = load(fullfile(folder, 'fractals.mat'));
fractals_data = fractals_table.fractals_data;

%set all fractals to inactive
fractals_data.active = repmat(0, height(fractals_data), 1);

%set the correct fractals for the task
if strcmp(parameters.task.type, 'PAV')
    if modifiers.fractals.no_fractals
        fractals = blank_fractals;
    else
        if hardware.solenoid.release.reward_tap == 2
            disp('pav fractals');
            fractals = pav_fractals;
        else
            disp('free water task');
            fractals = water_fractals;
        end
    end
elseif strcmp(parameters.task.type, 'BDM')
    fractals = bdm_fractals;
elseif strcmp(parameters.task.type, 'BC')
    fractals = bcb_fractals;
end

%need at least one fractal
if length(fractals) < 1
    disp('ERROR - NO FRACTALS TO SELECT')
end

%sequentially activate fractals
for activate_fractal = 1:size(fractals, 1)
    one_fractal = fractals(activate_fractal,:);
    fractal_index = find(arrayfun(@(n) any(strcmp(fractals_data.file{n},one_fractal)),1:numel(fractals_data.file)));
    fractals_data.active(fractal_index) = 1;
end

%save the fractals data
save(fullfile(folder, 'fractals.mat'), 'fractals_data');


