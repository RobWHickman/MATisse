%function to create two mirror image bidspace bars with hatched fill
%these are generated from a grating that is stretched to be rectangular
%one forms the template for the bidspace and the reverse indicates to the
%monkey the remaining budget in the win condition
function bidspace = generate_bidspace(parameters, screen_info, task_window, frame_width)
%read the bidspace image in
bidspace_image = imread(fullfile(settings.images_path, settings.bidspace_images));

bidspace_info = [];
%how wide over the bidspace should the bars reach
bidspace_info.frame_width = settings.bidspace_overhang;

%get the dimensions of the bidspace
image_size = size(bidspace_image);
bidspace_info.height = image_size(1);
bidspace_info.width = image_size(2);

%check that the image is at least half the height of the screen and an
%eight of the width
if((image_size(1) < screen_info.height / 2) && (image_size(2) < screen_info.width / 8))
    display('bidspace image is too small for the screen!!');
end

%crop the image to a good size for the experiment
%image should be repeating so cropping doesnt affect presentation
bidspace = imcrop(bidspace_image, [0 0 screen_info.width/6 screen_info.height/1.25]);
%generate a flipped image to show spent budget
reverse_bidspace = flipdim(bidspace ,2);

%get the new size and set the dimensions for the information
image_size = size(bidspace);

bidspace_info.height = image_size(1);
bidspace_info.width = image_size(2);

%set the coordinates for the bidspace image
bidspace_info.position = [((screen_info.width /2) + (screen_info.percent_x * 10)),...
    (screen_info.height - bidspace_info.height)/2,...
    ((screen_info.width /2) + (screen_info.percent_x * 10)) + screen_info.width/6,...
    screen_info.height - ((screen_info.height - bidspace_info.height)/2)]; 

%set the initial values (colour and y adjust from initial value) for the
%bidding bar
%bidspace_info.bidding_colour = [parameters.screen.white/2 0 0];
bidspace_info.y_adjust = 0;
%set the starting frame_count(0) and the max frames for the bidding to
%pause for
bidspace_info.frame_count = 0;
bidspace_info.max_pause = 60;

%make it into a texture
bidspace_texture = Screen('MakeTexture', task_window, bidspace);

%generate a white frame for the bidspace to help the monkey focus
shift_outwards = frame_width / 2;
bidspace_frame = bidspace_info.position + shift_outwards;
bidspace_frame(1:2) = bidspace_frame(1:2) - 2 * shift_outwards;
[bidspace_xcenter, bidspace_ycenter] = RectCenter(bidspace_info.position);
bidspace_bounding_box = CenterRectOnPointd(bidspace_frame, bidspace_xcenter, bidspace_ycenter);

%prep for output
bidspace.bidspace_texture = bidspace_texture;
bidspace.reverse_bidspace = reverse_bidspace;
bidspace.bidspace_info = bidspace_info;
bidspace.bidspace_bounding_box = bidspace_bounding_box;
