function [OptimalCoef] = CalculateBfCoeffs(AngWidth,Order,RValVec,PhiValVec,ThetaS,StandAloneFlg)
%% Description
%% StandAlone
if ~exist('AngWidth','var')
    AngWidth=pi/4;
    Order=2;
    ThetaS=0.5;
    RValVec=linspace(0,1e-3,Order+1);
    PhiValVec=zeros(1,Order+1);
end
%% FunctionBody
if true
    %% Calculate D and create symbolic variables
    D=0;
    CoefVec=[];
    ComponentsVec=[];
    syms theta;
    assume(theta,'real');
    ElementNum=length(RValVec);
    for n=0:Order
        for k=n %0:n            
            CoefNameStr=['a' ...
                dec2base(n,10,ceil(log10(Order))) ...
                dec2base(k,10,max(1,ceil(log10(n)))) ...
                ];
            MATRowSumAbsVal=0;
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
                eval(['assume(' CoefNameStr ',''real'');']);
                eval(['CoefVec=[CoefVec ' CoefNameStr '];']);
                ComponentsVec=[ComponentsVec (cos(theta)^k)*(sin(theta)^(n-k))];
            end
        end
    end
    %% CostFunc
    BeamPatternElements=CoefVec.*ComponentsVec;
    BeamPattern=sum(BeamPatternElements);
    BpAbs2=BeamPattern*conj(BeamPattern);
    BpAbs2_Int=int(BpAbs2,theta);
    BpAbs2_Int_Total=int(BpAbs2,theta,-pi,pi);
    InitAngle=max(-pi,ThetaS-AngWidth);
    MaxAngle=min(pi,InitAngle+2*AngWidth);
    BpAbs2_Int_Interst=int(BpAbs2,theta,InitAngle,MaxAngle);
    CostFunc=BpAbs2_Int_Total/BpAbs2_Int_Interst;
    %% OptimalCoef
    MFunc = matlabFunction(CostFunc,'vars',{transpose(CoefVec(:))});
    StartPoint=ones(1,D)/D;
    A=eval( ...
        subs(BeamPatternElements,...
        [CoefVec                , theta], ...
        [ones(size(CoefVec))    , ThetaS] ...
        )...
        )...
        ;
    A= [ ...
        -A ...
        ; ...
        A ...
        ];
    B = [-0.95 ; 1.05];
    Problem.Aineq=A;
    Problem.Bineq=B;    
    Problem.objective=MFunc;
    Problem.x0=StartPoint;    
    Problem.solver='fmincon';
    Problem.options=optimoptions(Problem.solver);
    %Problem.lb=zeros(size(CoefVec));
    [OptimalCoef,fval] = fmincon(Problem); 
    TheataValVec=linspace(-pi,pi,100);
    ResultBfVal=eval(subs(sum(OptimalCoef(:).*ComponentsVec(:)),{theta},{TheataValVec}));
    OptimalCoef=OptimalCoef/max(ResultBfVal);
    ResultBfVal=eval(subs(sum(OptimalCoef(:).*ComponentsVec(:)),{theta},{TheataValVec}));
    if StandAloneFlg
        figure;plot(linspace(-pi,pi,100),db(abs(ResultBfVal)));
        [~,MaxValInd]=max(db(abs(ResultBfVal)));
        title(...
            ['Requested \theta is : ' num2str(ThetaS/pi) '\pi ' ...
            'Max value is at ' num2str(TheataValVec(MaxValInd)/pi) '\pi'] ...
            );
    end
    transpose(A*OptimalCoef(:));
end
end

