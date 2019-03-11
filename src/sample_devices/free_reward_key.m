function [] = free_reward_key()

[keyIsDown, keyTime, keyCode] = KbCheck;

if keyIsDown
    disp('KEY PRESS');
else
    disp('no key press');
end