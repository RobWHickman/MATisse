%generates a table of interval times 
%this is for 8 epochs and has 3 columns:
%the time length (s) of each epoch
%how much this might be extended by +/- (s)
%what each epoch is 'doing'

%this is not a function to be run, it's probably best to manually edit the
%tables as you copy a new task directory
%this is just if you need to quickly re-initialise a table and save it
%because you've lost any copies or whatever
interval_times = table([1;1;1;1.5;6;1;1;4],...
    [0;0;0;0;0;0;0;0],...
    {'fixation';'fractal_display';'bidspace_display';'bid_bad_display';'bidding_phase';'display_result';'payout';'intertrial_interval'},...
    'VariableNames',{'Time','PlusMinus','Description'},...
    'RowNames',{'epoch1','epoch2','epoch3','epoch4','epoch5','epoch6','epoch7','epoch8'});

%save it in the current working directory
save intervals.mat interval_times

%how to access a column/row nicely for use in code later
interval_times.Time('epoch1') %get the length of epoch 1 in seconds
