%function to look in a directory and load all matching images
%these will be used to signify the reward value in the task
%e.g. fractals_in_array = load_fractal_images(path_to_fractals, fractal_names)
function fractals = load_fractal_images(settings, screen_info,parameters)
%find all the matching images
all_images = dir([settings.images_path settings.fractal_images]);
fractal_info.number = length(all_images);

%error if no matching images are found
if(fractal_info.number < 1)
    display('no Fractal Images Found!!!');
end

%create the empty array
fractal_images{fractal_info.number,1} = [];

%for each image, load it and add to the array
%each fractal is scaled to 75% of the screen height
for image = 1:fractal_info.number
    full_size_fractal = imread([settings.images_path all_images(image).name]);
    image_size = size(full_size_fractal);
    image_scalar = (screen_info.height * 0.5) / image_size(2);
    fractal_images{image} = imresize(full_size_fractal, image_scalar);
end

%select some fractals (according to the fractal_no input to the GUI) from
%the entire fractal list loaded from the folder
if strcmp(parameters.task_type,'first') || strcmp(parameters.task_type,'12price')
    fractal_index = randperm(fractal_info.number,parameters.fractal_no);
    for i=1:parameters.fractal_no
        fractal_images_select(i) = fractal_images(fractal_index(i));
    end
    fractal_images = fractal_images_select;
end

%prepare for output as one object
fractals.fractals = fractal_images;
fractals.fractal_info = fractal_info;
