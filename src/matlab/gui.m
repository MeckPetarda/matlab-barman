classdef gui < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure  matlab.ui.Figure
        HTML      matlab.ui.control.HTML
        board

    end

    properties (Access = private)
        menu;
        makingDrink = false;
        drinkData;
        instructions;
        instructionIndex = 1;
        waitingForConfirmation = false;
    end


    methods (Access = private)
        function performGCode(app, code)
            for i = 1:size(code)
                word = char(code(i));
                leadingChar = word(1);

                switch leadingChar
                    case 'N'

                    case 'G'
                        if word(2) == '1'
                            index = char(code(i + 1))
                            count = char(code(i + 2))

                            i = i + 2;
                        end
                end
            end

        end

        function performInstructions(app)
            if ~isempty(app.instructions) && length(app.instructions) >= app.instructionIndex
                app.waitingForConfirmation = true;

                % fprintf(app.board, char(['ready?']));
                app.sendSerial('ready?');
            end
        end

        function sendSerial(app, msg)
            attempts = 0;
            while attempts < 5
                attempts = attempts + 1;
                write(app.board, msg, 'char');

                startTime = tic;
                while toc(startTime) < 3
                    if app.board.NumBytesAvailable == 0
                        continue;
                    end

                    return;
                end
            end

            if isempty(response)
                throw(MException('serial:noResponse', 'No response received'));
            end
        end


        function sendInstruction(app)
            app.sendSerial(app.instructions(app.instructionIndex));
            % fprintf(app.board, char([app.instructions(app.instructionIndex)]));
            app.instructionIndex = app.instructionIndex + 1;
        end


        function [res] = parseGCode(app, code)
            commands = split(code, " ");
            res = [];

            for i = 1:size(commands)
                parts = split(commands(i), ";");
                res = cat(1, res, parts);
            end
        end

        function readSerialData(app, src, data)
            if (src.NumBytesAvailable == 0)
                return;
            end

            data = strtrim(char(read(app.board, src.NumBytesAvailable, "uint8")))

            if data == "ready to recieve;"
                app.sendInstruction();
            end

            if data == "continue;"
                app.performInstructions();
            end
        end

        function handleEvent(app,event)
            name = event.HTMLEventName;

            switch name
                case "selectDrink"
                    if app.makingDrink
                        return
                    end

                    drinkName = event.HTMLEventData;

                    app.drinkData = app.menu(strcmp(drinkName, app.menu(:, 1)), :);
                    app.makingDrink = true;

                    event = struct("view", "DRINK_DETAIL","drinkName", drinkName);

                    sendEventToHTMLSource(app.HTML,"updateView", jsonencode(event));
                case "returnToMenu"
                    app.makingDrink = false;

                    event = struct("view", "DRINK_SELECT");

                    sendEventToHTMLSource(app.HTML,"updateView", jsonencode(event));
                case "beginDrink"
                    event = struct("view", "DRINK_PROGRESS");

                    sendEventToHTMLSource(app.HTML,"updateView", jsonencode(event));

                    app.instructions = ["1:0:400&0:1:400", "1:1:200&1:0:200&1:1:400"];
                    app.instructionIndex = 1;
                    app.performInstructions();
            end

        end

        function updateMenu(app)
            sendEventToHTMLSource(app.HTML,"updateMenu", jsonencode(app.menu));
        end
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.board=serialport('COM3',9600);

            InputBufferSize = 8;
            Timeout = 0.1;
            set(app.board , 'InputBufferSize', InputBufferSize);
            set(app.board , 'Timeout', Timeout);
            configureTerminator(app.board, double(';'))

            configureCallback(app.board, "terminator", @(src,event) readSerialData(app, src, event))

            fopen(app.board);
            pause(1);

            app.HTML.HTMLEventReceivedFcn = @(txt,event) handleEvent(app,event);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create HTML
            app.HTML = uihtml(app.UIFigure);
            app.HTML.HTMLSource = '../../dist/index.html';
            app.HTML.Position = [1 1 640 480];
            app.HTML.Data = '{ "count": 8 }';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = gui

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)
            % Delete UIFigure when app is deleted
            delete(app.UIFigure);
            delete(app.board);
            fclose(app.board);
        end

        function setMenu(app, menu)
            assert(size(menu,2) == 3)

            app.menu = menu;
            app.updateMenu();
        end
    end
end