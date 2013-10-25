% hatteras09_geom - script to define initial tripod and instrument geometry
% Cape hatteras 2009 experiment
% xyz in meters
% pry = pitch, roll, yaw in degrees in instrument coords
% note: yaw is measured counterclockwise from x axis (cartesian conv)
%
% also note this is a adcp centric measurement system, with + Y along ADCCP
% beam 3.

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
instloc(2).oval=-10.8;

instloc(3).name='fanbeam sonar';
instloc(3).coord='lab';
instloc(3).xyz=[0.159 0.475 .63];
instloc(3).pry=[0 0 103];  % 
instloc(3).oname='none';
instloc(3).oval=0.;

% these are best estimate of measured values
instloc(4).name='azimuth sonar';
instloc(4).coord='lab';
instloc(4).xyz=[-0.172 -1.517 1.05];    % middle of pencil head
%instloc(4).xyz=[0.85 -1.26 1.05];  %  az drive
% the yaw angle is -(180-132) (132 is the angle offset between adcp beam3
% direction (defined as +Y or 0) and the azimuth angle 0). It needs to be
% flipped 180 to get the legs in the right place
instloc(4).pry=[-1.80 0 -93];
instloc(4).oname='tilt';
instloc(4).oval = 0.;  %from initial playing
%instloc(4).oval = -.85;  %from initial playing
%instloc(4).oval = -2.5; % -2.5 was best fit for CRS from plot_az_crs
%instloc(4).oval=-1; % This is NOT Ellyns best fit, but works best for UNH
%instloc(4).oval=-2.; % This is Ellyns best fit

tripod.name = 'Hatteras09 - 855';
tripod.coord = 'lab';
tripod.bl_foot =  [-0.17 0.87 0]; % .185 = 1/2 foot diameter of 37 cm
tripod.rd_foot = [ 0.97 -1.07 0];
tripod.gr_foot = [ -1.21 -1.185 0];
% these are taken from measurements CRS made for another experiment
tripod.foothgt = .06;
tripod.footrad = .15;
tripod.apex = [-0.05 -.3 2.1];  % guessed, not measured
tripod.barhgt = 0.80;
% colors
tripod.red = [1 .2 .1 ];
tripod.blue = [.2 0 1];
tripod.green = [.1 1 .1];

% compass is a matlab function
% this sould be from the adcp or similar instriment
cmpss.xyz = [0. 0. 0.];
% ADCP pitch in (1), roll in (2), heading in (3)
cmpss.pry = [2 -1.2 358];
