sca;
close all;
clearvars;
PsychDefaultSetup(2);
screens = Screen('Screens'); 
screenNumber = max(screens);

%colours
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

%open window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
%get pixel info
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

baseRect = [0 0 200 200];
centeredRect1 = CenterRectOnPointd(baseRect, xCenter-200, yCenter);
centeredRect2 = CenterRectOnPointd(baseRect, xCenter, yCenter);
centeredRect3 = CenterRectOnPointd(baseRect, xCenter+200, yCenter);
centeredRect4 = CenterRectOnPointd(baseRect, xCenter+400, yCenter);
rectColor1 = [1 0 0];
rectColor2 = [1 1 0];
rectColor3 = [1 0 1];
rectColor4 = [0 1 1];

% %draw a square and flip
% Screen('FillRect', window, rectColor1, centeredRect1);
% Screen('Flip', window, [], 1);
% display('drawn');
% KbStrokeWait;
% 
% %Screen('FillRect', window, rectColor2, centeredRect2);
% Screen('Flip', window, [], 1);
% %display('drawn2');
% KbStrokeWait;
% 
% %Screen('FillRect', window, rectColor3, centeredRect3);
% Screen('Flip', window, [], 1);
% %display('drawn3');
% KbStrokeWait;
% 
% %Screen('FillRect', window, rectColor4, centeredRect4);
% Screen('Flip', window, [], 0);
% %display('drawn4');
% KbStrokeWait;

for frame = 1:600
    if frame == 1
        Screen('FillRect', window, rectColor1, centeredRect1);
    end
    Screen('Flip', window, [], 1);
    display('drawn');
end


sca;
