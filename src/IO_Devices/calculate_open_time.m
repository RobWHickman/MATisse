function tap_open_time = calculate_open_time(results, tap)

if tap == 1
    intercept = 0.07524;
    gradient = 5.58608;
elseif tap == 2
    intercept = 0.08763; 
    gradient = 5.84300;
elseif tap == 3
    intercept = -0.1574;
    gradient = 4.0104;
end

tap_open_time = (results  - intercept) / gradient;
if tap_open_time < 0;
    tap_open_time = 0;
end

end
