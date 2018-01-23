%function to look in a directory and load all matching images
%these will be used to signify the reward value in the task
%e.g. fractals_in_array = load_fractal_images(path_to_fractals, fractal_names)
function fractals = load_fractal_images(parameters, modifiers, screen_width, screen_height)
%find all the matching images
all_images = dir([modifiers.fractals.folder modifiers.fractals.string]);

%error if no matching images are found
if(length(all_images) < 1)
    warning('!no fractal images found!');
end
%error if less fractals are found than specified in the total number
if(length(all_images) < modifiers.fractals.number)
    warning('!less fractals than specified found!');
end

%create the empty array
fractal_images{modifiers.fractals.number,1} = [];

%set the size of the fractals relevant to the task
%as a fraction of the screen height (will form a square of that many
%pixels)
%also set the position of the fractal as a function of the screen
if strcmp(parameters.task.type, 'BDM')
    stimuli_size = 0.5;
    fractal_position = [((screen_width /2) - ((screen_width/100) * 10) - (screen_height * 0.5)),...
        screen_height/2 - (screen_height * 0.5)/2,...
        ((screen_width /2) - ((screen_width/100) * 10)),...
        (screen_height/2 + (screen_height * 0.5)/2)];
elseif strcmp(parameters.task.type, 'BC')
    stimuli_size = 0.4;
    fractal_position = [((screen_width /2) - ((screen_width/100) * 27) - (screen_height * stimuli_size)),...
        screen_height/2 - (screen_height * stimuli_size)/2,...
        ((screen_width /2) - ((screen_width/100) * 27)),...
        (screen_height/2 + (screen_height * stimuli_size)/2)];
elseif strcmp(parameters.task.type, 'PAV')
    stimuli_size = 0.4;
    fractal_position = [((screen_width /2) - (percent_x * 10) - (screen_height * stimuli_size)),...
        screen_height/2 - (screen_height * stimuli_size)/2,...
        ((screen_width /2) - ((screen_width/100) * 10)),...
        (screen_height/2 + (screen_height * stimuli_size)/2)];
end

%for each image, load it and add to the array
%each fractal is scaled to 75% of the screen height
for image = 1:length(all_images)
    full_size_fractal = imread([modifiers.fractals.folder all_images(image).name]);
    image_size = size(full_size_fractal);
    image_scalar = (screen_info.height * stimuli_size) / image_size(2);
    fractal_images{image} = imresize(full_size_fractal, image_scalar);
end

%prepare for output as one object
fractals.position = fractal_position;
fractals.dimensions.height = size(fractal_images{image}, 1);
fractals.dimensions.width = size(fractal_images{image}, 2);

%confirm loading
disp('fractals found and loaded correctly');
