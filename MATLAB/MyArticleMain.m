function [PlotData] = MyArticleMain(CfgSet)
%close all;
%clc;
PlotGainsEn=1;
StandAloneFlg=0;
%% Configuratin
if ~exist('CfgSet','var')
    StandAloneFlg=1;
    %% Physical
    CfgSet.MaxFreq=1e3;%Hz
    CfgSet.MaxPlotFreq=4e3;%Hz
    CfgSet.c=340;%m/s
    %% Order
    CfgSet.Order=1;
    %% ElementsNum
    CfgSet.ElementsNum=CfgSet.Order+3;
    %% ThetaS
    CfgSet.ThetaS=0;
    %% PlotLength
    CfgSet.PlotLength=1000;
    %% dervied
    CfgSet.Lambda=CfgSet.c/CfgSet.MaxFreq;%m
    CfgSet.MaxDistance=0.5*1e-2;%Lambda/2;%m
    %% DetrmineShape
    CfgSet.ShapeCfg='Circle';
    %CfgSet.ShapeCfg='Parabola';
    %CfgSet.ShapeCfg='Linear';
    CfgSet.AngularWidth=pi/2;%pi/2;
end
%% Rename parameters
if true
    %% Physical
    MaxFreq=CfgSet.MaxFreq;%Hz
    MaxPlotFreq=CfgSet.MaxPlotFreq;%Hz
    c=CfgSet.c;%m/s
    %% Order
    Order=CfgSet.Order;
    %% ElementsNum
    ElementsNum=CfgSet.ElementsNum;
    %% ThetaS
    ThetaS=CfgSet.ThetaS;
    %% PlotLength
    PlotLength=CfgSet.PlotLength;
    %% dervied
    Lambda=CfgSet.Lambda;%m
    MaxDistance=CfgSet.MaxDistance;%Lambda/2;%m
    %% DetrmineShape
    ShapeCfg=CfgSet.ShapeCfg;
    AngularWidth=CfgSet.AngularWidth;%pi/2;
end
%% Body
tic;
[XVec,YVec,RValVec,PhiValVec,DistancesMat]=GenerateArray(CfgSet);
disp(['Generated array in ' num2str(toc) ' sec']);
%% Beamformer coefficients
tic;
% [OptimalCoefVec]=CalculateBfCoeffs(AngularWidth,Order,RValVec,PhiValVec,ThetaS,StandAloneFlg); % Super-Cardroid
if Order==1
    OptimalCoefVec=[0.414,0.586];
elseif Order==2
    OptimalCoefVec=[0.103,0.484,0.413];
elseif Order==3
    OptimalCoefVec=[0.022,0.217,0.475,0.286];
end
disp(['Calculated BF mathematical coefs in ' num2str(toc) ' sec']);
OptimalCoefVec
%% Calculate Filters
SoundSpeed=340;
Filters=CalculateRobustFilters(Order,ElementsNum,SoundSpeed,OptimalCoefVec,PhiValVec,RValVec);
%% Plot
PlotCfg.PlotGainsEn=PlotGainsEn;
PlotCfg.PlotLength=PlotLength;
PlotCfg.MaxPlotFreq=MaxPlotFreq;%Hz
PlotCfg.PlotEn=1;
PlotCfg.CfgSet=CfgSet;
PlotData=PlotFinalBp(Filters,PhiValVec,RValVec,ThetaS,DistancesMat,SoundSpeed,PlotCfg);
PlotData.XVec=XVec;
PlotData.YVec=YVec;
end

