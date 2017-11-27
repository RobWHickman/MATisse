%function to generate a semi transparent box randomly within the bidspace 
%to be used as a target for monkey bidding
function target_box = generate_target_box(stimuli, hardware)

target_box_box_length = stimuli.bidspace.bidspace_info.height / 1.1; %change this to a random value
%target_box_box_length = 

%generates the upper (in space not value) limit on the targeting box
target_box_y1 = stimuli.bidspace.bidspace_info.position(2);
target_box_y2 = target_box_y1 + target_box_box_length;


%make sure the width of the target box is slightly wider than the bidding
%bars
target_box_width = stimuli.bidspace.bidspace_info.frame_width * 3;
%get the x value
target_box_x1 = stimuli.bidspace.bidspace_info.position(1) - target_box_width;
target_box_x2 = stimuli.bidspace.bidspace_info.position(3) + target_box_width;

%get the full position
target_box_position = [target_box_x1, target_box_y1, target_box_x2, target_box_y2];
%semi transparent light blue colouring
target_box_colour = [0 0 hardware.outputs.screen_info.white];

target_box.position = target_box_position;
target_box.colour = target_box_colour;
target_box.length = target_box_box_length;


