function [Filters] =  ...
    CalculateRobustFilters(Order,ElementNum,SoundSpeed,CoefVal,PhiValVec,RValVec)
if ~exist('CoefVal','var')
    AngWidth=pi/4;
    Order=2;
    ElementNum=Order+1;
    PhiValVec=zeros(1,ElementNum);
    RValVec=ones(1,ElementNum);
    SoundSpeed=340;
    ThetaS=0.5;
    D=0;
    CoefVec=[];
    ComponentsVec=[];
    syms theta;
    assume(theta,'real');
    for n=0:Order
        for k=n %0:n
            CoefNameStr=['a' ...
                dec2base(n,10,ceil(log10(Order))) ...
                dec2base(k,10,max(1,ceil(log10(n)))) ...
                ];
            MATRowSumAbsVal=[];
            for m=1:ElementNum
                MATRowSumAbsVal=MATRowSumAbsVal+...
                    abs( ...
                    (RValVec(m)^n) ...
                    *(cos(PhiValVec(m))^k) ...
                    *(sin(PhiValVec(m)^(n-k))) ...
                    );
            end
            if MATRowSumAbsVal
                D=D+1;
                eval([CoefNameStr '=sym(''' CoefNameStr ''');']);
                eval(['CoefVec=[CoefVec ' CoefNameStr '];']);
                ComponentsVec=[ComponentsVec (cos(theta)^k)*(sin(theta)^(n-k))];
            end
        end
    end
    CoefVal=ones(1,D);
else
    CoefVec=[];
    D=0;
    for n=0:Order
        for k=n %0:n
            CoefNameStr=['a' ...
                dec2base(n,10,ceil(log10(Order))) ...
                dec2base(k,10,max(1,ceil(log10(n)))) ...
                ];
            D=D+1;
            eval([CoefNameStr '=sym(''' CoefNameStr ''');']);
            eval(['CoefVec=[CoefVec ' CoefNameStr '];']);
        end
    end
end
%% Syms
syms w;
assume(w,'real');
syms Theta;
assume(Theta,'real');
syms PhiVec;
syms RVec;
for ElId=1:ElementNum
    PhName=['Phi',num2str(ElId)];
    eval(['syms ' PhName ';']);
    assume(eval(PhName),'real');
    eval(['PhiVec(ElId)=' PhName ';']);
    RName=['r',num2str(ElId)];
    eval(['syms ' RName ';']);
    assume(eval(RName),'real');
    eval(['RVec(ElId)=' RName ';']);
end
syms c;
assume(c,'real');
%% Calculte auxiliaries
% [MAT] * [Hvec] = [Vec]
if true
    d=0;
    for n=0:Order
        for k=0:n
            d=d+1;            
            if n==k
                FullCoefVec(d)=...
                    CoefVal(n+1) ...
                    *factorial(n) ...
                    *(c/(1i*w))^n ...
                    /nchoosek(n,k);
            else
                %FullCoefVec(d)=0;
            end
            for m=1:ElementNum
                %% Calculate MAT
                BetaMat(d,m)=...
                    RVec(m)^n ...
                    *cos(PhiValVec(m))^k ...
                    *sin(PhiValVec(m))^(n-k) ...
                    ;
                A=1;
            end
        end
    end
end
%% Calculate Filters
disp(['Evaluating BMat']);
tic
PrmBetaMat=BetaMat;
BetaMat=...
    subs( ...
    PrmBetaMat, ...
    [c          ;   CoefVec(:) ; PhiVec(:)      ; RVec(:)   ], ...
    [SoundSpeed ;   CoefVal(:) ; PhiValVec(:)   ; RValVec(:)] ...
    );
PowerTh=-100;
BetaMatVal=eval(BetaMat);
PowerMat=log2(abs(BetaMatVal));
%BetaMat(PowerMat<PowerTh)=0;
RelevantRows=1:size(BetaMat,1);%find(PowerVec>PowerTh);
disp(['Evaluating Filters']);
tic
RelevantBetaMat=BetaMat(RelevantRows,:);
RelevantCoefVal=FullCoefVec(RelevantRows);
RelevantCoefVal=...
    eval(subs( ...
    RelevantCoefVal, ...
    [c          ;   CoefVec(:) ; PhiVec(:)      ; RVec(:)   ], ...
    [SoundSpeed ;   CoefVal(:) ; PhiValVec(:)   ; RValVec(:)] ...
    ));
pInvMat=pinv(eval(RelevantBetaMat));
PrmFilters=...
    pInvMat*RelevantCoefVal(:);
Filters=eval(PrmFilters);
disp(['Evaluated Filters in ' num2str(toc) ' sec']);
end