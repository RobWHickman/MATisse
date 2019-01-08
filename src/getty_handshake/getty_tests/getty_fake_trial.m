function getty_fake_trial(bits_out, shake_in, trial)

%generate the fake getty values
disp('---------------------');
valToGetty = fake_getty_array(trial);

%test the output stream
%and then send values to Getty
global d_output_stream
for i = 1:valToGetty(1)
   d_output_stream.writeInt(valToGetty(i));
end
d_output_stream.flush;

%look for handshake
n=0;
disp('receiving getty handshake');
while n==0
    %is handshake up
    shake_in_value = inputSingleScan(shake_in);
    if shake_in_value==1
        break
    end
end

disp(bits_out)

%send hard trigger
disp('sending hard trigger');
outputSingleScan(bits_out.trigger_out, 1)
pause(0.1)
% set the hardtrigger down
outputSingleScan(bits_out.trigger_out, 0)

disp('RUNNING TRIAL');
outputSingleScan(bits_out.timing_out1, 1)
rand_time1 = 1 + rand;
WaitSecs(rand_time1);
outputSingleScan(bits_out.timing_out1, 0)

outputSingleScan(bits_out.timing_out2, 1)
WaitSecs(1);
outputSingleScan(bits_out.timing_out2, 0)

outputSingleScan(bits_out.timing_out3, 1)
rand_time2 = 4.5 + rand;
WaitSecs(rand_time2);
outputSingleScan(bits_out.timing_out3, 0)
% 
% outputSingleScan(bits_out.juice_out, 1)
% WaitSecs(1);
% outputSingleScan(bits_out.juice_out, 0)
% 
% outputSingleScan(bits_out.water_out, 1)
% WaitSecs(0.5);
% outputSingleScan(bits_out.water_out, 0)
% 
outputSingleScan(bits_out.timing_out4, 1)
WaitSecs(1);
outputSingleScan(bits_out.timing_out4, 0)

disp('closing trial');
outputSingleScan(bits_out.shake_out, 1)
pause(0.1)
outputSingleScan(bits_out.shake_out, 0)
