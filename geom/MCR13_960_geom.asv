% MCR13_990_geom - script to define initial tripod and instrument geometry
% Mouth of Columbia River 2013 experiment
% xyz in meters
% pry = pitch, roll, yaw in degrees in instrument coords
% note: yaw is measured counterclockwise from x axis (cartesian conv)
%
% also note this is a adcp centric measurement system, and Chris's tripod 0
% rule was not followed.

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
instloc(2).xyz=[ 0 0 2.045];
instloc(2).pry=[0 0 0];       % ADCP beam 3 on +y
instloc(2).oname='magvar'; %
instloc(2).oval=16.31;

instloc(3).name='fanbeam sonar';
instloc(3).coord='lab';
instloc(3).xyz=[-0.517 -0.281 0.996];
instloc(3).pry=[0 0 7];  % not rotated yet
instloc(3).oname='none';
instloc(3).oval=0.;

% these are best estimate of measured values
instloc(4).name='azimuth sonar';
instloc(4).coord='lab';
instloc(4).xyz=[0.0151 0.06 1.367];    % middle of pencil head
%instloc(4).xyz=[0.85 -1.26 1.05];  %  az drive
% the yaw angle is -(180-132) (132 is the angle offset between adcp beam3
% direction (defined as +Y or 0) and the azimuth angle 0). It needs to be
% flipped 180 to get the legs in the right place
instloc(4).pry=[2.5 2.7 -45];
instloc(4).oname='tilt';
instloc(4).oval = 0.;  %from initial playing

t960.gr=[1.213 -0.574];
t960.bl= [-1.215 -1.44];
t960.rd=[-0.766 1.083];

tripod.name = 'MCR 2013- 960  north';
tripod.coord = 'lab';
tripod.bl_foot =  [-1.215 -1.44 0]; % .185 = 1/2 foot diameter of 37 cm
tripod.rd_foot = [ -0.766 1.083 0];
tripod.gr_foot = [ 1.213 -0.574 0];
% these are taken from measurements CRS made for another experiment
tripod.foothgt = .12;
tripod.footrad = .15;
tripod.apex = [-0.3 -.2 2.1];  % guessed, not measured
tripod.barhgt = 1.0;
% colors
tripod.red = [1 .2 .1 ];
tripod.blue = [.2 0 1];
tripod.green = [.1 1 .1];

% compass is a matlab function
% this sould be from the adcp or similar instriment
cmpss.xyz = [0. 0. 0.];
% ADCP pitch in (1), roll in (2), heading in (3)
% cmpss.pry = [-1.6 -1.6 134.5];
cmpss.pry = [ 0 0 0 ];
