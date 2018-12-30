%% Define scenarios
clc;
clearvars;
close all;
%digits(2);
[CurDir,~,~]=fileparts(mfilename('fullpath'));
FiguresPath=fullfile(CurDir,'Figures');
Orders={1 2 3 4};
Orders={2};
ElemnetOrderDiffs={1 3 5};
%ElemnetOrderDiffs={2};
%ElemnetOrderDiffs={3};
%ElemnetOrderDiffs={4};
Shapes={'Linear','Circle','HalfCircle','Parabola'};
%Shapes={'Linear'};
% Shapes={'Circle'};
%Shapes={'HalfCircle'};
%Shapes={'Parabola'};
for OrderId=1:numel(Orders)
    for ShapeId=1:numel(Shapes)
        for ElOrDiffId=1:numel(ElemnetOrderDiffs)
            %% Fetch Cfg
            CurOrder=Orders{OrderId};
            CurElOrDiff=ElemnetOrderDiffs{ElOrDiffId};
            CurShape=Shapes{ShapeId};
            tic;
            disp(['Started synthesizing Shape:"' ...
                num2str(CurShape) '" Order:' ...
                num2str(CurOrder) ' and nElements:' ...
                num2str(CurOrder+CurElOrDiff)]);
            %% Create CfgSet
            if true
                %% Physical
                CfgSet.MaxFreq=1e3;%Hz
                CfgSet.MaxPlotFreq=4e3;%Hz
                CfgSet.c=340;%m/s
                %% Order
                CfgSet.Order=CurOrder;
                %% ElementsNum
                CfgSet.ElementsNum=CurOrder+CurElOrDiff;
                %% ThetaS
                CfgSet.ThetaS=0;
                %% PlotLength
                CfgSet.PlotLength=1000;
                %% dervied
                CfgSet.Lambda=CfgSet.c/CfgSet.MaxFreq;%m
                CfgSet.MaxDistance=0.5*1e-2;%Lambda/2;%m
                %% DetrmineShape
                CfgSet.ShapeCfg=CurShape;
                CfgSet.AngularWidth=pi/2;%pi/2;
            end
            %% Simulate
            [PlotData] = MyArticleMain(CfgSet);
            disp(['Finished synthesizing Shape:"' ...
                num2str(CurShape) '" Order:' ...
                num2str(CurOrder) ' and nElements:' ...
                num2str(CurOrder+CurElOrDiff)]);
            toc;
            PlotData.CfgSet=CfgSet;
            PlotDataSet{OrderId,ElOrDiffId,ShapeId}=PlotData;
        end
    end
end
SimName=[...
    'PlotData_' ...
    'Orders_' sprintf('%d_',cell2mat(Orders)) ...
    'ElementOrderDiffs_' sprintf('%d_',cell2mat(ElemnetOrderDiffs)) ...
    'Shapes_' sprintf('%s_',cell2mat(Shapes)) ...
    'Results'];
FilePath=fullfile(FiguresPath,[SimName '.mat']);
save(FilePath,'PlotDataSet');
%% Run simulations