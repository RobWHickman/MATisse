%function to look in a directory and load all matching images
%these will be used to signify the reward value in the task
%e.g. fractals_in_array = load_fractal_images(path_to_fractals, fractal_names)
function fractals = load_fractal_images(settings, screen_info, task)
%find all the matching images
all_images = dir([settings.images_path settings.fractal_images]);
fractal_info.number = length(all_images);

print(task)
%error if no matching images are found
if(fractal_info.number < 1)
    display('no Fractal Images Found!!!');
end

%create the empty array
fractal_images{fractal_info.number,1} = [];

%set the size of the fractals relevant to the task
%as a fraction of the screen height (will form a square of that many
%pixels)
if strcmp(task, 'BDM')
    stimuli_size = 0.5;
elseif strcmp(task, 'BC')
    stimuli_size = 0.4;
end

%for each image, load it and add to the array
%each fractal is scaled to 75% of the screen height
for image = 1:fractal_info.number
    full_size_fractal = imread([settings.images_path all_images(image).name]);
    image_size = size(full_size_fractal);
    image_scalar = (screen_info.height * stimuli_size) / image_size(2);
    fractal_images{image} = imresize(full_size_fractal, image_scalar);
end

%set the position of the fractal as a function of the screen
if strcmp(task, 'BDM')
fractal_info.fractal_position = [((screen_info.width /2) - (screen_info.percent_x * 10) - (screen_info.height * 0.5)),...
    screen_info.height/2 - (screen_info.height * 0.5)/2,...
    ((screen_info.width /2) - (screen_info.percent_x * 10)),...
    (screen_info.height/2 + (screen_info.height * 0.5)/2)];
elseif strcmp(task, 'BC')
fractal_info.fractal_position = [((screen_info.width /2) - (screen_info.percent_x * 27) - (screen_info.height * stimuli_size)),...
    screen_info.height/2 - (screen_info.height * stimuli_size)/2,...
    ((screen_info.width /2) - (screen_info.percent_x * 27)),...
    (screen_info.height/2 + (screen_info.height * stimuli_size)/2)];
end

%prepare for output as one object
fractals.fractals = fractal_images;
fractals.fractal_info = fractal_info;
