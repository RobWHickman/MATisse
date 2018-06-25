function data = eye_debug(yellow, blue, one, two, three, name)
    nidaq = analoginput('nidaq','Dev1');
    addchannel(nidaq, 0:7);
    nidaq.SampleRate = 200;
    nidaq.SamplesPerTrigger = inf;
    nidaq.UserData = zeros(1,3);
    start(nidaq);

    pause(0.5);
    
    data = peekdata(nidaq, 200);
    pins = repmat([yellow, blue, one, two, three], length(data), 1);
    
    data = [data pins];
    
    figure;
    hold on
    for ii = 1:8
    %for ii = 3:4
        plot(data(:,ii))
    end

    csvwrite(strcat('C:/Users/Alaa/Desktop/', name), data)
    
    daqreset
end
  

