function success = MODIG_tcp_open_connection()
% function TCPOpenConnection%(host) %original version, does not run; FG
% 10/13


    global d_output_stream
    global server_socket
    global output_socket
    
    import java.net.ServerSocket
    import java.io.*
     
    success = false;
    
    permitedClient = '/131.111.33.50';
    
    
    output_port = 8154;
    number_of_retries = 3; % set to -1 for infinite

    retry             = 0;

    server_socket  = [];
    output_socket  = [];
    
    
    
    while true

        retry = retry + 1;

        try
            if ((number_of_retries > 0) && (retry > number_of_retries))
                fprintf(1, 'Too many retries\n');
                break;
            end

            fprintf(1, ['Try %d of %d waiting for Getty to connect to this ' ...
                        'host on port : %d\n'], retry, number_of_retries, output_port);

            % wait for 1 second for client to connect server socket
            
            
            server_socket = ServerSocket(output_port);
            TimeOutSecs = 5; %Time to wait in seconds each retry.
            TimeOut = TimeOutSecs*1000;
            server_socket.setSoTimeout(TimeOut);

            output_socket = server_socket.accept;
            
            output_stream   = output_socket.getOutputStream;
            d_output_stream = DataOutputStream(output_stream);
            
            myClient = output_socket.getInetAddress;
            if ~strcmp(myClient,permitedClient)
                fprintf('refusing connection from %s\n', myClient)
                d_output_stream.writeInt(1);
                server_socket.close
                output_socket.close
                continue
            end
            d_output_stream.writeInt(0);

            fprintf(1, 'Getty connected\n');

            success = true;
            break
            
        catch
            if ~isempty(server_socket)
                server_socket.close
            end

            if ~isempty(output_socket)
                output_socket.close
            end

%             s = lasterror
%             s.message
%             s.stack
%             pause(0.5);
        end
    end
end