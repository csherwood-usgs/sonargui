function plot_azdata( handles );
% plot_azdata - plot azimuth-drive sonar data with geometric correction
% csherwood@usgs.gov

d2r = pi/180;
% This is the distance from the axis of az drive rotation to the transducer
% Number here is based on phone conversations with Jeff Patterson at
% Imagenex during UNH tank experiments
Ro = .08255;
% other processing parameters that might change with each deployment
factor = 0.002; % converts profile_range to meters
rfactor = 0.005; % converts scan count to range in meters (I hope...not sure what this number should be)
ntrim = 57;
ztrim = 1; % in m

% tripod coordinates
tpry = handles.instloc(1).pry*d2r;
txyzo = handles.instloc(1).xyz;

% azimuth-drive sonar coordinates (should be element 4)
pry = handles.instloc(4).pry*d2r;
xyzo = handles.instloc(4).xyz;
tilt = handles.instloc(4).oval;

azdata_choice = get(handles.azdata_popupmenu5,'Value');
azfile_names = get(handles.azdata_popupmenu5,'String');

  fn=azfile_names(azdata_choice);
  fn=[handles.path char(fn)];

% azdata_choice = get(handles.azdata_popupmenu5,'Value');
% switch azdata_choice
%    case 1
%       disp('why am i here?')
%    case 2
%       fn = [handles.path 'az2009-12-09_raw.cdf'];
%    case 3
%       fn = [handles.path 'az2009-12-09b_raw.cdf'];
%    case 4
%       fn = [handles.path 'az2009-12-09c_raw.cdf'];
%    case 5
%       fn = [handles.path 'az2007-08-28_raw.cdf'];
%    case 6
%       fn = [handles.path 'az2007-08-29_raw.cdf'];
%    case 7
%       fn = [handles.path 'az2007-08-30_raw.cdf'];
%    case 8
%       fn = [handles.path 'az2007-08-31_raw.cdf'];
%    case 9
%       fn = [handles.path 'az2007-09-01_raw.cdf'];
%    case 10
%       fn = [handles.path 'az2007-09-02_raw.cdf'];
%    case 11
%       fn = [handles.path 'az2007-09-03_raw.cdf'];
%    case 12
%       fn = [handles.path 'az2007-09-04_raw.cdf'];
%    case 13
%       fn = [handles.path 'az2007-09-05_raw.cdf'];
%    case 14
%       fn = [handles.path 'az2007-09-06_raw.cdf'];
%    case 15
%       fn = [handles.path 'az2007-09-07_raw.cdf'];
%    case 16
%       fn = [handles.path 'az2007-09-08_raw.cdf'];
%    case 17
%       fn = [handles.path 'az2007-09-09_raw.cdf'];
%    case 18
%       fn = [handles.path 'az2007-09-10_raw.cdf'];
%    case 19
%       fn = [handles.path 'az2007-09-11_raw.cdf'];
%    case 20
%       fn = [handles.path 'az2007-09-12_raw.cdf'];
%    case 21
%       fn = [handles.path 'az2007-09-13_raw.cdf'];
%    case 22
%       fn = [handles.path 'az2007-09-14_raw.cdf'];
%    case 23
%       fn = [handles.path 'az2007-09-15_raw.cdf'];
%    case 24
%       fn = [handles.path 'az2007-09-16_raw.cdf'];
%    case 25
%       fn = [handles.path 'az2007-09-17_raw.cdf'];
%    case 26
%       fn = [handles.path 'az2007-09-18_raw.cdf'];
%    case 27
%       fn = [handles.path 'az2007-09-19_raw.cdf'];
%    case 28
%       fn = [handles.path 'az2007-09-20_raw.cdf'];
%    case 28
%       fn = [handles.path 'az2007-09-21_raw.cdf'];
%    case 30
%       fn = [handles.path 'az2007-09-22_raw.cdf'];
%    case 31
%       fn = [handles.path 'az2007-09-23_raw.cdf'];
%    case 32
%       fn = [handles.path 'az2007-09-24_raw.cdf'];
%    case 33
%       fn = [handles.path 'az2007-09-25_raw.cdf'];
%    case 34
%       fn = [handles.path 'az2007-09-26_raw.cdf'];
%    case 35
%       fn = [handles.path 'az2007-09-27_raw.cdf'];
%    case 36
%       fn = [handles.path 'az2007-09-28_raw.cdf'];
%    case 37
%       fn = [handles.path 'az2007-09-29_raw.cdf'];
%    case 38
%       fn = [handles.path 'az2007-09-30_raw.cdf'];
%    case 39
%       fn = [handles.path 'az2007-10-01_raw.cdf'];
%    case 40
%       fn = [handles.path 'az2012-01-30_raw.cdf'];
%   case 41
%       fn = [handles.path 'az2012-01-31_raw.cdf'];
%    case 42
%       fn = [handles.path 'az2012-02-01_raw.cdf'];
%   case 43
%       fn = [handles.path 'az2012-02-02_raw.cdf'];
%    case 44
%       fn = [handles.path 'az2012-02-03_raw.cdf'];
%   case 45
%       fn = [handles.path 'az2012-02-04_raw.cdf'];
%       otherwise
%       disp('pourquois suis-je ici?')
% end
tidx = str2num( get(handles.tindex_edit12,'String'))
% fn='az2009-12-08_raw.cdf' % MVCO
%%
% ncload(fn,'time','time2','scan','points','rots','headangle','azangle','profile_range');
nc = netcdf(fn);
npoints = nc.DataPoints(:)
range_config=nc.Range(:)
SampPerMeter = npoints/range_config
jt = nc{'time'}(tidx) + nc{'time2'}(tidx)/(1000*24*3600);
dn = datenum(gregorian(double(jt)));
datestr(dn)
set(handles.datetime_edit11,'String',datestr(dn))
azangle=squeeze(nc{'azangle'}(tidx,:));
beta = squeeze(nc{'headangle'}(tidx,:,1:end-ntrim))+tilt; % pencil head angle, conv. to radians
beta = d2r*beta;
PR = factor*squeeze(nc{'profile_range'}(tidx,:,1:end-ntrim));

