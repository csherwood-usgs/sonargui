function plot_azdata2Native( handles )
% plot_azdata2Native - plot azimuth-drive sonar data with geometric correction
% csherwood@usgs.gov
%
% modified 7/30/13 emontgomery@usgs.gov
% uses native netCDF calls to access the data

% establish conversion for degrees to radians
d2r = pi/180;
% This is the distance from the axis of az drive rotation to the transducer
% Number here is based on phone conversations with Jeff Patterson at
% Imagenex during UNH tank experiments
Ro = .08255;
% other processing parameters that might change with each deployment
% uses native netCDF calls for use in matlab 2011 and newer
factor = 0.002; % converts profile_range to meters
rfactor = 0.005; % converts scan count to range in meters (I hope...not sure what this number should be)
% this may need to be set by experiment- older ones may need 57...
ntrim = 57;
%ntrim = 1;
ztrim = 1; % in m

% tripod coordinates
tpry = handles.instloc(1).pry*d2r;
txyzo = handles.instloc(1).xyz;

% azimuth-drive sonar coordinates
pry = handles.instloc(4).pry*d2r;
xyzo = handles.instloc(4).xyz;
tilt = handles.instloc(4).oval;

azdata_choice = get(handles.azdata_popupmenu5,'Value');
azfile_names = get(handles.azdata_popupmenu5,'String');

  fn=[char(handles.path) char(azfile_names(azdata_choice))];

% get which of the times in the file to use
tidx = str2num( get(handles.tindex_edit12,'String'))

points=ncread(fn,'points');
npoints=length(points);
range_config=ncreadatt(fn,'/','Range');
SampPerMeter = npoints/range_config;

if range_config < 5,    % added July '13 to allow for range=5
    factor = 0.002;
    rfactor = 1.0;
    xyout=[-1.75:.025:1.75];
    maxval=1.8;             %was 1.6
else        % these should be different with range other than 3- not sure
    factor = .0002;       % what they should be though.
    %rfactor = str2num(range_config)/3;
    rfactor=1;
    xyout=[-2.25:.025:2.25];
    maxval=2.3;
end
t1=ncread(fn,'time');
t2=ncread(fn,'time2');
try
    jt = double(t1(tidx)) + double(t2(tidx))/(1000*24*3600);
    dn = datenum(gregorian(double(jt)));
    set(handles.datetime_edit11,'String',datestr(dn))

    %datestr(dn)
    azang=ncread(fn,'azangle');
    azangle=squeeze(azang(:,tidx));
    hang=ncread(fn,'headangle');
    beta = squeeze(hang(1:end-ntrim,:,tidx))'+tilt; % pencil head angle, conv. to radiansbeta = d2r*beta;
    
    profile_range=ncread(fn,'profile_range');
    PR = factor*squeeze(profile_range(:,:, tidx))';
    beta = d2r*beta;
    [naz nang]=size(beta);
    % PRi = 0*PR; % array for estimated profile range
    % BSi = 0*PR; % array for strength of backscatter
    raw_image=ncread(fn,'raw_image');
    if(1) % estimate profile ranges from maxima of returns
        % indices swapped, and transpose needed to make native match plotaz2
        for iAz=1:naz
            raw_img=squeeze(raw_image(:,:,iAz,tidx))';
            % Find the equivalent of profile_range
            [mx,imx]=max(raw_img(1:end-ntrim,1:end-ntrim));
            PRi(iAz,:)= (imx+(ntrim-1))*range_config*factor;
            BSi(iAz,:)= mx;
        end
    end
      
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
            ((x(:)-xo)>-maxval) & ((x(:)-xo)<maxval) &...
            ((y(:)-yo)>-maxval) & ((y(:)-yo)<maxval) );
        if ~isempty(ok)
            [zg,xg,yg] = gridfit(x(ok)-xo,y(ok)-yo,z(ok),xyout,xyout,'smooth',.1);
            [nr,nc]=size(zg);
            nn=length(zg(:));
            ray_xyz = r3d([xg(:)+xo yg(:)+yo zg(:)],tpry, 1);
            ray_xyz = ray_xyz + repmat(txyzo,nn,1);
            xg = reshape(ray_xyz(:,1),nr,nc);
            yg = reshape(ray_xyz(:,2),nr,nc);
            zg = reshape(ray_xyz(:,3),nr,nc);
            surf(xg,yg,zg)
            %view(0,90)
            shading flat
            %title(['MCR2013 960 North -  ' datestr(dn)])
            %xlabel('distance(m)')
            %ylabel('distance(m)')
            caxis([-.5 .4])
            % colorbar
            shg
            hh = findobj('Type','surface');
        else
            disp('no good data to contour')
        end
    end
catch me
end


