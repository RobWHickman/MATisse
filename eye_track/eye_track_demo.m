%% SET UP DEMO
% Clear the workspace and the screen
sca;
close all;
clear all;
clc;
clearvars;
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
% Get the screen numbers
screens = Screen('Screens');
% Draw to the external screen if avaliable
screenNumber = max(screens);
% Define black and white
black = BlackIndex(screenNumber);
% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 200 200];
% Screen X positions of our three rectangles
squareXpos = [screenXpixels * 0.1 screenXpixels * 0.5 screenXpixels * 0.9 screenXpixels * 0.5 screenXpixels * 0.5];
squareYpos = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.1 screenYpixels * 0.9];
numSqaures = length(squareXpos);
allColors = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1];
% Make our rectangle coordinates
allRects = nan(4, 3);
for i = 1:numSqaures
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), squareYpos(i));
end
% Draw the rect to the screen
Screen('FillRect', window, allColors', allRects);

%generate a cursor
dotColour = [1 1 1];
dotXpos = 0.5 * screenXpixels;
dotYpos = 0.5 * screenYpixels;
dotSizePix = 20;
Screen('DrawDots', window, [dotXpos dotYpos], dotSizePix, dotColour, [], 2);
% Flip to the screen
Screen('Flip', window);


%move the cursor with the joystick
joystick = daq.createSession('ni');
addAnalogInputChannel(joystick, 'Dev1','ai8','Voltage');
addAnalogInputChannel(joystick, 'Dev1','ai9','Voltage');
joy_x_bias = 3.077;
joy_y_bias = 0.026;
movement_scalar = 10;
while ~KbCheck
    joystick_sample = inputSingleScan(joystick);
    joy_x_move = joystick_sample(1) + joy_x_bias;
    joy_y_move = joystick_sample(2) + joy_y_bias;
    if(joy_x_move > 0.3)
        cursor_move_x = 1;
    elseif(joy_x_move < -0.3)
        cursor_move_x = -1;
    else
        cursor_move_x = 0;
    end
    if(joy_y_move > 0.3)
        cursor_move_y = 1;
    elseif(joy_y_move < -0.3)
        cursor_move_y = -1;
    else
        cursor_move_y = 0;
    end
    dotXpos = dotXpos + (movement_scalar * cursor_move_x);
    dotYpos = dotYpos + (movement_scalar * cursor_move_y);
    
    if(dotXpos > screenXpixels)
        dotXpos = screenXpixels;
    elseif(dotXpos < 0)
        dotXpos = 0;
    end
    if(dotYpos > screenYpixels)
        dotYpos = screenYpixels;
    elseif(dotYpos < 0)
        dotYpos = 0;
    end
    Screen('FillRect', window, allColors', allRects);
    Screen('DrawDots', window, [dotXpos dotYpos], dotSizePix, dotColour, [], 2);
    % Flip to the screen
    Screen('Flip', window);
end



%% END DEMO
% Wait for a key press
KbStrokeWait;

% Clear the screen
sca;
