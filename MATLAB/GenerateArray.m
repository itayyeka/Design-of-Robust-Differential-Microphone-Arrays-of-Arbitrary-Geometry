function [XVec,YVec,RVec,PhVec,DistancesMat] = GenerateArray(CfgSet)
% Confining the array to a square that its diagonal line is smaller than
% half-wavelength around the source (0,0) point.
StandAloneFlg=0;
Downsize=0.3;
if true
    if strcmpi(CfgSet.ShapeCfg,'Linear')
        %% Linear    
        Diff=2/CfgSet.ElementsNum;
        XVec=(-1+Diff/2):Diff:1;
        YVec=zeros(size(XVec));
    elseif strcmpi(CfgSet.ShapeCfg,'Circle')
        %% Circle      
        PhDiff=2*pi/CfgSet.ElementsNum;
        PhVec=(-pi+PhDiff/2):PhDiff:pi;
        Complex=exp(1i*PhVec);
        XVec=real(Complex);
        YVec=imag(Complex);
    elseif strcmpi(CfgSet.ShapeCfg,'HalfCircle')
        %% HalfCircle        
        PhDiff=pi/CfgSet.ElementsNum;
        PhVec=(-pi+PhDiff/2):PhDiff:0;
        Complex=exp(1i*PhVec);
        YVec=real(Complex);
        XVec=imag(Complex);
    elseif strcmpi(CfgSet.ShapeCfg,'Parabola')
        %% Parabula   
        Diff=2/CfgSet.ElementsNum;
        XVec=(-1+Diff/2):Diff:1;
        YVec=XVec.^2;
    end
end
%% Resize array
if true
    %% Center
    YVec=YVec-mean(YVec);
    XVec=XVec-mean(XVec);
    %% Radial units
    Complex=XVec+1i*YVec;
    RVec=abs(Complex);
    PhVec=angle(Complex);%-pi/2;
    %% Fit to circle
    MaxDistance=CfgSet.Lambda/2;
    RVec=Downsize*(MaxDistance/2)*RVec/max(RVec);
    %% Calculate XY
    Complex=RVec.*exp(1i*PhVec);
    XVec=real(Complex);
    YVec=imag(Complex);
end
%%
if StandAloneFlg || true
    PlotR=Downsize*(MaxDistance/2);
    PlotMaxXY=1.05*sqrt(2)*PlotR;
    figure;plot(XVec,YVec,'o','MarkerFaceColor','b');
    xlim([-PlotMaxXY PlotMaxXY]);
    ylim([-PlotMaxXY PlotMaxXY]);
end
%% Distances matrix
OrigXMat=repmat(transpose(XVec(:)),CfgSet.ElementsNum,1);
OrigYMat=repmat(transpose(YVec(:)),CfgSet.ElementsNum,1);
DestXVecIndMat=repmat(transpose(1:CfgSet.ElementsNum),1,CfgSet.ElementsNum);
DestXMat=XVec(DestXVecIndMat);
DestYMat=YVec(DestXVecIndMat);
DistancesMat=sqrt(abs(OrigXMat-DestXMat).^2 + abs(OrigYMat-DestYMat).^2);
end

