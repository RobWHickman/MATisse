function getty_fake_trial(timing, juice)

%fractal display
disp('displaying fractal')
getty_send_bits(timing, 1, 1)
WaitSecs(3);
getty_send_bits(timing, 1, 0)

%win display
disp('removing fractal')
getty_send_bits(timing, 4, 1)
WaitSecs(1);
getty_send_bits(timing, 4, 0)

%pay juice
disp('paying juice')
getty_send_bits(juice, 1, 1)
WaitSecs(1);
getty_send_bits(juice, 1, 0)

disp('trial completed!');
