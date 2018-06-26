%function to create two mirror image bidspace bars with hatched fill
%these are generated from a grating that is stretched to be rectangular
%one forms the template for the bidspace and the reverse indicates to the
%monkey the remaining budget in the win condition
function bidspace = generate_bidspace(parameters, modifiers, task_window, width, height)
%read the bidspace image in
bidspace_image = imread(fullfile(modifiers.fractals.folder, modifiers.budget.string));

%get the dimensions of the bidspace
bidspace_height = size(bidspace_image, 1);
bidspace_width = size(bidspace_image, 2);

%check that the image is at least half the height of the screen and an
%eight of the width
if((bidspace_height < height / 2) && (bidspace_width < width / 8))
    warning('!bidspace image is too small for the screen!');
end

%crop the image to a good size for the experiment
%image should be repeating so cropping doesnt affect presentation
%set percentage of screen based on task as the denominator of a fraction
%percentage of the screen
if strcmp(parameters.task.type, 'BDM')
    screen_width_fraction = 5; %1/5th of the screen
    screen_height_fraction = 1.25; %80% of the screen
elseif strcmp(parameters.task.type, 'BC')
    screen_width_fraction = 6; %1/6th of the screen
    screen_height_fraction = 1.5; %60% of the screen
else
    warning('!unrecognised task to set bidspace size/position!');
end

%throw a warning if the width fraction/ binary choice width is going to 

bidspace_image = imcrop(bidspace_image, [0 0 width/screen_width_fraction height/screen_height_fraction]);
%make it into a texture
bidspace.texture = Screen('MakeTexture', task_window, bidspace_image);

%get the new size and set the dimensions for the information
dimensions.height = size(bidspace_image, 1);
dimensions.width = size(bidspace_image, 2);
bidspace.dimensions = dimensions;

%set the coordinates for the bidspace image
if strcmp(parameters.task.type, 'BDM')
    bidspace.position = [((width/2) + ((width/100) * 10)),...
        (height - bidspace_height)/2,...
        ((width/2) + ((width/100) * 10)) + width/screen_width_fraction,...
        height - ((height - bidspace_height)/2)];
elseif strcmp(parameters.task.type, 'BC')
    bidspace.position = [(((width/100) * modifiers.specific_tasks.binary_choice.bundle_width) - ((width/100) * screen_width_fraction)), (height - ((height/100) * (100 - 100 /screen_height_fraction)/2) - bidspace_height),((width/100) * modifiers.specific_tasks.binary_choice.bundle_width),((height - (height/100) * (100 - 100 /screen_height_fraction)/2))];
end    

%generate a white frame for the bidspace to help the monkey focus
bounding_width = modifiers.budget.overhang/2;
bidspace_frame = bidspace.position + bounding_width;
bidspace_frame(1:2) = bidspace_frame(1:2) - 2 * bounding_width;
[bidspace_xcenter, bidspace_ycenter] = RectCenter(bidspace.position);
bidspace.bidspace_bounding_box = CenterRectOnPointd(bidspace_frame, bidspace_xcenter, bidspace_ycenter);

%generate a flipped image to show spent budget
bidspace.reverse_bidspace_image = flipdim(bidspace_image ,2);
