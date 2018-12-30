function [PlotData] =  ...
    PlotFinalBpOLD(Filters,PhiValVec,RValVec,ThetaS,DistancesMat,SoundSpeed,PlotCfg)
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
    TauVec(m)=RValVec(m)*cos(theta-PhiValVec(m))/c;
    InputComponentVec(m)=exp(-1i*w*TauVec(m));
end
%FinalBp=sum(conj(Filters(:)).*InputComponentVec(:));
FinalBp=sum(Filters(:).*InputComponentVec(:));
%% Calculate NoiseGains
[WhiteNoiseGain,DiffuseNoiseGain] = CalculateGain(Filters,fliplr(InputComponentVec),DistancesMat/c);
%% Plotting
VarList={w, theta};
ThetaValues=linspace(-pi,pi,PlotLength);
ThetaValues=linspace(0,2*pi,PlotLength);
FreqValues=linspace(0.001,MaxPlotFreq,PlotLength);
PlotData.ThetaValues=ThetaValues;
PlotData.FreqValues=FreqValues;
VarValues={2*pi*MaxPlotFreq/4,ThetaValues};
if PlotEn
    FigHndl=figure;
    PlotData.FigHndl=FigHndl;
    if PlotGainsEn
        subplot(2,3,[2 3 5 6]);
    end
end
BpValues=eval( ...
    subs(FinalBp, ...
    VarList, ...
    VarValues ...
    ));
PlotData.BpValues=BpValues;
if PlotEn
    polardb(ThetaValues(2:end),abs(BpValues(2:end)));
end
if PlotGainsEn
    if PlotEn
        subplot(2,3,4);
    end
    VarList={w, theta};
    VarValues={2*pi*FreqValues,ThetaS};
    WngVal=eval( ...
        subs(WhiteNoiseGain, ...
        VarList, ...
        VarValues ...
        ));
    PlotData.WngVal=WngVal;
    if PlotEn
        plot(FreqValues,pow2db(abs(WngVal)));
        title('White noise gain');
        ylim([-80 10]);
        xlabel('Frequency [Hz]');
        ylabel('Value[dB]');
        subplot(2,3,1);
    end
    DngVal=eval( ...
        subs(DiffuseNoiseGain, ...
        VarList, ...
        VarValues ...
        ));
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