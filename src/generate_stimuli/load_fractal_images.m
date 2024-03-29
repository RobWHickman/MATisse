%function to look in a directory and load all matching images
%these will be used to signify the reward value in the task
%e.g. fractals_in_array = load_fractal_images(path_to_fractals, fractal_names)
function fractals = load_fractal_images(parameters, modifiers, width, height)

if ismissing(parameters.timing.load_filestring)
    fractals_table = load(fullfile(modifiers.fractals.folder, 'fractals.mat'));
else
    fractals_table = load(fullfile(modifiers.fractals.folder, modifiers.fractals.fractals_file));
end

%select only active fractals
fractals_table = fractals_table.fractals_data(find(fractals_table.fractals_data.active),:);

%select out by the subtask being used
if strcmp(parameters.task.type, 'BDM')
    subtask = 'BDM';
elseif strcmp(parameters.task.type, 'BC')
    subtask = 'BC';
elseif strcmp(parameters.task.type, 'PAV')
   if modifiers.fractals.no_fractals
       subtask = 'FREE';
   else
       subtask = 'PAV';
   end
end
%and by monkey
working_monkey = parameters.participants.primate;

%filter down
task = fractals_table.task;
fractals_task_subset = fractals_table(find(arrayfun(@(n) any(strcmp(task{n},subtask)),1:numel(task))),:);
monkey = fractals_task_subset.monkey;
fractals_task_subset = fractals_task_subset(find(arrayfun(@(n) any(strcmp(monkey{n},working_monkey)),1:numel(monkey))),:);
fractal_filenames = fractals_task_subset.file;

%display the loaded fractals or a warning if none found
if(length(fractal_filenames) < 1)
    warning('No appropriate fractals found!!');
else
    disp(fractal_filenames);
end

%find all the matching images
all_images = [repmat(modifiers.fractals.folder, length(fractal_filenames),1), char(fractal_filenames), repmat('.jpg', length(fractal_filenames),1)];

%error if no matching images are found
if(size(all_images, 1) < 1)
    warning('!no fractal images found!');
end
%error if less fractals are found than specified in the total number
if(size(all_images, 1) < modifiers.fractals.number)
    warning('!less fractals than specified found!');
elseif(size(all_images, 1) > modifiers.fractals.number)
    warning('!more fractals than specified found! taking only first n fractals');
end

%create the empty array
fractal_images{modifiers.fractals.number,1} = [];

%set the size of the fractals relevant to the task
%as a fraction of the screen height (will form a square of that many
%pixels)
%also set the position of the fractal as a function of the screen
if strcmp(parameters.task.type, 'BDM')
    stimuli_size = 0.5;
    fractal_position = [((width /2) - ((width/100) * 10) - (height * 0.5)),...
        height/2 - (height * 0.5)/2,...
        ((width /2) - ((width/100) * 10)),...
        (height/2 + (height * 0.5)/2)];
elseif strcmp(parameters.task.type, 'BC')
    stimuli_size = 0.4;
    fractal_position = [((width /2) - ((width/100) * 27) - (height * stimuli_size)),...
        height/2 - (height * stimuli_size)/2,...
        ((width /2) - ((width/100) * 27)),...
        (height/2 + (height * stimuli_size)/2)];
elseif strcmp(parameters.task.type, 'PAV')
    stimuli_size = 0.4;
    fractal_position = [((width /2) - ((width/100) * 10) - (height * stimuli_size)),...
        height/2 - (height * stimuli_size)/2,...
        ((width /2) - ((width/100) * 10)),...
        (height/2 + (height * stimuli_size)/2)];
end

%for each image, load it and add to the array
%each fractal is scaled to 75% of the screen height
for image = 1:length(all_images(:,1))
    full_size_fractal = imread(all_images(image,:));
    image_size = size(full_size_fractal);
    image_scalar = (height * stimuli_size) / image_size(2);
    fractals.images{image} = imresize(full_size_fractal, image_scalar);
end

%prepare for output as one object
fractals.position = fractal_position;
fractals.dimensions.height = size(fractals.images{image}, 1);
fractals.dimensions.width = size(fractals.images{image}, 2);
fractals.fractal_properties = fractals_table;

%confirm loading
disp('fractals found and loaded correctly');
