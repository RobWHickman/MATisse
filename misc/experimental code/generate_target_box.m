%function to generate a semi transparent box randomly within the bidspace 
%to be used as a target for monkey bidding
function stimuli = generate_target_box(stimuli)

%get the y coordinates of the bounding box which will supply the limits of
%the target zone
bidspace_limits = stimuli.bidspace_bounding_box.position;

%make sure the width of the target box is slightly wider than the bidding
%bars
target_box_width = stimuli.overhang;

%semi transparent light blue colouring
target_box_colour = [0, 0.8, 1, 0.5];