function tap_open_time = calculate_open_time(results, tap)

if tap == 1
    intercept = 0.07542;
    gradient = 5.852;
elseif tap == 2
    intercept = 0.08763; 
    gradient = 5.84300;
elseif tap == 3
    intercept = -0.08639;
    gradient = 3.18338;
end

if results > 0
    tap_open_time = (results  - intercept) / gradient;
else
    tap_open_time = 0;
end
if tap_open_time < 0;
    tap_open_time = 0;
end
end
