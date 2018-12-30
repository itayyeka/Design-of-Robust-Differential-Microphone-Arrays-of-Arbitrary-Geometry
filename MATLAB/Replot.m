close all;clc;clear;
load([fullfile(...
    pwd, 'Figures', ...
    ['PlotData_Orders_2_ElementOrderDiffs' ...
    '_1_3_5_Shapes_LinearCircleHalfCircleParabola_Results'])]);
ScriptCfg.En.SecondOrderArbitraryGeometry=0;
ScriptCfg.En.SecondOrderRobustArbitraryGeometry=1;
ScriptCfg.En.CheeckRobust=0;
FontSize=24;
BpFontSize=18;
CfgSet=PlotDataSet{1,1,1}.CfgSet;
MaxDistance=CfgSet.Lambda/2;
PlotR=0.3*(MaxDistance/2);
PlotMaxXY=1.05*sqrt(2)*PlotR;
if true
    %% CheeckRobust
    if ScriptCfg.En.CheeckRobust
        TmpSizeVec=size(PlotDataSet);
        WngValues=[];
        for ElDiffId=1:TmpSizeVec(2)
            PlotData=PlotDataSet{1,ElDiffId,1};
            FreqValues=PlotData.FreqValues(:);
            WngValues=[WngValues pow2db(PlotData.WngVal(:))];
        end
        plot(FreqValues,WngValues);
    end
    %% FirstOrderArbitraryGeometry
    if ScriptCfg.En.SecondOrderArbitraryGeometry
        Shapes={'Linear','Circle','HalfCircle','Parabola'};
        for ShapeId=1:4
            FigHndl=figure;
            PlotData=PlotDataSet{1,1,ShapeId};
            ThetaValues=PlotData.ThetaValues;
            FreqValues=PlotData.FreqValues;
            polardb(ThetaValues,abs(PlotData.BpValues(:)),1);            
            set(findall(FigHndl,'-property','Fontname'),'Fontname','Timesnewroman');
            set(findall(FigHndl,'-property','FontSize'),'FontSize',BpFontSize);
            %fixfig(FigHndl,0);
            tightfig(FigHndl);
            saveas(FigHndl,...
                ['SecondOrderArbGeo_' Shapes{ShapeId} '_BP.png']);            
            FigHndl=figure;
            plot(PlotData.XVec,PlotData.YVec,'o','MarkerFaceColor','b');           
            xlabel('[m]');
            ylabel('[m]');
            xlim([-PlotMaxXY PlotMaxXY]);
            ylim([-PlotMaxXY PlotMaxXY]);
            %fixfig(FigHndl,0);
            tightfig(FigHndl);
            saveas(FigHndl,...
                ['SecondOrderArbGeo_' Shapes{ShapeId} '.png']);
        end   
        FigHndl=figure;
        LineStyles={...
            '-' ...
            '--' ...
            ':' ...
            '-.' ...
            };
        Legend={};
        for ShapeId=1:4
            PlotData=PlotDataSet{1,1,ShapeId};
            ThetaValues=PlotData.ThetaValues;
            FreqValues=PlotData.FreqValues;
            plot(FreqValues(2:end),pow2db(PlotData.WngVal(2:end)),LineStyles{ShapeId});    
            hold on;
            Legend{end+1}=Shapes{ShapeId};
        end
        ylabel('WNG[dB]');
        xlabel('[Hz]');
        legend(Legend,'Location','best');
        %fixfig(FigHndl,0);
        set (FigHndl, 'Units', 'normalized', 'Position', [0,0,0.75,0.75]);        
        set(findall(FigHndl,'-property','Fontname'),'Fontname','Timesnewroman')
        set(findall(FigHndl,'-property','FontSize'),'FontSize',FontSize)
        tightfig(FigHndl);
        saveas(FigHndl,'SecondOrderArbGeo_WNG.png');
        FigHndl=figure;
        Legend={};
        for ShapeId=1:4
            PlotData=PlotDataSet{1,1,ShapeId};
            ThetaValues=PlotData.ThetaValues;
            FreqValues=PlotData.FreqValues;
            plot(FreqValues(2:end),pow2db(PlotData.DngVal(2:end)),LineStyles{ShapeId});    
            hold on;
            Legend{end+1}=Shapes{ShapeId};
        end
        ylabel('DNG[dB]');
        xlabel('[Hz]');
        legend(Legend,'Location','best');
        %fixfig(FigHndl,0);
        set (FigHndl, 'Units', 'normalized', 'Position', [0,0,0.75,0.75]);        
        set(findall(FigHndl,'-property','Fontname'),'Fontname','Timesnewroman')
        set(findall(FigHndl,'-property','FontSize'),'FontSize',FontSize)
        tightfig(FigHndl);
        saveas(FigHndl,'SecondOrderArbGeo_DNG.png');
    end
    %% SecondOrderRobustArbitraryGeometry
    if ScriptCfg.En.SecondOrderArbitraryGeometry
        Shapes={'Linear','Circle','HalfCircle','Parabola'};
        for ShapeId=1:4
            FigHndl=figure;
            PlotData=PlotDataSet{1,3,ShapeId};
            ThetaValues=PlotData.ThetaValues;
            FreqValues=PlotData.FreqValues;
            polardb(ThetaValues,abs(PlotData.BpValues(:)),1);            
            set(findall(FigHndl,'-property','Fontname'),'Fontname','Timesnewroman');
            set(findall(FigHndl,'-property','FontSize'),'FontSize',BpFontSize);
