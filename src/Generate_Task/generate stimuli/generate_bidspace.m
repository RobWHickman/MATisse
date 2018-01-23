%function to create two mirror image bidspace bars with hatched fill
%these are generated from a grating that is stretched to be rectangular
%one forms the template for the bidspace and the reverse indicates to the
%monkey the remaining budget in the win condition
function bidspace = generate_bidspace(parameters, modifiers, task_window, width, height)
%read the bidspace image in
bidspace_image = imread(fullfile(modifiers.fractals.folder, modifiers.budget.string));

%get the dimensions of the bidspace
image_size = size(bidspace_image);
bidspace_info.height = image_size(1);
bidspace_info.width = image_size(2);

%check that the image is at least half the height of the screen and an
%eight of the width
if((image_size(1) < height / 2) && (image_size(2) < width / 8))
    display('bidspace image is too small for the screen!!');
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
end

bidspace_image = imcrop(bidspace_image, [0 0 width/screen_width_fraction height/screen_height_fraction]);
%make it into a texture
bidspace_texture = Screen('MakeTexture', task_window, bidspace_image);

%get the new size and set the dimensions for the information
image_size = size(bidspace_image);

dimensions.height = image_size(1);
dimensions.width = image_size(2);

%set the default (red) colour for the bar during bidding activity
%also set the thickness of bar during bidding
bidspace_info.bidding_colour = [screen_info.white 0 0];
bidspace_info.bidding_thickness = 15;
%how much the rect will grow by (x2) when bid is confirmed
bidspace_info.bidding_growth = 10;

%set the coordinates for the bidspace image
if strcmp(parameters.task.type, 'BDM')
position = [((width /2) + ((width/100) * 10)),...
    (height - height)/2,...
    ((width /2) + ((width/100) * 10)) + width/screen_width_fraction,...
    height - ((height - bidspace_info.height)/2)];
elseif strcmp(parameters.task.type, 'BC')
position = [((width /2) - ((width/100) * 23.5)),...
    (height - (height/100) * (100 - 100 /screen_height_fraction)/2) - bidspace_info.height,...
    ((width /2) - ((width/100) * 23.5)) + width/screen_width_fraction,...
    (height - (height/100) * (100 - 100 /screen_height_fraction)/2)];
end    

%generate a white frame for the bidspace to help the monkey focus
bounding_width = modifiers.budget.overhang/2;
bidspace_frame = position + bounding_width;
bidspace_frame(1:2) = bidspace_frame(1:2) - 2 * bounding_width;
[bidspace_xcenter, bidspace_ycenter] = RectCenter(position);
bidspace_bounding_box = CenterRectOnPointd(bidspace_frame, bidspace_xcenter, bidspace_ycenter);

%generate a flipped image to show spent budget
reverse_bidspace = flipdim(bidspace_image ,2);

%prep for output
bidspace.texture = bidspace_texture;
bidspace.position = position;
bidspace.dimensions = dimensions;
bidspace.bidspace_bounding_box = bidspace_bounding_box;
bidspace.reverse_bidspace = reverse_bidspace;
