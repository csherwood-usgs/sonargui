function varargout = sonargui(varargin)
% SONARGUI MATLAB code for sonargui.fig
%      SONARGUI, by itself, creates a new SONARGUI or raises the existing
%      singleton*.
%
%      H = SONARGUI returns the handle to a new SONARGUI or the handle to
%      the existing singleton*.
%
%      SONARGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SONARGUI.M with the given input arguments.
%
%      SONARGUI('Property','Value',...) creates a new SONARGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sonargui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sonargui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sonargui

% Last Modified by GUIDE v2.5 09-May-2012 13:33:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
   'gui_Singleton',  gui_Singleton, ...
   'gui_OpeningFcn', @sonargui_OpeningFcn, ...
   'gui_OutputFcn',  @sonargui_OutputFcn, ...
   'gui_LayoutFcn',  [] , ...
   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
   [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
   gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before sonargui is made visible.
function sonargui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sonargui (see VARARGIN)

% Choose default command line output for sonargui
handles.output = hObject;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the initial tripod and instrument geometries
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d2r = pi/180;

%TODO - Make the initial experiment a command-line argument
experiment = 'unh_flat'; %default experiment to start with
switch lower(experiment)
   case 'unh_flat'
      unh_geom
   case 'unh_tilted'
      unh_geom_tilted
   case 'mvco'
      mvco_geom
   case 'FI12'
      FI12_geom
   otherwise
      error(['Bad initial case: ',lower(experiment)])
end
inst = 1;
% I store all of the relevent info in structure held in handles,
% but I also write this stuff out in sonar_output.mat
handles.inst =1;
handles.old_inst=1;
handles.experiment = experiment;
handles.instloc = instloc;
handles.tripod = tripod;
handles.cmpss = cmpss;
plotinfo.az = -37.5;
plotinfo.el = 30;
plotinfo.xrange = '[-2 2]';
plotinfo.yrange = '[-2 2]';
plotinfo.zrange = '[-1 2]';
handles.plotinfo = plotinfo;

% calculate compass heading from ADCP beam 3 Cartesian heading
th = handles.instloc(2).pry(3);
[xa,ya]=pol2cart(th*d2r,1);
[ra,hdg]=pcoord(xa,ya);
str = num2str(hdg);

set(handles.compass_hdg_edit7,'String',str)
str = num2str(handles.instloc(2).pry(1));
set(handles.compass_pitch_edit8,'String',str)
str = num2str(handles.instloc(2).pry(2));
set(handles.compass_roll_edit9,'String',str)
str = num2str(handles.instloc(2).oval)
set(handles.magvar_edit10,'String',str)
save sonar_output.mat inst instloc tripod cmpss

% Update handles structure
guidata(hObject, handles);
save sonar_output.mat inst instloc tripod cmpss
% This sets up the initial plot - only do when we are invisible
% so window can get raised using sonargui.
if strcmp(get(hObject,'Visible'),'off')
   replot(handles);
end

% UIWAIT makes sonargui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sonargui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
replot(handles)


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
   open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
   ['Close ' get(handles.figure1,'Name') '...'],...
   'Yes','No','Yes');
if strcmp(selection,'No')
   return;
end
delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});

% --- Executes on slider movement.
function yaw_slider_Callback(hObject, eventdata, handles)
% hObject    handle to yaw_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
yaw = get(hObject,'Value');
set(handles.edit_yaw,'String',num2str(yaw));
replot(handles)

% --- Executes during object creation, after setting all properties.
function yaw_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yaw_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit_yaw_Callback(hObject, eventdata, handles)
% hObject    handle to edit_yaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_yaw as text
%        str2double(get(hObject,'String')) returns contents of edit_yaw as a double
yaw = str2double(get(hObject,'String'))
set(handles.yaw_slider,'Value',yaw)
replot(handles)

% --- Executes during object creation, after setting all properties.
function edit_yaw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_yaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function pitch_slider_Callback(hObject, eventdata, handles)
% hObject    handle to pitch_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
pitch = get(hObject,'Value');
set(handles.edit_pitch,'String',num2str(pitch));
replot(handles)

% --- Executes during object creation, after setting all properties.
function pitch_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pitch_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function roll_slider_Callback(hObject, eventdata, handles)
% hObject    handle to roll_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
roll = get(hObject,'Value');
set(handles.edit_roll,'String',num2str(roll));
replot(handles)

% --- Executes during object creation, after setting all properties.
function roll_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roll_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function height_slider_Callback(hObject, eventdata, handles)
% hObject    handle to height_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
height = get(hObject,'Value');
set(handles.edit_height,'String',num2str(height));
replot(handles)

