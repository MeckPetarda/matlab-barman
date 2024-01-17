classdef gui < matlab.apps.AppBase

    % Properties that correspond to goi components
    properties (Access = public)
        UIFigure matlab.ui.Figure
        HTML matlab.ui.control.HTML

    end

    properties (Access = private)
        menu;
        commands;
        makingDrink = false;
        drinkData;
        instructions;
        instructionIndex = 1;
        selectorArmAngle = 0;
        board % The serial connection to the ARDUINO board
    end

    methods (Access = private)

        function performGCode(app, code)
            ANGLE_STEP = 360/10;
            ROTOR_GEAR_RATIO = 2;
            ROTOR_NUMBER_OF_STEPS_PER_REVOLUTION = 800;

            LIFT_NUMBER_OF_STEPS_PER_UNIT = 400;
            LIFT_PER_REVOLUTION_MM = 150;
            TRIGGER_LIFT_HEIGHT = 100;

            TRIGGER_STEPS = round((TRIGGER_LIFT_HEIGHT / LIFT_PER_REVOLUTION_MM) * LIFT_NUMBER_OF_STEPS_PER_UNIT);

            drink_instructions = [struct("command", "", "message", "")];
            drink_instructions = drink_instructions(2:end);

            for i = 1:size(code)
                word = char(code(i));
                leadingChar = word(1);

                if leadingChar == 'N'

                    DRINK_CREATION_STEPS = str2double(char(code(i + 1)));

                elseif leadingChar == 'G'

                    index = str2double(char(code(i + 1)))
                    count = str2double(char(code(i + 2)))

                    if (index == 11)

                        MIX_DISTANCE = 500;
                        MIX_STEPS = round((MIX_DISTANCE / LIFT_PER_REVOLUTION_MM) * LIFT_NUMBER_OF_STEPS_PER_UNIT);

                        drink_instructions(end + 1) = struct( ...
                            "command", strcat("1:0:", num2str(MIX_STEPS)), ...
                            "message", "Mixing" ...
                        )
                        drink_instructions(end + 1) = struct( ...
                            "command", strcat("2:1:100"), ...
                            "message", "" ...
                        );
                        drink_instructions(end + 1) = struct( ...
                            "command", strcat("1:1:", num2str(MIX_STEPS)), ...
                            "message", "" ...
                        );

                    else
                        destination = (index - 1) * ANGLE_STEP;

                        dir1 = destination - app.selectorArmAngle;
                        dir2 = destination - app.selectorArmAngle + 360;

                        rotor = dir1;

                        if abs(dir1) > abs(dir2)
                            rotor = dir2;
                        end

                        rotor_steps = round((rotor / 360) .* ROTOR_NUMBER_OF_STEPS_PER_REVOLUTION .* ROTOR_GEAR_RATIO);

                        app.selectorArmAngle = mod(app.selectorArmAngle + rotor, 360);

                        if abs(rotor_steps) > 0
                            dir = 0;

                            if (rotor_steps < 0)
                                dir = 1;
                            end

                            drink_instructions(end + 1) = struct( ...
                                "command", strcat("0:", num2str(dir), ":", num2str(abs(rotor_steps))), ...
                                "message", strcat("Adding ", char(app.commands(index, :).drink)) ...
                            )
                        end

                        for j = 1:count

                            drink_instructions(end + 1) = struct( ...
                                "command", strcat("1:1:", num2str(TRIGGER_STEPS)), ...
                                "message", "" ...
                            );
                            drink_instructions(end + 1) = struct( ...
                                "command", strcat("1:0:", num2str(TRIGGER_STEPS)), ...
                                "message", "" ...
                            );

                        end

                    end

                    i = i + 2;
                end

            end

            app.instructions = drink_instructions;
            app.instructionIndex = 1;
            app.performInstructions();
        end

        function performInstructions(app)

            if isempty(app.instructions) || length(app.instructions) < app.instructionIndex; return; end

            if (app.instructions(app.instructionIndex).message == ""); return; end

            event = struct( ...
                "total", length(app.instructions), ...
                "progress", app.instructionIndex, ...
                "message", app.instructions(app.instructionIndex).message ...
            );

            sendEventToHTMLSource(app.HTML, "updateProgress", jsonencode(event));

            sendSerial(app.board, 'ready?');
        end

        function sendInstruction(app)
            sendSerial(app.board, app.instructions(app.instructionIndex).command);

            app.instructionIndex = app.instructionIndex + 1;
        end

        function readSerialData(app, src, ~)

            if (src.NumBytesAvailable == 0)
                return;
            end

            data = strtrim(char(read(app.board, src.NumBytesAvailable, "uint8")));

            if data == "ready to recieve;"
                app.sendInstruction();
            end

            if data == "continue;"
                app.performInstructions();
            end

        end

        function handleEvent(app, event)
            name = event.HTMLEventName;

            switch name
                case "selectDrink"

                    if app.makingDrink
                        return
                    end

                    drinkName = event.HTMLEventData;

                    app.drinkData = app.menu(strcmp(drinkName, app.menu(:, 1)), :);
                    app.makingDrink = true;

                    event = struct("view", "DRINK_DETAIL", "drinkName", drinkName);

                    sendEventToHTMLSource(app.HTML, "updateView", jsonencode(event));
                case "returnToMenu"
                    app.makingDrink = false;

                    app.instructions = [];
                    app.instructionIndex = 1;

                    event = struct("view", "DRINK_SELECT");

                    sendEventToHTMLSource(app.HTML, "updateView", jsonencode(event));
                case "beginDrink"
                    event = struct("view", "DRINK_PROGRESS");

                    sendEventToHTMLSource(app.HTML, "updateView", jsonencode(event));

                    code = parseGCode(app.drinkData(2));
                    app.performGCode(code);

            end

        end

    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.board = serialport('COM3', 9600);

            InputBufferSize = 8;
            Timeout = 0.1;
            set(app.board, 'InputBufferSize', InputBufferSize);
            set(app.board, 'Timeout', Timeout);
            configureTerminator(app.board, double(';'))

            configureCallback(app.board, "terminator", @(src, event) readSerialData(app, src, event))

            fopen(app.board);
            pause(1);

            app.HTML.HTMLEventReceivedFcn = @(txt, event) handleEvent(app, event);
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
            app.HTML.Position = [0 0 640 480];
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
            assert(size(menu, 2) == 2)

            app.menu = menu;
            sendEventToHTMLSource(app.HTML, "updateMenu", jsonencode(app.menu));
        end

        function setCommands(app, commands)
            assert(size(commands, 2) == 3)

            app.commands = commands;
        end

    end

end
