function dataToGetty = fake_getty_array(trial)

    %trial number
    getty_trial_number = fi_numTo2bytes(trial);

    %if error or not
    situation = randi([1, 10]);
    if situation < 7
        situation = 1;
    else
        situation = 0;
    end

    %trial type
    %BDM, BCb, PAV
    trial_type = randi([1, 3]);

    %fractal_value
    fractal_value = randi([1, 3]);

    dataToGetty=[];
    dataToGetty(1:2) = getty_trial_number;
    dataToGetty(3:4) = [0 0]; %used by getty to encode duration
    dataToGetty(5) = situation;
    dataToGetty(6) = trial_type;
    dataToGetty(7) = fractal_value;

    % add first value (array length)
    dataToGetty = [length(dataToGetty)+1 dataToGetty];
end
    
function nb = fi_numTo2bytes(n)
    if n>2^16, error(['n. out of range (max 65536): ',n2str(n)]); end
    nb = [fix(n/256) mod(n,256)];
end