% --- Executes during object creation, after setting all properties.
function height_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit_pitch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pitch as text
%        str2double(get(hObject,'String')) returns contents of edit_pitch as a double
pitch = str2double(get(hObject,'String'))
set(handles.pitch_slider,'Value',pitch)
replot(handles)

% --- Executes during object creation, after setting all properties.
function edit_pitch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor','white');
end

function edit_roll_Callback(hObject, eventdata, handles)
% hObject    handle to edit_roll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_roll as text
%        str2double(get(hObject,'String')) returns contents of edit_roll as a double
roll = str2double(get(hObject,'String'))
set(handles.roll_slider,'Value',roll)
replot(handles)

% --- Executes during object creation, after setting all properties.
function edit_roll_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_roll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor','white');
end

function edit_height_Callback(hObject, eventdata, handles)
% hObject    handle to edit_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_height as text
%        str2double(get(hObject,'String')) returns contents of edit_height as a double
height = str2double(get(hObject,'String'))
set(handles.height_slider,'Value',height)
replot(handles)

% --- Executes during object creation, after setting all properties.
function edit_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function easting_slider5_Callback(hObject, eventdata, handles)
% hObject    handle to easting_slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
easting = get(hObject,'Value');
set(handles.easting_edit5,'String',num2str(easting));
replot(handles)

% --- Executes during object creation, after setting all properties.
function easting_slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to easting_slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function easting_edit5_Callback(hObject, eventdata, handles)
% hObject    handle to easting_edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of easting_edit5 as text
%        str2double(get(hObject,'String')) returns contents of easting_edit5 as a double
easting = str2double(get(hObject,'String'))
set(handles.easting_slider5,'Value',easting)
replot(handles)

% --- Executes during object creation, after setting all properties.
function easting_edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to easting_edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function northing_slider6_Callback(hObject, eventdata, handles)
% hObject    handle to northing_slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
northing = get(hObject,'Value');
set(handles.northing_edit6,'String',num2str(northing));
replot(handles)

% --- Executes during object creation, after setting all properties.
function northing_slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to northing_slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function northing_edit6_Callback(hObject, eventdata, handles)
% hObject    handle to northing_edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of northing_edit6 as text
%        str2double(get(hObject,'String')) returns contents of northing_edit6 as a double
northing = str2double(get(hObject,'String'))
set(handles.northing_slider6,'Value',northing)
replot(handles)

% --- Executes during object creation, after setting all properties.
function northing_edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to northing_edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in view_popupmenu3.
function view_popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to view_popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns view_popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from view_popupmenu3
replot(handles)

% --- Executes during object creation, after setting all properties.
function view_popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to view_popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function compass_hdg_edit7_Callback(hObject, eventdata, handles)
% hObject    handle to compass_hdg_edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of compass_hdg_edit7 as text
%        str2double(get(hObject,'String')) returns contents of compass_hdg_edit7 as a double
use_compass = get(handles.usecompass_radiobutton8,'Value')
if(use_compass),
replot(handles)
end

% --- Executes during object creation, after setting all properties.
function compass_hdg_edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compass_hdg_edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function compass_pitch_edit8_Callback(hObject, eventdata, handles)
% hObject    handle to compass_pitch_edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of compass_pitch_edit8 as text
%        str2double(get(hObject,'String')) returns contents of compass_pitch_edit8 as a double
use_compass = get(handles.usecompass_radiobutton8,'Value')
if(use_compass)
replot(handles)
end

% --- Executes during object creation, after setting all properties.
function compass_pitch_edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compass_pitch_edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function instrument_popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to instrument_popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tripod_radiobutton2.
function tripod_radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to tripod_radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tripod_radiobutton2
replot( handles )

% --- Executes on button press in adcp_radiobutton3.
function adcp_radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to adcp_radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of adcp_radiobutton3
replot( handles )

% --- Executes on button press in fanbeam_radiobutton4.
function fanbeam_radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to fanbeam_radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fanbeam_radiobutton4
replot( handles )

% --- Executes on button press in azdrive_radiobutton5.
function azdrive_radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to azdrive_radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of azdrive_radiobutton5
replot (handles )

% --- Executes on button press in save_pushbutton4.
function save_pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inst = handles.inst;
tripod = handles.tripod;
instloc = handles.instloc;
cmpss = handles.cmpss;
save sonar_output.mat inst instloc tripod cmpss

% --- Executes on selection change in azdata_popupmenu5.
function azdata_popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to azdata_popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns azdata_popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from azdata_popupmenu5
replot( handles )

