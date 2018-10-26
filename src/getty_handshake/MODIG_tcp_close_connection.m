function TCPCloseConnection


    global server_socket
    global output_socket
    
%     if ~isempty(server_socket)
        server_socket.close    
        clear server_socket
%     end

%     if ~isempty(output_socket)
        output_socket.close
        clear output_socket
%     end
    fprintf('Success closing connection\n')
end