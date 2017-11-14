%generates a table of interval times 
%this is for 8 epochs and has 3 columns:
%the time length (s) of each epoch
%how much this might be extended by +/- (s)
%what each epoch is 'doing'
function interval_times = set_interval_timings()
interval_times = table([1;1;1;1.5;6;1;1;4],...
    [0;0;0;0.5;0;0;0;2],...
    {'fixation';'fractal_display';'bidspace_display';'bid_bad_display';'bidding_phase';'display_result';'payout';'intertrial_interval'},...
    'VariableNames',{'Time','PlusMinus','Description'},...
    'RowNames',{'epoch1','epoch2','epoch3','epoch4','epoch5','epoch6','epoch7','epoch8'});

%save it in the current working directory
save interval_times.mat interval_times