% --- Executes during object creation, after setting all properties.
function azdata_popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to azdata_popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in showfloor_radiobutton7.
function showfloor_radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to showfloor_radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showfloor_radiobutton7
replot( handles )

function compass_roll_edit9_Callback(hObject, eventdata, handles)
% hObject    handle to compass_roll_edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of compass_roll_edit9 as text
%        str2double(get(hObject,'String')) returns contents of compass_roll_edit9 as a double
use_compass = get(handles.usecompass_radiobutton8,'Value')
if(use_compass),
replot(handles)
end

% --- Executes during object creation, after setting all properties.
function compass_roll_edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compass_roll_edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function magvar_edit10_Callback(hObject, eventdata, handles)
% hObject    handle to magvar_edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of magvar_edit10 as text
%        str2double(get(hObject,'String')) returns contents of magvar_edit10 as a double
use_compass = get(handles.usecompass_radiobutton8,'Value')
if(use_compass),
replot(handles)
end

% --- Executes during object creation, after setting all properties.
function magvar_edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to magvar_edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function datetime_edit11_Callback(hObject, eventdata, handles)
% hObject    handle to datetime_edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of datetime_edit11 as text
%        str2double(get(hObject,'String')) returns contents of datetime_edit11 as a double

% --- Executes during object creation, after setting all properties.
function datetime_edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datetime_edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in usecompass_radiobutton8.
function usecompass_radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to usecompass_radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of usecompass_radiobutton8
replot( handles )


% --- Executes on selection change in experiment_popupmenu6.
function experiment_popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to experiment_popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns experiment_popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from experiment_popupmenu6
experiment = get(handles.experiment_popupmenu6,'Value');
switch experiment
   case 1
      unh_geom
   case 2
      mvco_geom
   case 3
      hatt09_geom             % this doesn't exist now
   case 4
      FI12_geom
end
handles.tripod = tripod;
handles.instloc = instloc;
inst = 1;
handles.inst = 1;
handles.old_inst = 1;
save sonar_output.mat inst instloc tripod cmpss
replot (handles )

% --- Executes during object creation, after setting all properties.
function experiment_popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to experiment_popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tindex_edit12_Callback(hObject, eventdata, handles)
% hObject    handle to tindex_edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tindex_edit12 as text
%        str2double(get(hObject,'String')) returns contents of tindex_edit12 as a double
replot(handles)

% --- Executes during object creation, after setting all properties.
function tindex_edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tindex_edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in instrument_popupmenu4.
function instrument_popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to instrument_popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns instrument_popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from instrument_popupmenu4
load sonar_output.mat
old_inst = inst;
inst = get(hObject,'Value');
save sonar_output.mat inst instloc tripod cmpss

handles.inst = inst;
set(handles.instrument_popupmenu4,'Value',inst);
set(handles.pitch_slider,'Value',handles.instloc(inst).pry(1));
set(handles.edit_pitch,'String',num2str(handles.instloc(inst).pry(1)));
set(handles.roll_slider,'Value',handles.instloc(inst).pry(2));
set(handles.edit_roll,'String',num2str(handles.instloc(inst).pry(2)));
set(handles.yaw_slider,'Value',handles.instloc(inst).pry(3));
set(handles.edit_yaw,'String',num2str(handles.instloc(inst).pry(3)));

set(handles.easting_slider5,'Value',handles.instloc(inst).xyz(1));
set(handles.easting_edit5,'String',num2str(handles.instloc(inst).xyz(1)));
set(handles.northing_slider6,'Value',handles.instloc(inst).xyz(2));
set(handles.northing_edit6,'String',num2str(handles.instloc(inst).xyz(2)));
set(handles.height_slider,'Value',handles.instloc(inst).xyz(3));
set(handles.edit_height,'String',num2str(handles.instloc(inst).xyz(3)));
guidata(hObject,handles); % Store the changes.
replot( handles )

% --- Executes on button press in reset_pushbutton5.
function reset_pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to reset_pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This re-reads in the geometry file and resets the numbers
% TODO - This routine is outdated and might not do what it should
experiment = get(handles.experiment_popupmenu6,'Value');
switch experiment
   case 1
      unh_geom
   case 2
      mvco_geom
  case 3
      hatt09_geom             % this doesn't exist now
   case 4
      FI12_geom
end
handles.tripod = tripod;
handles.instloc = instloc;
inst = 1;
handles.inst = 1;
handles.old_inst = 1;
save sonar_output.mat inst instloc tripod cmpss
replot (handles )


