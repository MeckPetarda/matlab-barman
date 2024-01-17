function sendSerial(conn, msg)
    attempts = 0;

    while attempts < 5
        attempts = attempts + 1;
        write(conn, msg, 'char');

        startTime = tic;

        while toc(startTime) < 3

            if conn.NumBytesAvailable == 0
                continue;
            end

            return;
        end

    end

    if isempty(response)
        throw(MException('serial:noResponse', 'No response received'));
    end

end
