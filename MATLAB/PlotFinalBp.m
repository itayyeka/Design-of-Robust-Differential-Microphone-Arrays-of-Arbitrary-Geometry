function [PlotData] =  ...
    PlotFinalBp(Filters,PhiValVec,RValVec,ThetaS,DistancesMat,SoundSpeed,PlotCfg)
%% Symbolic
close all;
syms w;
assume(w,'real');
syms theta;
assume(theta,'real');
PlotData=[];
%% StandAlone
if ~exist('Filters','var')
    Order=2;
    ElementsNum=Order+1;
    PhiValVec=zeros(1,ElementsNum);
    RValVec=ones(1,ElementsNum);
    Filters=ones(1,ElementsNum);
    DistancesMat=ones(ElementsNum);
    PlotCfg.PlotGainsEn=0;
    PlotCfg.PlotLength=1000;
    PlotCfg.MaxPlotFreq=4e3;%Hz
    SoundSpeed=340;
    ThetaS=0;
end
%% FetchCfg
PlotEn=PlotCfg.PlotEn;
PlotGainsEn=PlotCfg.PlotGainsEn;
PlotLength=PlotCfg.PlotLength;
MaxPlotFreq=PlotCfg.MaxPlotFreq;
ElementsNum=length(PhiValVec);
c=SoundSpeed;
%% Create the input vec
for m=1:ElementsNum
    TauVec(m)=RValVec(m)*cos(theta-ThetaS-PhiValVec(m))/c;
    ExpArg(m)=1i*w*(TauVec(m));
    InputComponentVec(m)=exp(ExpArg(m));
end
%FinalBp=sum(conj(Filters(:)).*InputComponentVec(:));
FinalBp=...
    sum(Filters(:).*InputComponentVec(:));
%% End-fire amplitude correction
ZeroThetaFinalBp=subs(FinalBp,theta,0);
PlotFreq=2*pi*MaxPlotFreq/4;
EndFireGain=real(eval(subs(ZeroThetaFinalBp,w,PlotFreq)));
Filters=Filters/EndFireGain;
FinalBp=...
    sum(Filters(:).*InputComponentVec(:));
ZeroThetaFinalBp=subs(FinalBp,theta,0);
%EndFireGain=real(eval(subs(ZeroThetaFinalBp,w,PlotFreq)));
%% Calculate NoiseGains
tic
[WhiteNoiseGain,DiffuseNoiseGain] = CalculateGain(Filters,DistancesMat/c,ZeroThetaFinalBp);
disp(['Calculated WNG,DNG in ' num2str(toc) ' sec']);
%% Plotting
ThetaValues=linspace(-pi,pi,PlotLength);
FreqValues=linspace(0.001,MaxPlotFreq,PlotLength);
PlotData.ThetaValues=ThetaValues;
PlotData.FreqValues=FreqValues;
ShapeStr=PlotCfg.CfgSet.ShapeCfg;
Order=PlotCfg.CfgSet.Order;
nEl=length(Filters);
TitleStr=['Shape:"' ShapeStr ...
    '", Order:' num2str(Order) ...
    ', nElements:' num2str(nEl)];
if PlotEn
    FigHndl=figure;
    PlotData.FigHndl=FigHndl;
    if PlotGainsEn
        subplot(2,3,[2 3 5 6]);
        suptitle(TitleStr);
    else
        title(TitleStr);
    end
end
tic;
disp('Calculating BP');
fBP=matlabFunction(simplify(FinalBp));
BpValues=fBP(ThetaValues,PlotFreq);
disp(['Calculated BP in ' num2str(toc) ' sec']);
PlotData.BpValues=BpValues;
if PlotEn
    polardb(ThetaValues,abs(BpValues));
end
if PlotGainsEn
    if PlotEn
        subplot(2,3,4);
    end    
    tic;
    disp('Calculating WNG');
    fWNG=matlabFunction(WhiteNoiseGain);
    WngVal=fWNG(2*pi*FreqValues);
    WngVal(isnan(WngVal))=0;
    disp(['Calculated WNG in ' num2str(toc) ' sec']);    
    PlotData.WngVal=WngVal;
    if PlotEn
        plot(FreqValues,pow2db(abs(WngVal)));
        title('White noise gain');
        ylim([-120 10]);
        xlabel('Frequency [Hz]');
        ylabel('Value[dB]');
        subplot(2,3,1);
    end
    tic;    
    disp('Calculating DNG');
    fDNG=matlabFunction(DiffuseNoiseGain);
    DngVal=fDNG(2*pi*FreqValues);
    DngVal(isnan(DngVal))=0;
    disp(['Calculated DNG in ' num2str(toc) ' sec']);    
    PlotData.DngVal=DngVal;
    if PlotEn
        plot(FreqValues,pow2db(abs(DngVal)));
        title('Directivity factor');
        ylim([0,10]);
        xlabel('Frequency [Hz]');
        ylabel('Value[dB]');
        set (FigHndl, 'Units', 'normalized', 'Position', [0,0,0.75,0.75]);
        fixfig(FigHndl,0);
        set(findall(FigHndl,'-property','Fontname'),'Fontname','Timesnewroman')
    end
end
end