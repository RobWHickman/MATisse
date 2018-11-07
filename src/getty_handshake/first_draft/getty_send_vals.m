function getty_send_vals(trial)

valToGetty = fake_getty_array(trial);

disp('sending vals to getty');
disp(valToGetty);

%test the output stream
%and then send values to Getty
global d_output_stream
for i = 1:valToGetty(1)
   d_output_stream.writeInt(valToGetty(i));
end
d_output_stream.flush;
