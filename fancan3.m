function fancan3( handles )
% fancan - Draws a red vertical can to represent fan beam
% pry is 1x3 attitude vector with angles of pitch, roll, and yaw
% xyzo is a 1x3 origin vector (length dimensions, e.g., meters) located at the bottom of the can.
d2r = pi/180;
if( exist('rad','var')~=1 ), rad = .05; end
if( exist('len','var')~=1), len = .4; end

% tripod coordinates
tpry = handles.instloc(1).pry*d2r;
txyzo = handles.instloc(1).xyz;
% fanbeam coordinates
pry = handles.instloc(3).pry*d2r;
xyzo = handles.instloc(3).xyz;

daz = 45; % angle size - smaller is smoother
az = [-180:daz:(180-daz)]';
naz = length(az);
[lidx,lidy] = xycoord(rad*ones(size(az)),az);

can_xyz = [lidx,lidy,zeros(size(lidx)); lidx,lidy,len*ones(size(lidx))];
[nr, nc]=size(can_xyz);

% reorient instrument
can_xyz = r3d(can_xyz,pry, 0);
can_xyz = can_xyz + repmat(xyzo,nr,1);
% reorient to tripod
can_xyz = r3d(can_xyz,tpry, 1);
can_xyz = can_xyz + repmat(txyzo,nr,1);

% I had to number the vertices to figure out how to do faces_matrix
% for i=1:2*naz
% text(can_xyz(i,1),can_xyz(i,2),can_xyz(i,3),num2str(i))
% hold on
% end


% plot lines from sonar
% magenta line straight down
vline = [0 0 0; 0 0 -.5];
vline = r3d( vline, pry, 0 );
vline = vline+repmat(xyzo,2,1);
vline = r3d( vline, tpry, 1 );
vline = vline+repmat(txyzo,2,1);
h2 = line(vline(:,1),vline(:,2),vline(:,3),'linewidth',2,'color',[1 0 1]);
% green line to starboard
cline = [0 0 0; +0.4 0 0];
cline = r3d( cline, pry, 0 );
cline = cline+repmat(xyzo,2,1);
cline = r3d( cline, tpry, 1 );
cline = cline+repmat(txyzo,2,1);
h2 = line(cline(:,1),cline(:,2),cline(:,3),'linewidth',2,'color',[0 1 0]);
% red line to port
cline = [0 0 0; -0.4 0 0];
cline = r3d( cline, pry, 0 );
cline = cline+repmat(xyzo,2,1);
cline = r3d( cline, tpry, 1 );
cline = cline+repmat(txyzo,2,1);
h2 = line(cline(:,1),cline(:,2),cline(:,3),'linewidth',2,'color',[1 0 0]);
% black line forward
cline = [0 0 0; 0 +.5 0];
cline = r3d( cline, pry, 0 );
cline = cline+repmat(xyzo,2,1);
cline = r3d( cline, tpry, 1 );
cline = cline+repmat(txyzo,2,1);
h2 = line(cline(:,1),cline(:,2),cline(:,3),'linewidth',2,'color',[0 0 0]);

% faces_matrix - each row contains the vertices that define a face
faces_matrix = zeros(naz-1,4);
for i=1:naz-1;
    faces_matrix(i,:) = [i i+1  naz+1+i naz+i];
end
faces_matrix = [faces_matrix; [naz 1 naz+1 2*naz]];
fm2 = [1:naz; (naz+1:2*naz)];

p=patch('Vertices',can_xyz,'Faces',faces_matrix);
set(p,'facecolor','red','edgecolor','none');
p2 = patch('Vertices',can_xyz,'Faces',fm2);
set(p2,'facecolor','red','edgecolor','none');
camlight; lighting gouraud;

% point below the instrument origin
nadir = [vline(1,1) vline(1,2) 0];
plot3(nadir(1),nadir(2),nadir(3),'.k')

% vertices of a plane...in this case, flat floor
v0 =[-10 -10 0]; v1=[10 -10 0]; v2=[0 10 0];
origin = vline(1,:);
ptdirec = vline(2,:)-vline(1,:);
ptdirec = ptdirec ./norm(ptdirec);
% determine intersection of the instrument axis with the floor
[flag, u, v, t] = rayTriangleIntersection(vline(1,:), ptdirec, v0, v1, v2);
xyzi = origin + t*ptdirec;
if(flag) % if the point intesects the floor
   plot3(xyzi(1),xyzi(2),xyzi(3),'.r')
   relx_str = sprintf('%5.2f',xyzi(1));
   rely_str = sprintf('%5.2f',xyzi(2));
%    set(handles.relx_edit7,'String',relx_str);
%    set(handles.rely_edit8,'String',rely_str);
end