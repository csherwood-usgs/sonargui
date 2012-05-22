% FI12_geom - script to define initial tripod and instrument geometry
% Fire Island 2012 experiment
% xyz in meters
% pry = pitch, roll, yaw in degrees in instrument coords
% note: yaw is measured counterclockwise from x axis (cartesian conv)

instloc(1).name='tripod';
instloc(1).coord='lab';
instloc(1).xyz=[0 0 0];
instloc(1).pry=[0 0 0];
instloc(1).oname='none';
instloc(1).oval=0.;

%values are from the tripod measurement sheet made prior to deployment
% origin of adcp is center of case
instloc(2).name='adcp';
instloc(2).coord='lab';
instloc(2).xyz=[ 0 0 2.06];
instloc(2).pry=[0 0 0];       % ADCP beam 3 on +y
instloc(2).oname='magvar'; % 73.090425 west on Feb-2012
instloc(2).oval=-13.5;

instloc(3).name='fanbeam sonar';
instloc(3).coord='lab';
instloc(3).xyz=[0.14 -0.4 .6];
instloc(3).pry=[0 0 -50];  % we measured fan 180, so this is corrected to 0
instloc(3).oname='none';
instloc(3).oval=0.;

% these are best estimate of measured values
instloc(4).name='azimuth sonar';
instloc(4).coord='lab';
%instloc(4).xyz=[.35 -.632 1.05];
instloc(4).xyz=[0.85 -1.26 1.05];
instloc(4).pry=[0 0 128];
instloc(4).oname='tilt';
instloc(4).oval = 0.;  %from initial playing
%instloc(4).oval = -.85;  %from initial playing
%instloc(4).oval = -2.5; % -2.5 was best fit for CRS from plot_az_crs
%instloc(4).oval=-1; % This is NOT Ellyns best fit, but works best for UNH
%instloc(4).oval=-2.; % This is Ellyns best fit

instloc(5).name='LISST';
instloc(5).coord='lab';
instloc(5).xyz=[1.04 -.32 0.845];
instloc(5).pry=[0 0 0];
instloc(5).oname='none';
instloc(5).oval=0;

tripod.name = 'Fire Island 924';
tripod.coord = 'lab';
tripod.bl_foot =  [-0.72 0.63 0]; % .185 = 1/2 foot diameter of 37 cm
tripod.rd_foot = [ 1.43 -0.28 0];
tripod.gr_foot = [ -.39 -1.68 0];
% these are taken from measurements CRS made for another experiment
tripod.foothgt = .06;
tripod.footrad = .15;
tripod.apex = [0.05 -.3 2.1];  % guessed, not measured
tripod.barhgt = 0.80;
% colors
tripod.red = [1 .2 .1 ];
tripod.blue = [.2 0 1];
tripod.green = [.1 1 .1];

% compass is a matlab function
cmpss.xyz = [0. 0. 0.];
cmpss.pry = [0. 0. 0.];
