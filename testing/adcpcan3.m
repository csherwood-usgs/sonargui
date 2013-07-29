function adcpcan3( handles )
% adcpcan - Draws an ADCP

d2r = pi/180;

if( exist('rad','var')~=1 ), rad = .15; end
beam_ang = 30*d2r; % ADCP beam angle from vertical
beam_len = 1;      % ADCP beam length
caselen = .389;    % length of case
caserad = .12;     % radius of case

% tripod coordinates  (assumes tripod is always in the (1) element
tpry = handles.instloc(1).pry*d2r;
txyzo = handles.instloc(1).xyz;
% adcp coordinates  (assumes adcp is always the (2) element
pry = handles.instloc(2).pry*d2r;
xyzo = handles.instloc(2).xyz;

% calculate endpoints of rays indicating ADCP beams
% Note that this assumes an upward looking ADCP and is 
% not drawn this in real ADCP coords
ray_xyz = zeros(4,3);
ray_xyz(3,:) = [0 beam_len*sin(beam_ang) beam_len*cos(beam_ang)];
ray_xyz(4,:) = [0 -beam_len*sin(beam_ang) beam_len*cos(beam_ang)];
ray_xyz(1,:) = [beam_len*sin(beam_ang) 0 beam_len*cos(beam_ang)];
ray_xyz(2,:) = [-beam_len*sin(beam_ang) 0 beam_len*cos(beam_ang)];
% ray origin == center of instrument (correct?)
ray_xyzo = [0 0 0];
% reorient to lab coords
[nr,nc]=size(ray_xyz);
ray_xyz = r3d(ray_xyz,pry, 0);
ray_xyz = ray_xyz + repmat(xyzo,nr,1);
ray_xyzo = r3d(ray_xyzo,pry, 0);
ray_xyzo = ray_xyzo + xyzo;
% reorient to tripod coords
ray_xyz = r3d(ray_xyz,tpry, 1);
ray_xyz = ray_xyz + repmat(txyzo,nr,1);
ray_xyzo = r3d(ray_xyzo,tpry, 1);
ray_xyzo = ray_xyzo + txyzo;

% draw rays
for i=1:nr
   h=line([ray_xyzo(1);ray_xyz(i,1)],[ray_xyzo(2);ray_xyz(i,2)],[ray_xyzo(3);ray_xyz(i,3)]);
   set(h,'linewidth',2,'linestyle','--','color',[.3 .3 1])
   if(i==3), set(h,'linewidth',2,'linestyle','-','color',[0 0 1]); end
end

daz = 45; % angle size - smaller is smoother
az = [-180:daz:(180-daz)]';
naz = length(az);
[lidx,lidy] = xycoord(caserad*ones(size(az)),az);
can_xyz = [lidx,lidy,-0.5*caselen*ones(size(lidx)); lidx,lidy,+0.5*caselen*ones(size(lidx))];
[nr, nc]=size(can_xyz);
% reorient here if needed
can_xyz = r3d(can_xyz,pry, 0);
can_xyz = can_xyz + repmat(xyzo,nr,1);
can_xyz = r3d(can_xyz,tpry, 1);
can_xyz = can_xyz + repmat(txyzo,nr,1);

% plot lines from sonar
% magenta line straight down
vline = [0 0 0; 0 0 -1];
vline = r3d( vline, pry, 0 );
vline = vline+repmat(xyzo,2,1);
vline = r3d( vline, tpry, 1 );
vline = vline+repmat(txyzo,2,1);
h2 = line(vline(:,1),vline(:,2),vline(:,3),'linewidth',2,'color',[1 0 1]);
% green line to starboard
cline = [0 0 0; +0.2 0 0];
cline = r3d( cline, pry, 0 );
cline = cline+repmat(xyzo,2,1);
cline = r3d( cline, tpry, 1 );
cline = cline+repmat(txyzo,2,1);
h2 = line(cline(:,1),cline(:,2),cline(:,3),'linewidth',2,'color',[0 1 0]);
% red line to port
cline = [0 0 0; -0.2 0 0];
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

% I had to number the vertices to figure out how to do faces_matrix
% for i=1:2*naz
% text(can_xyz(i,1),can_xyz(i,2),can_xyz(i,3),num2str(i))
% hold on
% end

% faces_matrix - each row contains the vertices that define a face
faces_matrix = zeros(naz-1,4);
for i=1:naz-1;
    faces_matrix(i,:) = [i i+1  naz+1+i naz+i];
end
faces_matrix = [faces_matrix; [naz 1 naz+1 2*naz]];
fm2 = [1:naz; (naz+1:2*naz)];

p=patch('Vertices',can_xyz,'Faces',faces_matrix);
set(p,'facecolor',[.9 .9 1],'edgecolor','none');
p2 = patch('Vertices',can_xyz,'Faces',fm2);
set(p2,'facecolor',[0 0 .9],'edgecolor','none');
camlight; lighting gouraud;
hold on

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