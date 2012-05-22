function trican3(handles)
% trican - Draws tripod

d2r = pi/180;

tpry = handles.instloc(1).pry*d2r;
txyzo = handles.instloc(1).xyz;

tripod = handles.tripod;

foothgt = tripod.foothgt;
footrad = tripod.footrad;
apx= tripod.apex;
barhgt = tripod.barhgt;

% colors
red = tripod.red;
blue = tripod.blue;
green = tripod.green;

% locations of feet in "floor" coordinates
gr=tripod.gr_foot;
bl=tripod.bl_foot;
rd=tripod.rd_foot;

% uprights from foot to corner
gup =[gr(1) gr(2) gr(3)+barhgt];
rup =[rd(1) rd(2) rd(3)+barhgt];
bup =[bl(1) bl(2) bl(3)+barhgt];

pts = [gr;gup;rup;bup;gup;apx;rup;rd;bl;bup;apx];
% reorient points here if needed
pts = r3d(pts,tpry,1);
[nr,nc]=size(pts);
pts = pts + repmat(txyzo,nr,1);

% draw with fewest possible commands
h=line(pts(1:8,1),pts(1:8,2),pts(1:8,3));
set(h,'linewidth',2,'color',[.4 .4 .5])
h=line(pts(9:11,1),pts(9:11,2),pts(9:11,3));
set(h,'linewidth',2,'color',[.4 .4 .5])

% generic cylinder
daz = 45; % angle size - smaller is smoother
az = [-180:daz:(180-daz)]';
naz = length(az);
[lidx,lidy] = xycoord(footrad*ones(size(az)),az);
can_xyz = [lidx,lidy,zeros(size(lidx)); lidx,lidy,foothgt*ones(size(lidx))];
[nr, nc]=size(can_xyz);

% green foot: translate to location
gcan_xyz = can_xyz+repmat(gr,nr,1);
% reorient here if needed
gcan_xyz = r3d(gcan_xyz,tpry, 1);
gcan_xyz = gcan_xyz + repmat(txyzo,nr,1);

% faces_matrix - each row contains the vertices that define a face
faces_matrix = zeros(naz-1,4);
for i=1:naz-1;
    faces_matrix(i,:) = [i i+1  naz+1+i naz+i];
end
faces_matrix = [faces_matrix; [naz 1 naz+1 2*naz]];
fm2 = [1:naz; (naz+1:2*naz)];

p=patch('Vertices',gcan_xyz,'Faces',faces_matrix);
set(p,'facecolor',green,'edgecolor','none');
p2 = patch('Vertices',gcan_xyz,'Faces',fm2);
set(p2,'facecolor',green,'edgecolor','none');

% red foot: translate to location
rcan_xyz = can_xyz+repmat(rd,nr,1);
% reorient here if needed
rcan_xyz = r3d(rcan_xyz,tpry, 1);
rcan_xyz = rcan_xyz + repmat(txyzo,nr,1);

% faces_matrix - each row contains the vertices that define a face
faces_matrix = zeros(naz-1,4);
for i=1:naz-1;
    faces_matrix(i,:) = [i i+1  naz+1+i naz+i];
end
faces_matrix = [faces_matrix; [naz 1 naz+1 2*naz]];
fm2 = [1:naz; (naz+1:2*naz)];

p=patch('Vertices',rcan_xyz,'Faces',faces_matrix);
set(p,'facecolor',red,'edgecolor','none');
p2 = patch('Vertices',rcan_xyz,'Faces',fm2);
set(p2,'facecolor',red,'edgecolor','none');

% blue foot: translate to location
bcan_xyz = can_xyz+repmat(bl,nr,1);
% reorient here if needed
bcan_xyz = r3d(bcan_xyz,tpry, 1);
bcan_xyz = bcan_xyz + repmat(txyzo,nr,1);

% faces_matrix - each row contains the vertices that define a face
faces_matrix = zeros(naz-1,4);
for i=1:naz-1;
    faces_matrix(i,:) = [i i+1  naz+1+i naz+i];
end
faces_matrix = [faces_matrix; [naz 1 naz+1 2*naz]];
fm2 = [1:naz; (naz+1:2*naz)];

p=patch('Vertices',bcan_xyz,'Faces',faces_matrix);
set(p,'facecolor',blue,'edgecolor','none');
p2 = patch('Vertices',bcan_xyz,'Faces',fm2);
set(p2,'facecolor',blue,'edgecolor','none');
camlight; lighting gouraud;