function replot( handles )
% Main routine for updating image
% radian - degree conversions
d2r = pi/180.;
r2d = 1/d2r;

load sonar_output.mat

% Grab values from sliders and edit windows
instloc(inst).xyz(1) = get(handles.easting_slider5,'Value');  % Height of transducer
instloc(inst).xyz(2) = get(handles.northing_slider6,'Value');
instloc(inst).xyz(3) = get(handles.height_slider,'Value');
instloc(inst).pry(1) = get(handles.pitch_slider,'Value');
instloc(inst).pry(2) = get(handles.roll_slider,'Value');
instloc(inst).pry(3) = get(handles.yaw_slider,'Value');
% Find out which instrument we are controlling
handles.instloc = instloc;

view_choice = get(handles.view_popupmenu3,'Value');
plot_tripod = get(handles.tripod_radiobutton2,'Value');
plot_adcp = get(handles.adcp_radiobutton3,'Value');
plot_fan = get(handles.fanbeam_radiobutton4,'Value');
plot_az = get(handles.azdrive_radiobutton5,'Value');
azdata_choice = get(handles.azdata_popupmenu5,'Value');
plot_floor = get(handles.showfloor_radiobutton7,'Value');
use_compass = get(handles.usecompass_radiobutton8,'Value');
if(use_compass)
   % get compass readings and subtract initial values (assumes they
   % represent compass readings when tripod was level and initial heading 
   % was relative to aligned with tripod = lab coords north)
   cpitch = str2num(get(handles.compass_pitch_edit8,'String'));
   croll = str2num(get(handles.compass_roll_edit9,'String'));
   chdg = str2num(get(handles.compass_hdg_edit7,'String')); % geographic
   crot = str2num(get(handles.magvar_edit10,'String'));
   % correct for mag and convert to cartesian angle in degrees
   [xa,ya]=xycoord(1,chdg+crot)
   [th,ra]=cart2pol(xa,ya);
   th=th*r2d
   cpry = [cpitch croll th]-instloc(2).pry;
   % apply this to the tripod
   handles.instloc(1).pry = cpry;
end
save sonar_output.mat inst instloc tripod cmpss
switch view_choice
   case 1 % perspective
      az = -37.5; el = 30;
   case 2 % from above (yaw)
      az = 0; el = 90;
   case 3 % down x axis (pitch)
      az = 90; el = 0;
   case 4 % down y axis (roll)
      az = 0; el = 0;
   otherwise
      az = -37.5; el = 30;
end      


cla
if(plot_floor)
   % gray floor with cross at origin
   v = [2 2 0; -2 2 0; -2 -2 0; 2 -2 0];
   f = [1 2 3 4];
   p=patch('Vertices',v,'Faces',f);
   set(p,'facecolor',[.5 .5 .5],'edgecolor','none','facealpha',.4);
end
hold on
h=line([0;0],[-.08;+.08],[0;0]);
set(h,'linestyle','-','color',[0 0 0])
h=line([-.08;+.08],[0;0],[0;0]);
set(h,'linestyle','-','color',[0 0 0])

if(azdata_choice~=1)
   plot_azdata(handles); hold on
end
if(plot_fan)
   fancan3(handles); hold on % can draws the sonar
end
if(plot_az)
   azcan3(handles); hold on
end
if(plot_adcp)
   adcpcan3(handles); hold on
end
if(plot_tripod)
   trican3(handles); hold on
end
hold on
axis([-2 2 -2 2 -1 2])
view(az,el)
grid on
xlabel('x')
ylabel('y')
zlabel('z')
hold off



function plot_x_axis_edit13_Callback(hObject, eventdata, handles)
% hObject    handle to plot_x_axis_edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plot_x_axis_edit13 as text
%        str2double(get(hObject,'String')) returns contents of plot_x_axis_edit13 as a double


% --- Executes during object creation, after setting all properties.
function plot_x_axis_edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_x_axis_edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plot_y_axis_edit14_Callback(hObject, eventdata, handles)
% hObject    handle to plot_y_axis_edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plot_y_axis_edit14 as text
%        str2double(get(hObject,'String')) returns contents of plot_y_axis_edit14 as a double


% --- Executes during object creation, after setting all properties.
function plot_y_axis_edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_y_axis_edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plot_z_axis_edit15_Callback(hObject, eventdata, handles)
% hObject    handle to plot_z_axis_edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plot_z_axis_edit15 as text
%        str2double(get(hObject,'String')) returns contents of plot_z_axis_edit15 as a double


% --- Executes during object creation, after setting all properties.
function plot_z_axis_edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_z_axis_edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