%PR = factor*squeeze(profile_range(:,1:end-ntrim));
[naz nang]=size(beta);
PRi = 0*PR; % array for estimated profile range
BSi = 0*PR; % array for strength of backscatter
if(1) % estimate profile ranges from maxima of returns
   for iAz=1:naz
      raw_img=squeeze(nc{'raw_image'}(tidx,iAz,:,1:nang));
      % Find the equivalent of profile_range
      [mx,imx]=max(raw_img(50:end,:));
      PRi(iAz,:)= (imx+49)*range_config*factor;
      BSi(iAz,:)= mx;
   end
end
ncclose
%%
% At this point, xyzo, pry, and Ro have az drive geometry info, and txyzo
% and tpry have tripod geometry info. PRi contains estimate of distance to
% target for each beam, azangle contains azimuth of sonar head, and beta
% contains sweep angle of pencil beam == ray position in y - z plane.
% Calculate the endpoints for rays emanating from the sonar head, reorient
% them to instrument, then tripod coords, and plot.
x = NaN*ones(naz*nang,1); y=x; z=x;
for i=1:naz
   ray_xyz = [Ro*ones(1,nang)' (PRi(i,:).*sin(beta(i,:)))' -(PRi(i,:).*cos(beta(i,:)))' ];
   ray_xyzo = [Ro 0 0];
   
   % reorient here if needed
   % TODO - Subtraction of azangle from yaw was determined empirically
   apry = [pry(1) pry(2) pry(3)-(azangle(i)*d2r) ];
   [nr,nc]=size(ray_xyz);
   ray_xyz = r3d(ray_xyz,apry, 0);
   ray_xyz = ray_xyz + repmat(xyzo,nr,1);

   % save values (these are still relative to azimuth sonar
   x( (i-1)*nang+1:i*nang,1 ) = ray_xyz(:,1);
   y( (i-1)*nang+1:i*nang,1 ) = ray_xyz(:,2);
   z( (i-1)*nang+1:i*nang,1 ) = ray_xyz(:,3);
      
   % reorient to tripod
   if(0) % do this later
   [nr,nc]=size(ray_xyz);
   ray_xyz = r3d(ray_xyz,tpry, 1);
   ray_xyz = ray_xyz + repmat(txyzo,nr,1);
   % select points to plot
   ok = find(ray_xyz(:,3)>-.6 & ray_xyz(:,3)<1);
   end
   
   if(0)
      % color by depth
      h=scatter3(ray_xyz(ok,1),ray_xyz(ok,2),ray_xyz(ok,3),10,ray_xyz(ok,3),'filled'); hold on
      caxis([-.2 .2])
   elseif(0)
      % array of backscatter values
      % TODO - maybe scale these with range to provide more info
      BS = BSi(iAz,ok)';
      % color by backscatter intensity
      h=scatter3(ray_xyz(ok,1),ray_xyz(ok,2),ray_xyz(ok,3),10,BS,'filled'); hold on
      caxis([0 127])
   end
end
% xyzo
% txyzo
% save xyz x y z % for debugging

% use gridfit to fit a surface in selected subregion, but first center it around azdrive
% location by removing horizontal az location + tripod offset (add it back later)

% xo = xyzo(1)+txyzo(1);
% yo = xyzo(2)+txyzo(2);
% xo = 0;
% yo = 0;
xo = xyzo(1);
yo = xyzo(2);
if(1)
ok = find( isfinite(x(:)+y(:)+z(:)) & ...
   (z(:)>-.4) & (z(:)<.4) & ...
   ((x(:)-xo)>-1.6) & ((x(:)-xo)<1.6) &...
   ((y(:)-yo)>-1.6) & ((y(:)-yo)<1.6) );

[zg,xg,yg] = gridfit(x(ok)-xo,y(ok)-yo,z(ok),[-1.25:.025:1.25],[-1.25:.025:1.25],'smooth',.1);
[nr,nc]=size(zg);
nn=length(zg(:))
   ray_xyz = r3d([xg(:)+xo yg(:)+yo zg(:)],tpry, 1);
   ray_xyz = ray_xyz + repmat(txyzo,nn,1);
   xg = reshape(ray_xyz(:,1),nr,nc);
   yg = reshape(ray_xyz(:,2),nr,nc);
zg = reshape(ray_xyz(:,3),nr,nc);
surf(xg,yg,zg)
shading flat
shg
hh = findobj('Type','surface');
end
