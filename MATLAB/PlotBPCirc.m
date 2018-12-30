function PlotBPCirc(BP, BPAn, thetast, Freq, ThetaVec,FileName )


MinV=-50;
if min(10*log10(BP))> MinV
    MinV = -40 ;
end

figure;
BPdb = max(10*log10(BP),  MinV);
posiVal = BPdb(1)-0;
if posiVal > 0
    BPdb = BPdb - posiVal-eps;
end
BPnorm = BPdb-min(BPdb);
BPnorm(find(BPnorm>=-MinV))=-MinV-eps;
h=polar((ThetaVec/180*pi),BPnorm );title(['\theta_s = ',num2str(thetast*180/pi),'\circ ,freq = ',num2str(Freq),'Hz'])
set(h,'LineWidth',1.25);

t= findall(gcf,'type','text');

for ind = 1:length(t)
    if strcmp(t(ind).String,'  10') || strcmp(t(ind).String,'  20') || strcmp(t(ind).String,'  30') || strcmp(t(ind).String,'  40') || strcmp(t(ind).String,'  50') || strcmp(t(ind).String,'  60')
        delete(t(ind))
    end
end

for ind = 1:12
    
    angletmp = str2num(get(t(ind),'string'));
    set(t(ind),'string', [get(t(ind),'string'),176] );
    if MinV == -50
        set(t(ind),'Position', [57*cos(angletmp/180*pi),57*sin(angletmp/180*pi),0 ]);
    else
        set(t(ind),'Position', [47*cos(angletmp/180*pi),47*sin(angletmp/180*pi),0 ]);
        
    end
    set(t(ind),'FontName', 'Times New Roman','FontSize', 14);
    
    
    % %             set(t(ind),'string', [get(t(ind),'string'),176]);
end

if MinV == -50
    text(48*cos(72/180*pi),48*sin(72/180*pi),'0dB','FontName', 'Times New Roman','FontSize', 13)
    text(38*cos(72/180*pi),38*sin(72/180*pi),'-10dB','FontName', 'Times New Roman','FontSize', 13)
    text(28*cos(69/180*pi),28*sin(69/180*pi),'-20dB','FontName', 'Times New Roman','FontSize', 13)
    text(18*cos(65/180*pi),18*sin(65/180*pi),'-30dB','FontName', 'Times New Roman','FontSize', 13)
    text(8*cos(60/180*pi),8*sin(60/180*pi),'-40dB','FontName', 'Times New Roman','FontSize', 13)
else
    text(48*cos(72/180*pi),38*sin(72/180*pi),'0dB','FontName', 'Times New Roman','FontSize', 13)
    text(38*cos(72/180*pi),28*sin(72/180*pi),'-10dB','FontName', 'Times New Roman','FontSize', 13)
    text(28*cos(69/180*pi),18*sin(69/180*pi),'-20dB','FontName', 'Times New Roman','FontSize', 13)
    text(18*cos(65/180*pi),8*sin(65/180*pi),'-30dB','FontName', 'Times New Roman','FontSize', 13)
    %         text(8*cos(60/180*pi),8*sin(60/180*pi),'-40dB','FontName', 'Times New Roman','FontSize', 13)
end

h = findall(gcf,'type','line');
% % for ind = 2:11,set(h(ind), 'Color', [0,0,0]),end
% % for ind = 2:11,if ind==8,continue, end, set(h(ind), 'LineStyle', ':'),end
% % for ind = 2:11,set(h(ind), 'LineWidth', 1.1),end
for ind = 2:length(h),set(h(ind), 'Color', [0,0,0]),end
for ind = 2:length(h),if ind==8,continue, end, set(h(ind), 'LineStyle', ':'),end
for ind = 2:length(h),set(h(ind), 'LineWidth', 1.1),end

set(gcf,'Position', get(gcf,'Position')+[0,0,-170,0])
set(gcf,'PaperPositionMode','auto');
%              print('-depsc',FileName);

BPdbAn = max(10*log10(BPAn),  MinV);
posiVal = BPdbAn(1)-0;
if posiVal > 0
    BPdbAn = BPdbAn - posiVal-eps;
end
BPnorm = BPdbAn-min(BPdbAn);
BPnorm(find(BPnorm>=-MinV))=-MinV-eps;

hold on;h=polar((ThetaVec/180*pi),BPnorm,'r-.' );
print('-depsc',FileName);

%         BPdbJ = max(10*log10(BPJ),  -50);
%         posiVal = BPdbJ(1)-0;
%         if posiVal > 0
%             BPdbJ = BPdbJ - posiVal-eps;
%         end
%         BPnorm = BPdbJ-min(BPdbJ);
%         BPnorm(find(BPnorm>=50))=50-eps;
%         h=polar((ThetaVec/180*pi),BPnorm,'m--' );


