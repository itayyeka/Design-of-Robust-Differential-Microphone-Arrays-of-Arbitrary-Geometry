function [WhiteNoiseGain,DiffuseNoiseGain] = CalculateGain(hVec,TimeDiffMat,FinalBp)
%% StandAlne
syms w;
assume(w,'real');
syms Theta;
assume(Theta,'real');
%FinalBp=eval(simplify(FinalBp));
%hVec=eval(simplify(hVec));
hVec=hVec(:);
hVec_h=hVec';
M=numel(hVec);
%% Calculate WNG
NoiseAutoCorrMat=diag(ones(1,M));
NG_Num=FinalBp*conj(FinalBp);
NG_Den=hVec_h*NoiseAutoCorrMat*hVec;
WhiteNoiseGain=NG_Num/NG_Den;
%% Calculate DNG
NoiseAutoCorrMat=sin(w*TimeDiffMat)./(w*TimeDiffMat);
NoiseAutoCorrMat(1:(M+1):end)=1;
NG_Num=NG_Num;
NG_Den=hVec_h*NoiseAutoCorrMat*hVec;
DiffuseNoiseGain=NG_Num/NG_Den;
end

