% UNH_GEOM - script to define initial tripod and instrument geometry
% UNH experiment
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
instloc(2).xyz=[0 0 1.744];
%instloc(2).pry=[-2.5 0.3 0];
instloc(2).pry=[-2.42 -2 0];
instloc(2).oname='magvar'; % 15d28m west on 9-Dec-2009
instloc(2).oval=-15.4667;

instloc(3).name='fanbeam sonar';
instloc(3).coord='lab';
instloc(3).xyz=[-.197 -.512 .594];
instloc(3).pry=[0 -1.89 -152];
instloc(3).oname='none';
instloc(3).oval=0.;

% these are best estimate of measured values
instloc(4).name='azimuth sonar';
instloc(4).coord='lab';
instloc(4).xyz=[-.14 -1.529 1.08];
instloc(4).pry=[2 1.8 -82];
instloc(4).oname='tilt';
instloc(4).oval=-1; % This is NOT Ellyns best fit, but works best for UNH
%instloc(4).oval=-2.; % This is Ellyns best fit

instloc(5).name='ez compass';
instloc(5).coord='lab';
instloc(5).xyz=[-.14 -1.529 1.055];
instloc(5).pry=[0 0 -99];
instloc(5).oname='magvar';
instloc(5).oval=-15.4667;

tripod.name = 'UNH';
tripod.coord = 'lab';
tripod.bl_foot =  [-0.17 0.87 0];
tripod.rd_foot = [0.97 -1.070 0];
tripod.gr_foot = [-1.21 -1.185 0];
tripod.foothgt = .06;
tripod.footrad = .15;
tripod.apex = [-.2 -.25 1.8];
tripod.barhgt = 0.75;
% colors
tripod.red = [1 0 .2 ];
tripod.blue = [.2 0 1];
tripod.green = [.1 1 .1];

% compass is a matlab function
cmpss.xyz = [0. 0. 0.];
cmpss.pry = [0. 0. 0.];

