classdef app2 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        PanelDatos           matlab.ui.container.Panel
        KEditFieldLabel      matlab.ui.control.Label
        KEditField           matlab.ui.control.NumericEditField
        P0EditFieldLabel     matlab.ui.control.Label
        P0EditField          matlab.ui.control.NumericEditField
        rEditFieldLabel      matlab.ui.control.Label
        rEditField           matlab.ui.control.NumericEditField
        TiempoEditFieldLabel matlab.ui.control.Label
        TiempoEditField      matlab.ui.control.NumericEditField
        CalcularButton       matlab.ui.control.Button
        LimpiarButton        matlab.ui.control.Button
        UIAxes               matlab.ui.control.UIAxes
        TituloLabel          matlab.ui.control.Label
        EcuacionLabel        matlab.ui.control.Label
        InterpretacionArea   matlab.ui.control.TextArea
        InterpretacionLabel  matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalcularButton
        function CalcularButtonPushed(app, ~)
            % 1. Obtener datos
            K = app.KEditField.Value;   % Capacidad de carga
            P0 = app.P0EditField.Value; % Población inicial
            r = app.rEditField.Value;   % Tasa de crecimiento
            t_max = app.TiempoEditField.Value;

            % 2. Validaciones
            if K <= P0
                uialert(app.UIFigure, 'La capacidad de carga (K) debe ser mayor que la población inicial.', 'Dato ilógico');
                return;
            end
            if r <= 0 || t_max <= 0
                uialert(app.UIFigure, 'La tasa (r) y el tiempo deben ser positivos.', 'Error');
                return;
            end

            % 3. Modelo Matemático (Solución Logística)
            % P(t) = K / (1 + ((K - P0)/P0) * e^(-r*t))
            
            t = linspace(0, t_max, 100);
            A = (K - P0) / P0;
            P = K ./ (1 + A * exp(-r * t));

            % 4. Graficar
            plot(app.UIAxes, t, P, 'g-', 'LineWidth', 2); % Línea verde
            hold(app.UIAxes, 'on');
            yline(app.UIAxes, K, '--r', 'LineWidth', 1.5, 'Label', 'Capacidad Máxima (K)');
            hold(app.UIAxes, 'off');

            % Decoración
            title(app.UIAxes, 'Crecimiento Poblacional Logístico');
            xlabel(app.UIAxes, 'Tiempo (horas)');
            ylabel(app.UIAxes, 'Número de Bacterias');
            grid(app.UIAxes, 'on');
            app.UIAxes.YLim = [0, K * 1.1]; % Dar un poco de margen arriba

            % 5. Interpretación
            p_final = P(end);
            mensaje = sprintf(['Resultados:\n' ...
                '- Inicio: %d bacterias.\n' ...
                '- Final (%.1f hrs): %.0f bacterias.\n' ...
                '- La población se estabiliza cerca del límite de %d.'], ...
                P0, t_max, p_final, K);
            app.InterpretacionArea.Value = mensaje;
        end

        % Button pushed function: LimpiarButton
        function LimpiarButtonPushed(app, ~)
            app.KEditField.Value = 0;
            app.P0EditField.Value = 0;
            app.rEditField.Value = 0;
            app.TiempoEditField.Value = 0;
            app.InterpretacionArea.Value = '';
            cla(app.UIAxes);
            title(app.UIAxes, 'Esperando datos...');
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 800 550];
            app.UIFigure.Name = 'Modelo Logístico';

            app.TituloLabel = uilabel(app.UIFigure);
            app.TituloLabel.FontSize = 20;
            app.TituloLabel.FontWeight = 'bold';
            app.TituloLabel.Position = [230 507 400 36];
            app.TituloLabel.Text = 'Crecimiento de Población (Bacterias)';

            app.EcuacionLabel = uilabel(app.UIFigure);
            app.EcuacionLabel.FontColor = [0 0.45 0.74];
            app.EcuacionLabel.Position = [280 480 300 22];
            app.EcuacionLabel.Text = 'dP/dt = r * P * (1 - P/K)';

            app.PanelDatos = uipanel(app.UIFigure);
            app.PanelDatos.Title = 'Condiciones Iniciales';
            app.PanelDatos.Position = [28 178 244 286];

            app.KEditFieldLabel = uilabel(app.PanelDatos);
            app.KEditFieldLabel.HorizontalAlignment = 'right';
            app.KEditFieldLabel.Position = [10 233 120 22];
            app.KEditFieldLabel.Text = 'Capacidad (K)';

            app.KEditField = uieditfield(app.PanelDatos, 'numeric');
            app.KEditField.Position = [144 233 80 22];
            app.KEditField.Value = 1000;

            app.P0EditFieldLabel = uilabel(app.PanelDatos);
            app.P0EditFieldLabel.HorizontalAlignment = 'right';
            app.P0EditFieldLabel.Position = [10 193 120 22];
            app.P0EditFieldLabel.Text = 'Población Inicial (P0)';

            app.P0EditField = uieditfield(app.PanelDatos, 'numeric');
            app.P0EditField.Position = [144 193 80 22];
            app.P0EditField.Value = 10;

            app.rEditFieldLabel = uilabel(app.PanelDatos);
            app.rEditFieldLabel.HorizontalAlignment = 'right';
            app.rEditFieldLabel.Position = [10 153 120 22];
            app.rEditFieldLabel.Text = 'Tasa Crecimiento (r)';

            app.rEditField = uieditfield(app.PanelDatos, 'numeric');
            app.rEditField.Position = [144 153 80 22];
            app.rEditField.Value = 0.5;

            app.TiempoEditFieldLabel = uilabel(app.PanelDatos);
            app.TiempoEditFieldLabel.HorizontalAlignment = 'right';
            app.TiempoEditFieldLabel.Position = [10 113 120 22];
            app.TiempoEditFieldLabel.Text = 'Tiempo (Horas)';

            app.TiempoEditField = uieditfield(app.PanelDatos, 'numeric');
            app.TiempoEditField.Position = [144 113 80 22];
            app.TiempoEditField.Value = 20;

            app.CalcularButton = uibutton(app.PanelDatos, 'push');
            app.CalcularButton.ButtonPushedFcn = createCallbackFcn(app, @CalcularButtonPushed, true);
            app.CalcularButton.BackgroundColor = [0.1 0.6 0.2];
            app.CalcularButton.FontColor = [1 1 1];
            app.CalcularButton.Position = [24 61 196 32];
            app.CalcularButton.Text = 'SIMULAR';

            app.LimpiarButton = uibutton(app.PanelDatos, 'push');
            app.LimpiarButton.ButtonPushedFcn = createCallbackFcn(app, @LimpiarButtonPushed, true);
            app.LimpiarButton.Position = [24 20 196 22];
            app.LimpiarButton.Text = 'Reiniciar';

            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.Position = [299 178 468 286];
            xlabel(app.UIAxes, 'Tiempo'); ylabel(app.UIAxes, 'Población');

            app.InterpretacionLabel = uilabel(app.UIFigure);
            app.InterpretacionLabel.FontWeight = 'bold';
            app.InterpretacionLabel.Position = [28 139 200 22];
            app.InterpretacionLabel.Text = 'Análisis Automático:';

            app.InterpretacionArea = uitextarea(app.UIFigure);
            app.InterpretacionArea.Editable = 'off';
            app.InterpretacionArea.Position = [28 29 739 100];

            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)
        function app = app2
            createComponents(app)
            registerApp(app, app.UIFigure)
            if nargout == 0, clear app, end
        end
        function delete(app)
            delete(app.UIFigure)
        end
    end
end