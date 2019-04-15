function tap_open_time = calculate_open_time(tap, liquid)

if tap == 1
    intercept = -0.1077;
    gradient = 5.9679;
elseif tap == 2
    intercept = 0.0469; 
    gradient = 5.1401;
elseif tap == 3
    intercept = -0.0936;
    gradient = 3.1693;
end

if liquid > 0
    tap_open_time = (liquid  - intercept) / gradient;
else
    tap_open_time = 0;
end
if tap_open_time < 0
    tap_open_time = 0;
end
end
