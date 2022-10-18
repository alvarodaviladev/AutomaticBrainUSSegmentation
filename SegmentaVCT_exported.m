classdef SegmentaVCT_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        GridLayout                   matlab.ui.container.GridLayout
        CambiarorientacinPanel       matlab.ui.container.Panel
        PermutaACButton              matlab.ui.control.StateButton
        PermutaSCButton              matlab.ui.control.StateButton
        PermutaASButton              matlab.ui.control.StateButton
        GuardarButton                matlab.ui.control.Button
        SalirButton                  matlab.ui.control.Button
        VolumenPanel                 matlab.ui.container.Panel
        textVolumenSegmentado        matlab.ui.control.EditField
        VolumenEsLabel_2             matlab.ui.control.Label
        textVolumenEstimado          matlab.ui.control.EditField
        SegmentarCerebroButton       matlab.ui.control.Button
        VolumenEsLabel               matlab.ui.control.Label
        HerramientasPanel            matlab.ui.container.Panel
        ModificarSegmentacionButton  matlab.ui.control.Button
        VerSegmentacionButton        matlab.ui.control.StateButton
        VerGuiasButton               matlab.ui.control.StateButton
        CargaEcoPanel                matlab.ui.container.Panel
        ReiniciarSegmentacionButton  matlab.ui.control.Button
        volumeName                   matlab.ui.control.EditField
        AbrirButton                  matlab.ui.control.Button
        Panel                        matlab.ui.container.Panel
        CORONALLabel                 matlab.ui.control.Label
        SAGITALLabel                 matlab.ui.control.Label
        AXIALLabel                   matlab.ui.control.Label
        textSliderRotCoronal         matlab.ui.control.Spinner
        textSliderRotAxial           matlab.ui.control.Spinner
        textSliderCoronal            matlab.ui.control.Spinner
        textSliderSagital            matlab.ui.control.Spinner
        textSliderAxial              matlab.ui.control.Spinner
        RotacionLabel_2              matlab.ui.control.Label
        SliceLabel_3                 matlab.ui.control.Label
        SliceLabel_2                 matlab.ui.control.Label
        RotacionLabel                matlab.ui.control.Label
        SliceLabel                   matlab.ui.control.Label
        SliderRotCoronal             matlab.ui.control.Slider
        SliderRotAxial               matlab.ui.control.Slider
        SliderAxial                  matlab.ui.control.Slider
        SliderCoronal                matlab.ui.control.Slider
        SliderSagital                matlab.ui.control.Slider
        UIAxesCoronal                matlab.ui.control.UIAxes
        UIAxesSagital                matlab.ui.control.UIAxes
        UIAxesAxial                  matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        Info % volume info
        fichLeido
        filename
        pathname
        posicionX % Description
        posicionY % Description
        posicionZ % Description
        DIM % Description
        EditSegmentationApp % Description
    end
    
    methods (Access = private)
        
        function imrefresca(app)

            %actualiza Sliders
            app.SliderAxial.Value = app.posicionX;
            app.SliderSagital.Value = app.posicionY;
            app.SliderCoronal.Value = app.posicionZ;

            %actualiza spinners
            app.textSliderAxial.Value = app.posicionX;
            app.textSliderSagital.Value = app.posicionY;
            app.textSliderCoronal.Value = app.posicionZ;

            app.textVolumenEstimado.Value = num2str(app.Info.volumen);
            app.textVolumenSegmentado.Value = num2str(sum(app.Info.Vseg(:))*prod(app.Info.spacings)*1e-3);

            
            %Axes Axial
            app.UIAxesAxial.reset
            imshow(squeeze(app.Info.rdata(app.posicionX,:,:)),[],'Parent',app.UIAxesAxial);
            if app.VerSegmentacionButton.Value
                %createMask
                l1 = boundarymask(squeeze(app.Info.Vseg(app.posicionX,:,:)));
                l2 = boundarymask(squeeze(app.Info.Velipsoide(app.posicionX,:,:)));
                maskStack = zeros(size(l1,1),size(l1,2),2);
                maskStack(:,:,1) = l1;
                maskStack(:,:,2) = l2;
                im = mat2gray(squeeze(app.Info.rdata(app.posicionX,:,:)));
                %colormap
                cmap = [255,255,0;255,0,0];
                Iseg = insertObjectMask(im,logical(maskStack),'Color',cmap);
                imshow(Iseg,'Parent',app.UIAxesAxial);
                %visboundaries(app.UIAxesAxial,squeeze(app.Info.Vseg(app.posicionX,:,:)),'color','y')
                %visboundaries(app.UIAxesAxial,squeeze(app.Info.Velipsoide(app.posicionX,:,:)),'color','r')
            end
            if app.VerGuiasButton.Value
                line(app.UIAxesAxial,1:app.DIM(3),ones(1,app.DIM(3))*app.posicionY,'Color','green');
                line(app.UIAxesAxial,ones(1,app.DIM(2))*app.posicionZ,1:app.DIM(2),'Color','blue');
            end

            %Axes Sagital
            app.UIAxesSagital.reset
            imshow(squeeze(app.Info.rdata(:,app.posicionY,:)),[],'Parent',app.UIAxesSagital);
            if app.VerSegmentacionButton.Value
                l1 = boundarymask(squeeze(app.Info.Vseg(:,app.posicionY,:)));
                l2 = boundarymask(squeeze(app.Info.Velipsoide(:,app.posicionY,:)));
                maskStack = zeros(size(l1,1),size(l1,2),2);
                maskStack(:,:,1) = l1;
                maskStack(:,:,2) = l2;
                im = mat2gray(squeeze(app.Info.rdata(:,app.posicionY,:)));
                %colormap
                cmap = [255,255,0;255,0,0];
                Iseg = insertObjectMask(im,logical(maskStack),'Color',cmap);
                imshow(Iseg,'Parent',app.UIAxesSagital);
                %visboundaries(app.UIAxesSagital,squeeze(app.Info.Vseg(:,app.posicionY,:)),'color','y')
                %visboundaries(app.UIAxesSagital,squeeze(app.Info.Velipsoide(:,app.posicionY,:)),'color','r')
            end
            if app.VerGuiasButton.Value
                line(app.UIAxesSagital, 1:app.DIM(3),ones(1,app.DIM(3))*app.posicionX,'Color','red');
                line(app.UIAxesSagital, ones(1,app.DIM(2))*app.posicionZ,1:app.DIM(2),'Color','blue');
            end
            

            %Axes Coronal
            app.UIAxesCoronal.reset
            imshow(squeeze(app.Info.rdata(:,:,app.posicionZ)),[],'Parent',app.UIAxesCoronal);
            if app.VerSegmentacionButton.Value
                l1 = boundarymask(squeeze(app.Info.Vseg(:,:,app.posicionZ)));
                l2 = boundarymask(squeeze(app.Info.Velipsoide(:,:,app.posicionZ)));
                maskStack = zeros(size(l1,1),size(l1,2),2);
                maskStack(:,:,1) = l1;
                maskStack(:,:,2) = l2;
                im = mat2gray(squeeze(app.Info.rdata(:,:,app.posicionZ)));
                %colormap
                cmap = [255,255,0;255,0,0];
                Iseg = insertObjectMask(im,logical(maskStack),'Color',cmap);
                imshow(Iseg,'Parent',app.UIAxesCoronal);
                %visboundaries(app.UIAxesCoronal,squeeze(app.Info.Vseg(:,:,app.posicionZ)),'color','y')
                %visboundaries(app.UIAxesCoronal,squeeze(app.Info.Velipsoide(:,:,app.posicionZ)),'color','r')
            end
            if app.VerGuiasButton.Value
                line(app.UIAxesCoronal, 1:app.DIM(3),ones(1,app.DIM(3))*app.posicionX,'Color','red');
                line(app.UIAxesCoronal, ones(1,app.DIM(2))*app.posicionZ,1:app.DIM(2),'Color','blue');
            end
            
            
        end
        
        function results = resetSiliderVista(app)
            %slider axial
            app.posicionX=floor(app.DIM(1)/2);
            app.textSliderAxial.Value = app.posicionX;
            app.SliderAxial.Limits = [1 app.DIM(1)];
            app.SliderAxial.Value = app.posicionX;

            %slider sagital
            app.posicionY=floor(app.DIM(2)/2);
            app.textSliderSagital.Value =app.posicionY;
            app.SliderSagital.Limits = [1 app.DIM(2)];
            app.SliderSagital.Value = app.posicionY;

            %slider coronal
            app.posicionZ=floor(app.DIM(3)/2);
            app.textSliderCoronal.Value = app.posicionZ;
            app.SliderCoronal.Limits = [1 app.DIM(3)];
            app.SliderCoronal.Value = app.posicionZ;
        end
        
        function results = resetSliderRot(app)
            app.SliderRotAxial.Value = 0;
            app.SliderRotCoronal.Value = 0;
            app.textSliderRotAxial.Value = 0;
            app.textSliderRotCoronal.Value = 0;
        end
    end
    
    methods (Access = public)
        
        function updateInfo(app,Info)
            app.Info = Info;
            app.ModificarSegmentacionButton.Enable = 'on';
            %apaga botones rotar
            app.PermutaACButton.Enable = 'off';
            app.PermutaASButton.Enable = 'off';
            app.PermutaSCButton.Enable = 'off';
            app.SliderRotCoronal.Visible = 'off';
            app.SliderRotAxial.Visible = 'off';
            app.textSliderRotAxial.Visible = 'off';
            app.textSliderRotCoronal.Visible = 'off';
            app.RotacionLabel.Visible = 'off';
            app.RotacionLabel_2.Visible = 'off';
            imrefresca(app);
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.Info = [];
            app.fichLeido = 0;
            app.textVolumenEstimado.Value = '0 ml';
            app.textVolumenSegmentado.Value = '0 ml';
            app.PermutaASButton.Value = false;
            app.PermutaASButton.Value = false;
            app.PermutaSCButton.Value = false;

            p = mfilename('fullpath');
            [func_dir,~,~] = fileparts(p);
            addpath(fullfile(func_dir, fullfile('Functions','Frangi')));
            addpath(fullfile(func_dir, fullfile('Functions','Leervol')));
            addpath(fullfile(func_dir, 'Functions'));

            app.SliderRotAxial.Limits = [-180 180];
            app.SliderRotCoronal.Limits = [-180 180];
        end

        % Button pushed function: AbrirButton
        function AbrirButtonPushed(app, event)
            if app.fichLeido 
                answer = questdlg('¿Desea guardar los cambios?', 'Guardar','Si', 'No','Si');
                    if isequal(answer,'Si')
                        app.GuardarButtonPushed()
                    end
            end
            [app.filename, app.pathname] = uigetfile({'*.*'},'Select a volume');
            if app.filename == 0
                 return
            else
                app.fichLeido=1;
                [filepath,name,~] = fileparts([app.pathname,app.filename]);
                if exist([filepath,'/',name,'VC.mat'],'file')==2
                    load([filepath,'/',name,'VC.mat'],'Info');
                    app.Info = Info;
                else
                    app.Info = leervolumen([app.pathname app.filename]);
                    if isempty(app.Info)
                      r.Interpreter = 'tex';
                      r.WindowStyle = 'modal';
                      uiwait(msgbox('\fontsize{12}Read error','','error',r));
                      return
                    end
                    app.fichLeido = 1;
                    app.Info.rdata = app.Info.data;
                    app.Info.Vseg = 0*app.Info.data;
                    app.Info.Velipsoide = 0*app.Info.data;
                    app.Info.volumen = 0;
                    app.Info.flags.rotado  = 0;
                    app.Info.flags.volumen = 0;
                    app.Info.flags.segmentado = 0;

                    %encender botones
                    app.PermutaACButton.Enable = 'on';
                    app.PermutaASButton.Enable = 'on';
                    app.PermutaSCButton.Enable = 'on';
                    app.SliderRotCoronal.Visible = 'on';
                    app.SliderRotAxial.Visible = 'on';
                    app.textSliderRotAxial.Visible = 'on';
                    app.textSliderRotCoronal.Visible = 'on';
                    app.RotacionLabel.Visible = 'on';
                    app.RotacionLabel_2.Visible = 'on';
                end 
            end

            if app.Info.flags.rotado
                app.PermutaACButton.Enable = 'off';
                app.PermutaASButton.Enable = 'off';
                app.PermutaSCButton.Enable = 'off';
                app.SliderRotCoronal.Visible = 'off';
                app.SliderRotAxial.Visible = 'off';
                app.textSliderRotAxial.Visible = 'off';
                app.textSliderRotCoronal.Visible = 'off';
                app.RotacionLabel.Visible = 'off';
                app.RotacionLabel_2.Visible = 'off';
            else
                resetSliderRot(app);
            end
            
            if app.Info.flags.volumen
                app.SegmentarCerebroButton.Enable = false;
                app.textVolumenEstimado.Value = [num2str(app.Info.volumen) ' ml'];
            else
                app.SegmentarCerebroButton.Enable = true;
            end

            app.volumeName.Value = app.filename;
            app.DIM=size(app.Info.rdata); 
            resetSiliderVista(app);
            imrefresca(app);
            
        end

        % Value changed function: SliderAxial
        function SliderAxialValueChanged(app, event)
            app.posicionX = floor(app.SliderAxial.Value);
            imrefresca(app);
        end

        % Value changed function: SliderSagital
        function SliderSagitalValueChanged(app, event)
            app.posicionY = floor(app.SliderSagital.Value);
            imrefresca(app);
        end

        % Value changed function: SliderCoronal
        function SliderCoronalValueChanged(app, event)
            app.posicionZ = floor(app.SliderCoronal.Value);
            imrefresca(app);
        end

        % Value changed function: textSliderAxial
        function textSliderAxialValueChanged(app, event)
            app.posicionX = app.textSliderAxial.Value;
            imrefresca(app);
        end

        % Value changed function: textSliderSagital
        function textSliderSagitalValueChanged(app, event)
            app.posicionY = app.textSliderSagital.Value;
            imrefresca(app);
        end

        % Value changed function: textSliderCoronal
        function textSliderCoronalValueChanged(app, event)
            app.posicionZ = app.textSliderCoronal.Value;
            imrefresca(app);
        end

        % Value changed function: PermutaASButton
        function PermutaASButtonValueChanged(app, event)
            value = app.PermutaASButton.Value;

            if value
                alpha=90;
            else 
                alpha=-90;
            end
            app.Info.data   = imrotate3(app.Info.data,alpha,[0 0 1],'linear','loose','FillValues',0);
            app.Info.rdata = app.Info.data;
            resetSiliderVista(app);
            resetSliderRot(app);
            imrefresca(app);
        end

        % Value changed function: PermutaSCButton
        function PermutaSCButtonValueChanged(app, event)
            value = app.PermutaSCButton.Value;

            if value
                alpha=90;
            else 
                alpha=-90;
            end
            app.Info.data   = imrotate3(app.Info.data,alpha,[0 1 0],'linear','loose','FillValues',0);
            app.Info.rdata = app.Info.data;
            resetSiliderVista(app);
            resetSliderRot(app);
            imrefresca(app);
            
        end

        % Value changed function: PermutaACButton
        function PermutaACButtonValueChanged(app, event)
            value = app.PermutaACButton.Value;

            if value
                alpha=90;
            else 
                alpha=-90;
            end
            app.Info.data   = imrotate3(app.Info.data,alpha,[1 0 0],'linear','loose','FillValues',0);
            app.Info.rdata = app.Info.data;
            resetSiliderVista(app);
            resetSliderRot(app);
            imrefresca(app);
            
        end

        % Value changed function: VerGuiasButton
        function VerGuiasButtonValueChanged(app, event)
            imrefresca(app);
        end

        % Value changed function: VerSegmentacionButton
        function VerSegmentacionButtonValueChanged(app, event)
            imrefresca(app);            
        end

        % Button pushed function: SegmentarCerebroButton
        function SegmentarCerebroButtonPushed(app, event)
            if app.Info.flags.segmentado
                answer = questdlg('¿Esta seguro de que desea borrar la segmentación actual y volver a segmentar el cerebro?', 'Segmentar','Si', 'No','Si');
                if isequal(answer,'Si')
                    net = load('Segnet_3C_200x200_2.mat');
                    app.Info.Vseg = segmentaVTC2(app.Info.rdata,net.net);
                    [~,~,V123]=volumen_elipse_segmentado1(app.Info.Vseg);
                    app.Info.Velipsoide=genera_elipsoide(borde(V123));
                    app.Info.volumen = sum(app.Info.Velipsoide(:))*prod(app.Info.spacings)*1e-3;
                    clear net
                    resetSiliderVista(app);
    
                    %flags
                    app.Info.flags.segmentado=1; 
                    app.Info.flags.rotado=1;
    
                    %apaga botones rotar
                    app.PermutaACButton.Enable = 'off';
                    app.PermutaASButton.Enable = 'off';
                    app.PermutaSCButton.Enable = 'off';
                    app.SliderRotCoronal.Visible = 'off';
                    app.SliderRotAxial.Visible = 'off';
                    app.textSliderRotAxial.Visible = 'off';
                    app.textSliderRotCoronal.Visible = 'off';
                    app.RotacionLabel.Visible = 'off';
                    app.RotacionLabel_2.Visible = 'off';

                    app.VerSegmentacionButton.Value = 1;
    
                    imrefresca(app);    
                end
            else
                answer = questdlg('Asegurese de tener la imagen en la orientación adecuada. ¿Segmentar?', 'Segmentar','Si', 'No','Si');
                if isequal(answer,'Si')
                    net = load('Segnet_3C_200x200_2.mat');
                    app.Info.Vseg = segmentaVTC2(app.Info.rdata,net.net);
                    [~,~,V123]=volumen_elipse_segmentado1(app.Info.Vseg);
                    app.Info.Velipsoide=genera_elipsoide(borde(V123));
                    app.Info.volumen = sum(app.Info.Velipsoide(:))*prod(app.Info.spacings)*1e-3;
                    clear net
                    resetSiliderVista(app);
    
                    %flags
                    app.Info.flags.segmentado=1; 
                    app.Info.flags.rotado=1;
    
                    %apaga botones rotar
                    app.PermutaACButton.Enable = 'off';
                    app.PermutaASButton.Enable = 'off';
                    app.PermutaSCButton.Enable = 'off';
                    app.SliderRotCoronal.Visible = 'off';
                    app.SliderRotAxial.Visible = 'off';
                    app.textSliderRotAxial.Visible = 'off';
                    app.textSliderRotCoronal.Visible = 'off';
                    app.RotacionLabel.Visible = 'off';
                    app.RotacionLabel_2.Visible = 'off';
                    

                    app.VerSegmentacionButton.Value = 1;
    
                    imrefresca(app);
                end
            end
            
        end

        % Button pushed function: ReiniciarSegmentacionButton
        function ReiniciarSegmentacionButtonPushed(app, event)
            %vuelve a cargar el volumen
            answer = questdlg('¿Esta seguro de que desea reiniciar la segmentación?', 'Reiniciar','Si', 'No','Si');
                if isequal(answer,'Si')
                    app.Info = leervolumen([app.pathname app.filename]);
                    if isempty(app.Info)
                      r.Interpreter = 'tex';
                      r.WindowStyle = 'modal';
                      uiwait(msgbox('\fontsize{12}Read error','','error',r));
                      return
                    end
                    app.fichLeido = 1;
                    app.Info.rdata = app.Info.data;
                    app.Info.Vseg = 0*app.Info.data;
                    app.Info.Velipsoide = 0*app.Info.data;
                    app.Info.volumen = 0;
                    app.Info.flags.rotado  = 0;
                    app.Info.flags.volumen = 0;
                    app.Info.flags.segmentado = 0;
                    imrefresca(app);

                    %botones
                    app.PermutaACButton.Enable = 'on';
                    app.PermutaASButton.Enable = 'on';
                    app.PermutaSCButton.Enable = 'on';
                    app.SliderRotCoronal.Visible = 'on';
                    app.SliderRotAxial.Visible = 'on';
                    app.textSliderRotAxial.Visible = 'on';
                    app.textSliderRotCoronal.Visible = 'on';
                    app.RotacionLabel.Visible = 'on';
                    app.RotacionLabel_2.Visible = 'on';
                    app.VerSegmentacionButton.Value = 0;
                end
        end

        % Button pushed function: ModificarSegmentacionButton
        function ModificarSegmentacionButtonPushed(app, event)
            app.ModificarSegmentacionButton.Enable = 'off';
            app.EditSegmentationApp = EditSegmentation(app,app.Info);
        end

        % Button pushed function: GuardarButton
        function GuardarButtonPushed(app, event)
            %guarda 
            f = waitbar(0.30,'Guardando los datos');
            [filepath,name,~] = fileparts(app.Info.name);
            Info= app.Info;
            save([filepath,'/',name,'VC.mat'],'Info');
            close(f)
            r.Interpreter = 'tex';
            r.WindowStyle = 'modal';
            uiwait(msgbox('\fontsize{12}Datos guardados correctamente','Success','help',r));
        end

        % Value changed function: SliderRotAxial
        function SliderRotAxialValueChanged(app, event)
            valueRotAxial = app.SliderRotAxial.Value;
            valueRotCoronal = app.SliderRotCoronal.Value;
            axial_ang =  round(valueRotAxial,1);
            if axial_ang>=0
                axial_ang=fix(axial_ang)+(axial_ang>fix(axial_ang))*0.5;
            else
                 axial_ang=fix(axial_ang)-(axial_ang<fix(axial_ang))*0.5;
            end
            
            rotation_ang = round(valueRotCoronal,1);
            
            if rotation_ang>=0
                rotation_ang=fix(rotation_ang)+(rotation_ang>fix(rotation_ang))*0.5;
            else
                 rotation_ang=fix(rotation_ang)-(rotation_ang<fix(rotation_ang))*0.5;
            end
            
            app.SliderRotAxial.Value = axial_ang;
            app.textSliderRotAxial.Value = axial_ang;
            app.Info.rdata   = imrotate3(app.Info.data,rotation_ang,[0 0 1],'linear','loose','FillValues',0);
            app.Info.rdata   = imrotate3(app.Info.rdata,axial_ang,[0 1 0],'linear','loose','FillValues',0); 
            app.Info.Vseg    = 0*app.Info.rdata;
            imrefresca(app);
        end

        % Value changed function: textSliderRotAxial
        function textSliderRotAxialValueChanged(app, event)
            app.SliderRotAxial.Value = app.textSliderRotAxial.Value;
            app.SliderRotAxialValueChanged()
        end

        % Value changed function: SliderRotCoronal
        function SliderRotCoronalValueChanged(app, event)
            valueRotAxial = app.SliderRotAxial.Value;
            valueRotCoronal = app.SliderRotCoronal.Value;
            axial_ang =  round(valueRotAxial,1);
            if axial_ang>=0
                axial_ang=fix(axial_ang)+(axial_ang>fix(axial_ang))*0.5;
            else
                 axial_ang=fix(axial_ang)-(axial_ang<fix(axial_ang))*0.5;
            end
            
            rotation_ang = round(valueRotCoronal,1);
            
            if rotation_ang>=0
                rotation_ang=fix(rotation_ang)+(rotation_ang>fix(rotation_ang))*0.5;
            else
                 rotation_ang=fix(rotation_ang)-(rotation_ang<fix(rotation_ang))*0.5;
            end
            
            app.SliderRotCoronal.Value = rotation_ang;
            app.textSliderRotCoronal.Value = rotation_ang;
            app.Info.rdata   = imrotate3(app.Info.data,rotation_ang,[0 0 1],'linear','loose','FillValues',0);
            app.Info.rdata   = imrotate3(app.Info.rdata,axial_ang,[0 1 0],'linear','loose','FillValues',0); 
            app.Info.Vseg    = 0*app.Info.rdata;
            imrefresca(app);
            
        end

        % Value changed function: textSliderRotCoronal
        function textSliderRotCoronalValueChanged(app, event)
            app.SliderRotCoronal.Value = app.textSliderRotCoronal.Value;
            app.SliderRotCoronalValueChanged()
            
        end

        % Button pushed function: SalirButton
        function SalirButtonPushed(app, event)
            if app.fichLeido
                answer = questdlg('¿Desea guardar los cambios?', 'Guardar','Si', 'No','Si');
                    if isequal(answer,'Si')
                        app.GuardarButtonPushed()
                    end
            end
            delete(app)
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            app.SalirButtonPushed();
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1184 705];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {30, 100, 55, '1x', '1x', '1x'};
            app.GridLayout.RowHeight = {'1x', 150, 121, 135, 123, '0.5x', 22, 22};
            app.GridLayout.ColumnSpacing = 8.8;
            app.GridLayout.RowSpacing = 9;
            app.GridLayout.Padding = [8.8 9 8.8 9];

            % Create Panel
            app.Panel = uipanel(app.GridLayout);
            app.Panel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Panel.Layout.Row = [1 8];
            app.Panel.Layout.Column = [4 6];

            % Create UIAxesAxial
            app.UIAxesAxial = uiaxes(app.Panel);
            app.UIAxesAxial.XTick = [];
            app.UIAxesAxial.XTickLabel = '';
            app.UIAxesAxial.YTick = [];
            app.UIAxesAxial.Position = [1 249 309 227];

            % Create UIAxesSagital
            app.UIAxesSagital = uiaxes(app.Panel);
            app.UIAxesSagital.XTick = [];
            app.UIAxesSagital.XTickLabel = '';
            app.UIAxesSagital.YTick = [];
            app.UIAxesSagital.Position = [328 238 321 244];

            % Create UIAxesCoronal
            app.UIAxesCoronal = uiaxes(app.Panel);
            app.UIAxesCoronal.XTick = [];
            app.UIAxesCoronal.XTickLabel = '';
            app.UIAxesCoronal.YTick = [];
            app.UIAxesCoronal.Position = [658 238 321 238];

            % Create SliderSagital
            app.SliderSagital = uislider(app.Panel);
            app.SliderSagital.ValueChangedFcn = createCallbackFcn(app, @SliderSagitalValueChanged, true);
            app.SliderSagital.MinorTicks = [];
            app.SliderSagital.Position = [392 197 173 3];

            % Create SliderCoronal
            app.SliderCoronal = uislider(app.Panel);
            app.SliderCoronal.ValueChangedFcn = createCallbackFcn(app, @SliderCoronalValueChanged, true);
            app.SliderCoronal.MinorTicks = [];
            app.SliderCoronal.Position = [724 197 150 3];

            % Create SliderAxial
            app.SliderAxial = uislider(app.Panel);
            app.SliderAxial.ValueChangedFcn = createCallbackFcn(app, @SliderAxialValueChanged, true);
            app.SliderAxial.MinorTicks = [];
            app.SliderAxial.Position = [45 197 150 3];

            % Create SliderRotAxial
            app.SliderRotAxial = uislider(app.Panel);
            app.SliderRotAxial.ValueChangedFcn = createCallbackFcn(app, @SliderRotAxialValueChanged, true);
            app.SliderRotAxial.Position = [45 129 150 3];

            % Create SliderRotCoronal
            app.SliderRotCoronal = uislider(app.Panel);
            app.SliderRotCoronal.ValueChangedFcn = createCallbackFcn(app, @SliderRotCoronalValueChanged, true);
            app.SliderRotCoronal.Position = [728 129 150 3];

            % Create SliceLabel
            app.SliceLabel = uilabel(app.Panel);
            app.SliceLabel.Position = [104 209 31 22];
            app.SliceLabel.Text = 'Slice';

            % Create RotacionLabel
            app.RotacionLabel = uilabel(app.Panel);
            app.RotacionLabel.Position = [93 139 53 22];
            app.RotacionLabel.Text = 'Rotación';

            % Create SliceLabel_2
            app.SliceLabel_2 = uilabel(app.Panel);
            app.SliceLabel_2.Position = [474 209 31 22];
            app.SliceLabel_2.Text = 'Slice';

            % Create SliceLabel_3
            app.SliceLabel_3 = uilabel(app.Panel);
            app.SliceLabel_3.Position = [783 209 31 22];
            app.SliceLabel_3.Text = 'Slice';

            % Create RotacionLabel_2
            app.RotacionLabel_2 = uilabel(app.Panel);
            app.RotacionLabel_2.Position = [772 139 53 22];
            app.RotacionLabel_2.Text = 'Rotacion';

            % Create textSliderAxial
            app.textSliderAxial = uispinner(app.Panel);
            app.textSliderAxial.ValueChangedFcn = createCallbackFcn(app, @textSliderAxialValueChanged, true);
            app.textSliderAxial.Position = [210 179 59 22];

            % Create textSliderSagital
            app.textSliderSagital = uispinner(app.Panel);
            app.textSliderSagital.ValueChangedFcn = createCallbackFcn(app, @textSliderSagitalValueChanged, true);
            app.textSliderSagital.Position = [585 179 59 22];

            % Create textSliderCoronal
            app.textSliderCoronal = uispinner(app.Panel);
            app.textSliderCoronal.ValueChangedFcn = createCallbackFcn(app, @textSliderCoronalValueChanged, true);
            app.textSliderCoronal.Position = [900 179 59 22];

            % Create textSliderRotAxial
            app.textSliderRotAxial = uispinner(app.Panel);
            app.textSliderRotAxial.Step = 0.5;
            app.textSliderRotAxial.ValueChangedFcn = createCallbackFcn(app, @textSliderRotAxialValueChanged, true);
            app.textSliderRotAxial.Position = [210 119 59 22];

            % Create textSliderRotCoronal
            app.textSliderRotCoronal = uispinner(app.Panel);
            app.textSliderRotCoronal.ValueChangedFcn = createCallbackFcn(app, @textSliderRotCoronalValueChanged, true);
            app.textSliderRotCoronal.Position = [900 119 59 22];

            % Create AXIALLabel
            app.AXIALLabel = uilabel(app.Panel);
            app.AXIALLabel.BackgroundColor = [1 0 0];
            app.AXIALLabel.HorizontalAlignment = 'center';
            app.AXIALLabel.FontWeight = 'bold';
            app.AXIALLabel.Position = [62 487 193 22];
            app.AXIALLabel.Text = 'AXIAL';

            % Create SAGITALLabel
            app.SAGITALLabel = uilabel(app.Panel);
            app.SAGITALLabel.BackgroundColor = [0 1 0];
            app.SAGITALLabel.HorizontalAlignment = 'center';
            app.SAGITALLabel.FontWeight = 'bold';
            app.SAGITALLabel.Position = [405 490 181 22];
            app.SAGITALLabel.Text = 'SAGITAL';

            % Create CORONALLabel
            app.CORONALLabel = uilabel(app.Panel);
            app.CORONALLabel.BackgroundColor = [0.0745 0.6235 1];
            app.CORONALLabel.HorizontalAlignment = 'center';
            app.CORONALLabel.FontWeight = 'bold';
            app.CORONALLabel.Position = [728 487 181 22];
            app.CORONALLabel.Text = 'CORONAL';

            % Create CargaEcoPanel
            app.CargaEcoPanel = uipanel(app.GridLayout);
            app.CargaEcoPanel.Title = 'Cargar ecografía';
            app.CargaEcoPanel.Layout.Row = 2;
            app.CargaEcoPanel.Layout.Column = [1 3];

            % Create AbrirButton
            app.AbrirButton = uibutton(app.CargaEcoPanel, 'push');
            app.AbrirButton.ButtonPushedFcn = createCallbackFcn(app, @AbrirButtonPushed, true);
            app.AbrirButton.Position = [51 93 100 22];
            app.AbrirButton.Text = 'Abrir';

            % Create volumeName
            app.volumeName = uieditfield(app.CargaEcoPanel, 'text');
            app.volumeName.Position = [37 55 127 22];

            % Create ReiniciarSegmentacionButton
            app.ReiniciarSegmentacionButton = uibutton(app.CargaEcoPanel, 'push');
            app.ReiniciarSegmentacionButton.ButtonPushedFcn = createCallbackFcn(app, @ReiniciarSegmentacionButtonPushed, true);
            app.ReiniciarSegmentacionButton.BackgroundColor = [0.9804 0.5098 0.5098];
            app.ReiniciarSegmentacionButton.Position = [30 17 141 22];
            app.ReiniciarSegmentacionButton.Text = 'Reiniciar segmentación';

            % Create HerramientasPanel
            app.HerramientasPanel = uipanel(app.GridLayout);
            app.HerramientasPanel.Title = 'Herramientas';
            app.HerramientasPanel.Layout.Row = 5;
            app.HerramientasPanel.Layout.Column = [1 3];

            % Create VerGuiasButton
            app.VerGuiasButton = uibutton(app.HerramientasPanel, 'state');
            app.VerGuiasButton.ValueChangedFcn = createCallbackFcn(app, @VerGuiasButtonValueChanged, true);
            app.VerGuiasButton.Text = 'Ver guías';
            app.VerGuiasButton.Position = [52 70 100 22];

            % Create VerSegmentacionButton
            app.VerSegmentacionButton = uibutton(app.HerramientasPanel, 'state');
            app.VerSegmentacionButton.ValueChangedFcn = createCallbackFcn(app, @VerSegmentacionButtonValueChanged, true);
            app.VerSegmentacionButton.Text = 'Ver segmentación';
            app.VerSegmentacionButton.Position = [46 41 112 22];

            % Create ModificarSegmentacionButton
            app.ModificarSegmentacionButton = uibutton(app.HerramientasPanel, 'push');
            app.ModificarSegmentacionButton.ButtonPushedFcn = createCallbackFcn(app, @ModificarSegmentacionButtonPushed, true);
            app.ModificarSegmentacionButton.Position = [29 10 145 22];
            app.ModificarSegmentacionButton.Text = 'Modificar segmentación';

            % Create VolumenPanel
            app.VolumenPanel = uipanel(app.GridLayout);
            app.VolumenPanel.Title = 'Volumen';
            app.VolumenPanel.Layout.Row = 4;
            app.VolumenPanel.Layout.Column = [1 3];

            % Create VolumenEsLabel
            app.VolumenEsLabel = uilabel(app.VolumenPanel);
            app.VolumenEsLabel.BackgroundColor = [1 1 0];
            app.VolumenEsLabel.HorizontalAlignment = 'right';
            app.VolumenEsLabel.Position = [20 43 109 22];
            app.VolumenEsLabel.Text = 'Volumen Estimado ';

            % Create SegmentarCerebroButton
            app.SegmentarCerebroButton = uibutton(app.VolumenPanel, 'push');
            app.SegmentarCerebroButton.ButtonPushedFcn = createCallbackFcn(app, @SegmentarCerebroButtonPushed, true);
            app.SegmentarCerebroButton.Position = [41 80 121 22];
            app.SegmentarCerebroButton.Text = 'Segmentar Cerebro';

            % Create textVolumenEstimado
            app.textVolumenEstimado = uieditfield(app.VolumenPanel, 'text');
            app.textVolumenEstimado.BackgroundColor = [1 1 0];
            app.textVolumenEstimado.Position = [140 43 60 22];

            % Create VolumenEsLabel_2
            app.VolumenEsLabel_2 = uilabel(app.VolumenPanel);
            app.VolumenEsLabel_2.BackgroundColor = [1 0.302 0.302];
            app.VolumenEsLabel_2.HorizontalAlignment = 'right';
            app.VolumenEsLabel_2.Position = [2 10 127 22];
            app.VolumenEsLabel_2.Text = 'Volumen Segmentado ';

            % Create textVolumenSegmentado
            app.textVolumenSegmentado = uieditfield(app.VolumenPanel, 'text');
            app.textVolumenSegmentado.BackgroundColor = [1 0.302 0.302];
            app.textVolumenSegmentado.Position = [140 10 60 22];

            % Create SalirButton
            app.SalirButton = uibutton(app.GridLayout, 'push');
            app.SalirButton.ButtonPushedFcn = createCallbackFcn(app, @SalirButtonPushed, true);
            app.SalirButton.BackgroundColor = [0.9882 0.4275 0.4275];
            app.SalirButton.Layout.Row = 8;
            app.SalirButton.Layout.Column = 2;
            app.SalirButton.Text = 'Salir';

            % Create GuardarButton
            app.GuardarButton = uibutton(app.GridLayout, 'push');
            app.GuardarButton.ButtonPushedFcn = createCallbackFcn(app, @GuardarButtonPushed, true);
            app.GuardarButton.BackgroundColor = [0.4902 0.8706 0.2157];
            app.GuardarButton.Layout.Row = 7;
            app.GuardarButton.Layout.Column = 2;
            app.GuardarButton.Text = 'Guardar';

            % Create CambiarorientacinPanel
            app.CambiarorientacinPanel = uipanel(app.GridLayout);
            app.CambiarorientacinPanel.Title = 'Cambiar orientación';
            app.CambiarorientacinPanel.Layout.Row = 3;
            app.CambiarorientacinPanel.Layout.Column = [1 3];

            % Create PermutaASButton
            app.PermutaASButton = uibutton(app.CambiarorientacinPanel, 'state');
            app.PermutaASButton.ValueChangedFcn = createCallbackFcn(app, @PermutaASButtonValueChanged, true);
            app.PermutaASButton.Text = 'Permuta A-S';
            app.PermutaASButton.Position = [51 71 100 22];

            % Create PermutaSCButton
            app.PermutaSCButton = uibutton(app.CambiarorientacinPanel, 'state');
            app.PermutaSCButton.ValueChangedFcn = createCallbackFcn(app, @PermutaSCButtonValueChanged, true);
            app.PermutaSCButton.Text = 'Permuta S-C';
            app.PermutaSCButton.Position = [51 39 100 22];

            % Create PermutaACButton
            app.PermutaACButton = uibutton(app.CambiarorientacinPanel, 'state');
            app.PermutaACButton.ValueChangedFcn = createCallbackFcn(app, @PermutaACButtonValueChanged, true);
            app.PermutaACButton.Text = 'Permuta A-C';
            app.PermutaACButton.Position = [51 8 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SegmentaVCT_exported

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
            delete(app.UIFigure)
        end
    end
end