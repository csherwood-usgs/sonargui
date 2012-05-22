% mvco_geom - script to define initial tripod and instrument geometry
% MVCO2007 experiment
% xyz in meters
% pry = pitch, roll, yaw in degrees in instrument coords
% note: yaw is measured counterclockwise from x axis (cartesian conv)

instloc(1).name='tripod';
instloc(1).coord='lab';
instloc(1).xyz=[0 0 0];
instloc(1).pry=[0 0 0];
instloc(1).oname='none';
instloc(1).oval=0.;

% origin of adcp is center of case
% notes say top of case is 193.3 cmab, bottom is 154.4 cmab
% ...so center is 1.744 mab, and case is 38.9 cm long
instloc(2).name='adcp';
instloc(2).coord='lab';
instloc(2).xyz=[ 0.16 -.67 2.06];
instloc(2).pry=[0 0 -59.6];
instloc(2).oname='magvar'; % 15d28m west on 9-Dec-2009
instloc(2).oval=-15.4667;

instloc(3).name='fanbeam sonar';
instloc(3).coord='lab';
instloc(3).xyz=[0. -1.14 .65];
instloc(3).pry=[0 0 -92];
instloc(3).oname='none';
instloc(3).oval=0.;

% these are best estimate of measured values
instloc(4).name='azimuth sonar';
instloc(4).coord='lab';
instloc(4).xyz=[0.06 -2.1 1.1];
instloc(4).pry=[2 0 -97];
instloc(4).oname='tilt';
instloc(4).oval = -2.5; % -2.5 was best fit for CRS from plot_az_crs
%instloc(4).oval=-1; % This is NOT Ellyns best fit, but works best for UNH
%instloc(4).oval=-2.; % This is Ellyns best fit

instloc(5).name='ez compass';
instloc(5).coord='lab';
instloc(5).xyz=[-.14 -1.529 1.055];
instloc(5).pry=[0 0 -99];
instloc(5).oname='magvar';
instloc(5).oval=-15.4667;

tripod.name = 'MVCO 836';
tripod.coord = 'lab';
tripod.bl_foot =  [ 0.93+.185 -1.645 0]; % .185 = 1/2 foot diameter of 37 cm
tripod.rd_foot = [ 0 0+.185 0];
tripod.gr_foot = [ -0.945-.185 -1.645 0];
tripod.foothgt = .06;
tripod.footrad = .15;
tripod.apex = [0 -.83 1.8];
tripod.barhgt = 0.75;
% colors
tripod.red = [1 0 .2 ];
tripod.blue = [.2 0 1];
tripod.green = [.1 1 .1];

% compass is a matlab function
cmpss.xyz = [0. 0. 0.];
cmpss.pry = [0. 0. 0.];
