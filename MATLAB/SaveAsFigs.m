%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SaveAsFigs - Creates a 'Figures' folder in the given location and saves the figure of the given handle there, under the name specified in "Title".
%  The figure is saved in 2 formats - a '.fig' (matlab file) and '.emf' ,Windows Enhanced Meta-File (best for powerpoints).
%
% Usage:
%   SaveAsFigs(h,ResultsPath,Title)
%
% Inputs:
%   Input1 :: h - handle of figure to save
%   Input2  :: ResultsPath - path of folder in which the figures folder will be created
%   Input3  :: Title - name of saved figure
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% History
% 23/7/2013
%   - Bugfix: 
%   - Bugfix: 
%   - Additions: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SaveAsFigs(h,ResultsPath,Title)
cdNow=cd;
if exist([ResultsPath '\Figures'],'file')~=7
    mkdir([ResultsPath '\Figures']);
end
cd([ResultsPath '\Figures']);
saveas(h, [Title '.fig']) %Matlab .FIG file
% saveas(h, [Title '.emf']) %Windows Enhanced Meta-File (best for powerpoints)
cd(cdNow);
end

