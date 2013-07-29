function azcan3( handles )
% azcan3 - draws the azimuth sonar
% pry is 1x3 attitude vector with angles of pitch, roll, and yaw
% xyzo is a 1x3 origin vector (length dimensions, e.g., meters) located at the bottom of the can.
d2r = pi/180;

if( exist('Ro','var')~=1 ), Ro = .08255; end
% from settings.Pencil_tilt. This is the offset from vertical in headangle

% tripod coordinates
tpry = handles.instloc(1).pry*d2r;
txyzo = handles.instloc(1).xyz;

% azimuth-drive sonar coordinates
pry = handles.instloc(4).pry*d2r;
xyzo = handles.instloc(4).xyz;
tilt = handles.instloc(4).oval;

rad = 0.08;
blklen = .03;
redlen =  Ro-blklen;

% azimuth drive data has dimensions of time, scan, points, and rots
%
% headangle(time, rots, scan)
% azangle( time, rots)


% origin of pencil beam transducer as azimuth drive rotates
daz = 45; % angle size - smaller is smoother
az = [-180:daz:(180-daz)]';
naz = length(az);
% lid is circle on y-z plane at x = 0
[lidy,lidz] = xycoord(rad*ones(size(az)),az);

% red can (transducer end)
rcan_xyz = [Ro*ones(size(lidy)), lidy, lidz; (Ro-blklen)*ones(size(lidy)), lidy, lidz];
% black can
bcan_xyz = [-redlen*ones(size(lidy)), lidy, lidz; (Ro-blklen)*ones(size(lidy)), lidy, lidz];
[nr, nc]=size(bcan_xyz);

% reorient here if needed
bcan_xyz = r3d(bcan_xyz,pry, 0 );
bcan_xyz = bcan_xyz + repmat(xyzo,nr,1);
rcan_xyz = r3d(rcan_xyz,pry, 0 );
rcan_xyz = rcan_xyz + repmat(xyzo,nr,1);
bcan_xyz = r3d(bcan_xyz,tpry, 1 );
bcan_xyz = bcan_xyz + repmat(txyzo,nr,1);
rcan_xyz = r3d(rcan_xyz,tpry, 1 );
rcan_xyz = rcan_xyz + repmat(txyzo,nr,1);

% I had to number the vertices to figure out how to do faces_matrix
% for i=1:2*naz
% text(bcan_xyz(i,1),bcan_xyz(i,2),bcan_xyz(i,3),num2str(i))
% hold on
% end

% faces_matrix - each row contains the vertices that define a face
% (works for both cans, since they have the same # faces)
faces_matrix = zeros(naz-1,4);
for i=1:naz-1;
    faces_matrix(i,:) = [i i+1  naz+1+i naz+i];
end
faces_matrix = [faces_matrix; [naz 1 naz+1 2*naz]];
fm2 = [1:naz; (naz+1:2*naz)];

% calculate rays indicating pencil beams
beta = [-80 -45 0 45 80]'+tilt; % check sign on tilt
prange = ones(size(beta)); % make the rays one meter long
% ray position in y - z plane
ray_xyz = [Ro*ones(size(beta)) prange.*sin( beta*d2r ) -prange.*cos( beta*d2r ) ]; 
ray_xyzo = [Ro 0 0];

% reorient here if needed
[nr,nc]=size(ray_xyz);
ray_xyz = r3d(ray_xyz,pry, 0);
ray_xyz = ray_xyz + repmat(xyzo,nr,1);
ray_xyzo = r3d(ray_xyzo,pry, 0);
ray_xyzo = ray_xyzo + xyzo;
% reorient to tripod
[nr,nc]=size(ray_xyz);
ray_xyz = r3d(ray_xyz,tpry, 1);
ray_xyz = ray_xyz + repmat(txyzo,nr,1);
ray_xyzo = r3d(ray_xyzo,tpry, 1);
ray_xyzo = ray_xyzo + txyzo;

% draw black (actually gray) can
gray = [.6 .6 .8];
p=patch('Vertices',bcan_xyz,'Faces',faces_matrix);
set(p,'facecolor',gray,'edgecolor','black');
p2 = patch('Vertices',bcan_xyz,'Faces',fm2);
set(p2,'facecolor',gray,'edgecolor','none');
camlight; lighting gouraud;

% draw red can
p3=patch('Vertices',rcan_xyz,'Faces',faces_matrix);
set(p3,'facecolor','red','edgecolor','none');
p4 = patch('Vertices',rcan_xyz,'Faces',fm2);
set(p4,'facecolor','red','edgecolor','none');
camlight; lighting gouraud;

% draw rays
for i=1:nr
   h=line([ray_xyzo(1);ray_xyz(i,1)],[ray_xyzo(2);ray_xyz(i,2)],[ray_xyzo(3);ray_xyz(i,3)]);
   set(h,'linestyle','--','color','red')
end

% axis(.2*[ -1 1 -1 1 -1 1])