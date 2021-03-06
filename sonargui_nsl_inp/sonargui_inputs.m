% sonargui_inputs
%
% This supplies information that is put into the experiments box
% it allows users to specify the paths, names and functions needed to do
% the tripod mapping without editing the sonargui program or messing with
% GUIDE.  You can also easily add new experiments by adding a new set of
% input structure elements
%  experiment, exname, dpath and function are required elements
%
% having edited this file to suit your machine, execute it to load it into 
% the workspace, then invoke sonargui :
%   sonargui (path_names, expnames, fcns)
%
addpath 'C:\Users\emontgomery\Documents\GitHub\sonargui\geom'
input_struct(1).experiment='UNH Tank';
input_struct(1).dpath='c:\home\data\sonar_az_keep4sonargui\unh_tank\';
input_struct(1).function='unh_geom';  % must be in the geom directory above
input_struct(1).exname='UNH Tank';
input_struct(2).exname='MVCO 2007';
input_struct(2).experiment='MVCO 2007';
input_struct(2).dpath='c:\home\data\sonar_az_keep4sonargui\mvco_07\';
input_struct(2).function='mvco_geom';  % make sure this is the $MATLABPATH
input_struct(3).exname='Fire Island 2012';
input_struct(3).experiment='Fire Island 2012';
input_struct(3).dpath='c:\home\data\FI12\sonar_post\Iris_az\';
input_struct(3).function='FI12_geom';  % make sure this is the $MATLABPATH
input_struct(4).exname='MCR 2013- 959 West';
input_struct(4).experiment='MCR 2013- 959 West';
input_struct(4).dpath='c:\home\data\proc\959west_az\azm_files\';
input_struct(4).function='MCR13_959_geom';  % make sure this is the $MATLABPATH
input_struct(5).exname='MCR 2013- 960 North';
input_struct(5).experiment='MCR 2013- 960 North';
input_struct(5).dpath='c:\home\data\proc\960north_az_fan\azm_files\';
input_struct(5).function='MCR13_960_geom';  % make sure this is the $MATLABPATH
input_struct(6).exname='Hatteras 2009- 855';
input_struct(6).experiment='Hatteras 2009- 855';
input_struct(6).dpath='c:\home\data\sonar_az_keep4sonargui\hatteras09\';
input_struct(6).function='hatteras09_geom';  % make sure this is the $MATLABPATH

%Now put the structure items into cell arrays
for ik=1:length(input_struct)
    path_names(ik)=cellstr(input_struct(ik).dpath);
    expnames(ik)=cellstr(input_struct(ik).exname);
    fcns(ik)=cellstr(input_struct(ik).function);
end