%             fixfig(FigHndl,0);
            tightfig(FigHndl);
            saveas(FigHndl,...
                ['SecondOrderRobustArbGeo_' Shapes{ShapeId} '_BP.png']);
            XMax=max(PlotData.XVec);
            XMin=min(PlotData.XVec);
            XDiff=max(0.0001,XMax-XMin);
            XMinMax=[XMin-0.1*XDiff , XMax+0.1*XDiff];
            YMax=max(PlotData.YVec);
            YMin=min(PlotData.YVec);
            YDiff=max(0.0001,YMax-YMin);
            YMinMax=[YMin-0.1*YDiff , YMax+0.1*YDiff];
            FigHndl=figure;
            plot(PlotData.XVec,PlotData.YVec,'o','MarkerFaceColor','b');
            xlim(XMinMax);
            ylim(YMinMax);
            xlabel('[m]');
            ylabel('[m]');
%             fixfig(FigHndl,0);
            tightfig(FigHndl);
            saveas(FigHndl,...
                ['SecondOrderRobustArbGeo_' Shapes{ShapeId} '.png']);
        end   
        FigHndl=figure;
        LineStyles={...
            '-' ...
            '--' ...
            ':' ...
            '-.' ...
            };
        Legend={};
        for ShapeId=1:4
            PlotData=PlotDataSet{1,3,ShapeId};
            ThetaValues=PlotData.ThetaValues;
            FreqValues=PlotData.FreqValues;
            plot(FreqValues,pow2db(PlotData.WngVal(:)),LineStyles{ShapeId});    
            hold on;
            Legend{end+1}=Shapes{ShapeId};
        end
        ylabel('WNG[dB]');
        xlabel('[Hz]');
        legend(Legend,'Location','best');
%         fixfig(FigHndl,0);
        set (FigHndl, 'Units', 'normalized', 'Position', [0,0,0.75,0.75]);        
        set(findall(FigHndl,'-property','Fontname'),'Fontname','Timesnewroman')
        set(findall(FigHndl,'-property','FontSize'),'FontSize',FontSize)
        tightfig(FigHndl);
        saveas(FigHndl,'SecondOrderRobustArbGeo_WNG.png');
        FigHndl=figure;
        Legend={};
        for ShapeId=1:4
            PlotData=PlotDataSet{1,3,ShapeId};
            ThetaValues=PlotData.ThetaValues;
            FreqValues=PlotData.FreqValues;
            PlotData.DngVal(PlotData.DngVal<=0)=eps;
            plot(FreqValues,pow2db(real(PlotData.DngVal)),LineStyles{ShapeId});    
            hold on;
            Legend{end+1}=Shapes{ShapeId};
        end
        ylabel('DNG[dB]');
        xlabel('[Hz]');
        legend(Legend,'Location','best');
%         fixfig(FigHndl,0);
        set (FigHndl, 'Units', 'normalized', 'Position', [0,0,0.75,0.75]);        
        set(findall(FigHndl,'-property','Fontname'),'Fontname','Timesnewroman')
        set(findall(FigHndl,'-property','FontSize'),'FontSize',FontSize)
        tightfig(FigHndl);
        saveas(FigHndl,'SecondOrderRobustArbGeo_DNG.png');
    end    
end
%close all;