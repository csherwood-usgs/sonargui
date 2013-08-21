function varargout = sonargui_nsl_inp(varargin)
% SONARGUI_NSL_INP MATLAB code for sonargui_nsl_inp.fig
%      SONARGUI_NSL_INP, by itself, creates a new SONARGUI_NSL_INP or raises the existing
%      singleton*.
%
%      H = SONARGUI_NSL_INP returns the handle to a new SONARGUI_NSL_INP or the handle to
%      the existing singleton*.
%
%      SONARGUI_NSL_INP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SONARGUI_NSL_INP.M with the given input arguments.
%
%      SONARGUI_NSL_INP('Property','Value',...) creates a new SONARGUI_NSL_INP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sonargui_nsl_inp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sonargui_nsl_inp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%      these need to be on the path for the program to find the functions
%       $MTLSVNPATH\m_contrib\trunk\gridfitdir
%       $MTLSVNPATH\m_cmg\trunk\sonarlib\unh_1209\prygui
%       $MTLSVNPATH\m_cmg\trunk\sonarlib\unh_1209
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sonargui_nsl_inp

% Last Modified by GUIDE v2.5 16-Nov-2012 08:48:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
   'gui_Singleton',  gui_Singleton, ...
   'gui_OpeningFcn', @sonargui_nsl_inp_OpeningFcn, ...
   'gui_OutputFcn',  @sonargui_nsl_inp_OutputFcn, ...
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

% --- Executes just before sonargui_nsl_inp is made visible.
function sonargui_nsl_inp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sonargui_nsl_inp (see VARARGIN)
%    in ths program varargin collects the info from 3 arguments
%    path_names, experiment_names, and the geometry file to execute
%    these must be cell arrays, with 1 element for each experiment to
%    display in the experiment gui.  See sonargui_inputs.m.

% Choose default command line output for sonargui_nsl_inp
handles.output = hObject;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the initial tripod and instrument geometries
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d2r = pi/180;

%TODO - Make the initial experiment a command-line argument
% this only does UNH since experiment cannot be changed here (until it's
% passed in to the function
% is will always start-up with unh tank
if (isempty(varargin))
    experiment='UNH tank'
    set(handles.experiment_popupmenu6,'String',experiment);
    unh_geom
    fnames=dir;
else
    %The argument here must be a cell array of strings
    set(handles.experiment_popupmenu6,'String',varargin{2});
    handles.fcns=varargin{3};
    handles.expnames=varargin{2};
    handles.dpath=varargin{1};
     eval(char(handles.fcns(1))) % run unh_geom to get instloc, tripod
     fnames=dir(char(handles.dpath(1)));
     experiment=handles.expnames(1);
end
% use the fnames to make a list of azimuth files to display
    cellnames={fnames.name};  % put all the names in a cell array
    locs=strfind(cellnames,'.cdf'); %find the ones with cdf
    isntcdf=cellfun(@isempty,locs);   %the notCDFs will be []
    iscdf=find(isntcdf==0);           % get the indices
    cdflist=cellnames(iscdf);
    azlist=[{'none'} cdflist];

% this all can happen regardless of if there's a varargin
inst = 1;    % start with the tripod as the focus
%  store all of the relevent info in structure held in handles,
handles.inst =inst;
handles.old_inst=1;
handles.experiment = experiment;
handles.expname=experiment;
handles.instloc = instloc;  % comes from geom file
handles.tripod = tripod;  % comes from geom file
handles.cmpss = cmpss;  % comes from geom file
% get values from the instrument popup and save
instvals=get(handles.instrument_popupmenu4,'String');
handles.instval=instvals;
% set the default view to perspective
plotinfo.az = -37.5;
plotinfo.el = 30;
% even though the boxes exist, there ate no callbacks for the axes (yet)
% so have to modify them here.
plotinfo.xrange = '[-2 2]';
plotinfo.yrange = '[-2 2]';
plotinfo.zrange = '[-1 2]';
set(handles.plot_x_axis_edit13,'String',plotinfo.xrange);
set(handles.plot_y_axis_edit14,'String',plotinfo.yrange);
set(handles.plot_z_axis_edit15,'String',plotinfo.zrange);
handles.plotinfo = plotinfo;
%handles.path = 'default path';

%Put values into the sliders at top left
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

% % calculate compass heading from ADCP beam 3 Cartesian heading
% th = handles.instloc(2).pry(3);
% [xa,ya]=pol2cart(th*d2r,1);
% [ra,hdg]=pcoord(xa,ya);
% % maybe don't populate at startup, as that data should come from the ADCP data
% %   write into the boxes under "use this compass" button
% str = num2str(hdg);
str = num2str(handles.cmpss.pry(3));
set(handles.compass_hdg_edit7,'String',str)
str = num2str(handles.cmpss.pry(1));
set(handles.compass_pitch_edit8,'String',str)
str = num2str(handles.cmpss.pry(2));
set(handles.compass_roll_edit9,'String',str)
str = num2str(handles.instloc(2).oval);
set(handles.magvar_edit10,'String',str)
set(handles.azdata_popupmenu5,'String',azlist);
% Update handles structure
guidata(hObject, handles);
%save sonar_output.mat inst instloc tripod cmpss plotinfo
%save sonar_output.mat inst instloc tripod cmpss plotinfo
% This sets up the initial plot - only do when we are invisible
% so window can get raised using sonargui_nsl_inp.
if strcmp(get(hObject,'Visible'),'off')
   replot(handles);
end

% UIWAIT makes sonargui_nsl_inp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sonargui_nsl_inp_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% etm- I think these are all for initial configuration
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
replot(handles)
% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
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
% end of set-up stuff that may or may not be functional

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create functions- made in guide as CRS added features
% order here is more or less from left across the top, then down the
% right side, in order of appeance.  The figure sub-window is axes2, and
% doesn't seem to be manipulated in this code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% --- Executes during object creation, after setting all properties.
function yaw_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yaw_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

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

% --- Executes during object creation, after setting all properties.
function pitch_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pitch_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor',[.9 .9 .9]);
end

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

% --- Executes during object creation, after setting all properties.
function roll_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roll_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor',[.9 .9 .9]);
end

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

% --- Executes during object creation, after setting all properties.
function height_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor',[.9 .9 .9]);
end

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

% --- Executes during object creation, after setting all properties.
function easting_slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to easting_slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

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

% --- Executes during object creation, after setting all properties.
function northing_slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to northing_slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

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
function compass_roll_edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compass_roll_edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% callback functions
% order here is more or less from left across the top, then down the
% right side, in order of appeance.  The figure sub-window is axes2, and
% doesn't seem to be manipulated in this code

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in instrument_popupmenu4.
% this is what happens when you select tripod, adcp, fan or az at top left
function instrument_popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to instrument_popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns instrument_popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from instrument_popupmenu4
%
% check whether generated by click on instrument_popupmenu4 or from
% experiment_popupmenu6.  When changing experiments we want to display the
% tripod orientation for THAT tripod, but if it's really wanting to change
% the instrument focus, use the value from this popup
set(handles.instrument_popupmenu4,'String',handles.instval);
where_from=gcbo;
if ((where_from == handles.experiment_popupmenu6) | (where_from == handles.reset_pushbutton5))
   inst=handles.inst;
else
   inst=get(handles.instrument_popupmenu4,'Value');
end
set(handles.instrument_popupmenu4,'String',handles.instval);
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
handles.inst=inst;
idx=get(handles.experiment_popupmenu6,'Value');
handles.path=handles.dpath(idx);
guidata(hObject,handles); % Store the changes.
replot( handles )

% --- Executes on slider movement.
function yaw_slider_Callback(hObject, eventdata, handles)
% hObject    handle to yaw_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
yaw = get(hObject,'Value');
set(handles.edit_yaw,'String',num2str(yaw));
handles.instloc(handles.inst).pry(3)=yaw;
guidata(hObject,handles);
replot(handles)

% --- Executes on slider movement.
function pitch_slider_Callback(hObject, eventdata, handles)
% hObject    handle to pitch_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
pitch = get(hObject,'Value');
set(handles.edit_pitch,'String',num2str(pitch));
handles.instloc(handles.inst).pry(1)=pitch;
guidata(hObject,handles);
replot(handles)

% --- Executes on slider movement.
function roll_slider_Callback(hObject, eventdata, handles)
% hObject    handle to roll_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
roll = get(hObject,'Value');
set(handles.edit_roll,'String',num2str(roll));
handles.instloc(handles.inst).pry(2)=roll;
guidata(hObject,handles);
replot(handles)

function edit_yaw_Callback(hObject, eventdata, handles)
% hObject    handle to edit_yaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_yaw as text
%        str2double(get(hObject,'String')) returns contents of edit_yaw as a double
yaw = str2double(get(hObject,'String'))
set(handles.yaw_slider,'Value',yaw)
handles.instloc(handles.inst).pry(3)=yaw;
guidata(hObject,handles);
replot(handles)

function edit_pitch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pitch as text
%        str2double(get(hObject,'String')) returns contents of edit_pitch as a double
pitch = str2double(get(hObject,'String'))
set(handles.pitch_slider,'Value',pitch)
handles.instloc(handles.inst).pry(1)=pitch;
guidata(hObject,handles);
replot(handles)

function edit_roll_Callback(hObject, eventdata, handles)
% hObject    handle to edit_roll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_roll as text
%        str2double(get(hObject,'String')) returns contents of edit_roll as a double
roll = str2double(get(hObject,'String'))
set(handles.roll_slider,'Value',roll)
handles.instloc(handles.inst).pry(2)=roll;
guidata(hObject,handles);
replot(handles)

% --- Executes on slider movement.
function height_slider_Callback(hObject, eventdata, handles)
% hObject    handle to height_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
height = get(hObject,'Value');
set(handles.edit_height,'String',num2str(height));
handles.instloc(handles.inst).xyz(2)=height;
guidata(hObject,handles);
replot(handles)

function edit_height_Callback(hObject, eventdata, handles)
% hObject    handle to edit_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_height as text
%        str2double(get(hObject,'String')) returns contents of edit_height as a double
height = str2double(get(hObject,'String'))
set(handles.height_slider,'Value',height)
handles.instloc(handles.inst).xyz(2)=height;
guidata(hObject,handles);
replot(handles)

% --- Executes on slider movement.
function easting_slider5_Callback(hObject, eventdata, handles)
% hObject    handle to easting_slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
easting = get(hObject,'Value');
set(handles.easting_edit5,'String',num2str(easting));
handles.instloc(handles.inst).xyz(1)=easting;
guidata(hObject,handles);
replot(handles)

function easting_edit5_Callback(hObject, eventdata, handles)
% hObject    handle to easting_edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of easting_edit5 as text
%        str2double(get(hObject,'String')) returns contents of easting_edit5 as a double
easting = str2double(get(hObject,'String'))
set(handles.easting_slider5,'Value',easting)
handles.instloc(handles.inst).xyz(1)=easting;
guidata(hObject,handles);
replot(handles)

% --- Executes on slider movement.
function northing_slider6_Callback(hObject, eventdata, handles)
% hObject    handle to northing_slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
northing = get(hObject,'Value');
set(handles.northing_edit6,'String',num2str(northing));
handles.instloc(handles.inst).xyz(2)=northing;
guidata(hObject,handles);
replot(handles)

function northing_edit6_Callback(hObject, eventdata, handles)
% hObject    handle to northing_edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of northing_edit6 as text
%        str2double(get(hObject,'String')) returns contents of northing_edit6 as a double
northing = str2double(get(hObject,'String'))
set(handles.northing_slider6,'Value',northing)
handles.instloc(handles.inst).xyz(2)=northing;
guidata(hObject,handles);
replot(handles)

% --- Executes on selection change in experiment_popupmenu6.
% this is where you land when you choose an experiment
function experiment_popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to experiment_popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns experiment_popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from experiment_popupmenu6
idx = get(handles.experiment_popupmenu6,'Value');
     eval(char(handles.fcns(idx))) % run *_geom to get instloc, tripod
     fnames=dir(char(handles.dpath(idx)));
     experiment=handles.expnames(idx);
% use the fnames to make a list of azimuth files to display
    cellnames={fnames.name};  % put all the names in a cell array
    locs=strfind(cellnames,'.cdf'); %find the ones with cdf
    isntcdf=cellfun(@isempty,locs);   %the notCDFs will be []
    iscdf=find(isntcdf==0);           % get the indices
    cdflist=cellnames(iscdf);
    azlist=[{'none'} cdflist];
set(handles.azdata_popupmenu5,'String',azlist);
set(handles.azdata_popupmenu5,'Value',1);

handles.tripod = tripod;
handles.instloc = instloc;
handles.experiment=idx;
handles.experiment=experiment;
handles.cmpss=cmpss;
% calculate compass heading from ADCP beam 3 Cartesian heading
% th = handles.instloc(2).pry(3);
% [xa,ya]=pol2cart(th*d2r,1);
% [ra,hdg]=pcoord(xa,ya);
% % maybe don't populate at startup, as that data should come from the ADCP data
% %   write into the boxes under "use this compass" button
% str = num2str(hdg);
str = num2str(handles.cmpss.pry(3));
set(handles.compass_hdg_edit7,'String',str)
str = num2str(handles.cmpss.pry(1));
set(handles.compass_pitch_edit8,'String',str)
str = num2str(handles.cmpss.pry(2));
set(handles.compass_roll_edit9,'String',str)
str = num2str(handles.instloc(2).oval);
set(handles.magvar_edit10,'String',str)
set(handles.azdata_popupmenu5,'String',azlist);

plotinfo=handles.plotinfo;
% when changing experiments we want to go back to the tripod view
 inst = 1;      %it is tripod view when inst = 1
 handles.inst = 1;
 handles.old_inst = 1;
%save sonar_output.mat inst instloc tripod cmpss plotinfo
guidata(hObject,handles); % Store the changes.
% set the sliders to correct for this experiment
instrument_popupmenu4_Callback(hObject, eventdata, handles)

replot (handles )

% --- Executes on selection change in azdata_popupmenu5.
function azdata_popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to azdata_popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns azdata_popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from azdata_popupmenu5
idx = get(handles.experiment_popupmenu6,'Value');
handles.path=handles.dpath(idx);
guidata(hObject,handles);
replot( handles )


function tindex_edit12_Callback(hObject, eventdata, handles)
% hObject    handle to tindex_edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tindex_edit12 as text
%        str2double(get(hObject,'String')) returns contents of tindex_edit12 as a double
replot(handles)

% --- Executes on button press in usecompass_radiobutton8.
function usecompass_radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to usecompass_radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of usecompass_radiobutton8
replot( handles )

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

% --- Executes on button press in showfloor_radiobutton7.
function showfloor_radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to showfloor_radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showfloor_radiobutton7
replot( handles )

% --- Executes on selection change of viewpoint/perspective in view_popupmenu3.
function view_popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to view_popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns view_popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from view_popupmenu3
replot(handles)

% --- Executes on button press in reset_pushbutton5.
function reset_pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to reset_pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This re-reads in the geometry file and resets the numbers
% TODO - This routine is outdated and might not do what it should
idx = get(handles.experiment_popupmenu6,'Value');
set(handles.experiment_popupmenu6,'String',handles.expnames);
     eval(char(handles.fcns(idx))) % run *_geom to get instloc, tripod
     fnames=dir(char(handles.dpath(idx)));
     experiment=handles.expnames(idx);
% use the fnames to make a list of azimuth files to display
    cellnames={fnames.name};  % put all the names in a cell array
    locs=strfind(cellnames,'.cdf'); %find the ones with cdf
    isntcdf=cellfun(@isempty,locs);   %the notCDFs will be []
    iscdf=find(isntcdf==0);           % get the indices
    cdflist=cellnames(iscdf);
    azlist=[{'none'} cdflist];
set(handles.azdata_popupmenu5,'String',azlist);
set(handles.azdata_popupmenu5,'Value',1);

% from the _geom file run above
handles.tripod = tripod;
handles.instloc = instloc;
handles.experiment=idx;
handles.experiment=experiment;

% when resetting we want to go back to the tripod view
 inst = 1;      %it is tripod view when inst = 1
 %reset all the sliders to what goes with that tripod
handles.inst = 1;
instrument_popupmenu4_Callback(hObject, eventdata, handles);
handles.old_inst = 1;
%save sonar_output.mat inst instloc tripod cmpss plotinfo
guidata(hObject,handles); % Store the changes
replot (handles )


% --- Executes on button press in save_pushbutton4.
function save_pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% inst = handles.inst;
% tripod = handles.tripod;
% instloc = handles.instloc;
% cmpss = handles.cmpss;
% plotinfo= handles.plotinfo;
% save sonar_nsl_output.mat inst instloc tripod cmpss plotinfo
guidata(hObject,handles)
hand_save=guidata(hObject);
save sonar_nsl_output.mat hand_save


% --- Executes on button press in load_pushbutton6.
function load_pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to load_pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
load sonar_nsl_output  % gets hand_save from storage
% this should reset the figure to how it was when last saved.
%guidata(hand_save);

idx=get(hand_save.instrument_popupmenu4,'Value');
set(handles.instrument_popupmenu4,'Value',idx);
set(handles.pitch_slider,'Value',get(hand_save.pitch_slider,'Value'));
set(handles.edit_pitch,'String',get(hand_save.edit_pitch,'String'));
set(handles.roll_slider,'Value',get(hand_save.roll_slider,'Value'));
set(handles.edit_roll,'String',get(hand_save.edit_roll,'String'));
set(handles.yaw_slider,'Value',get(hand_save.yaw_slider,'Value'));
set(handles.edit_yaw,'String',get(hand_save.edit_yaw,'String'));

set(handles.easting_slider5,'Value',get(hand_save.easting_slider5,'Value'));
set(handles.easting_edit5,'String',get(hand_save.easting_edit5,'String'));
set(handles.northing_slider6,'Value',get(hand_save.northing_slider6,'Value'));
set(handles.northing_edit6,'String',get(hand_save.northing_edit6,'String'));
set(handles.height_slider,'Value',get(handles.height_slider,'Value'));
set(handles.edit_height,'String',get(hand_save.edit_height,'String'));

plot_x_axis_edit13_Callback(hObject, eventdata, hand_save);
plot_y_axis_edit14_Callback(hObject, eventdata, hand_save);
plot_z_axis_edit15_Callback(hObject, eventdata, hand_save);
azdata_popupmenu5_Callback(hObject, eventdata, hand_save);
experiment_popupmenu6_Callback(hObject, eventdata, hand_save);
set(handles.experiment_popupmenu6,'String',hand_save.experiment);
replot(handles)

function datetime_edit11_Callback(hObject, eventdata, handles)
% hObject    handle to datetime_edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of datetime_edit11 as text
%        str2double(get(hObject,'String')) returns contents of datetime_edit11 as a double

function plot_x_axis_edit13_Callback(hObject, eventdata, handles)
% hObject    handle to plot_x_axis_edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plot_x_axis_edit13 as text
%        str2double(get(hObject,'String')) returns contents of plot_x_axis_edit13 as a double
handles.plotinfo.xrange=get(handles.plot_x_axis_edit13,'String')
 eval(['set(gca,''xlim'',' handles.plotinfo.xrange ')'])
 guidata(hObject,handles);
 
 
function plot_y_axis_edit14_Callback(hObject, eventdata, handles)
% hObject    handle to plot_y_axis_edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of plot_y_axis_edit14 as text
%        str2double(get(hObject,'String')) returns contents of plot_y_axis_edit14 as a double
handles.plotinfo.yrange=get(handles.plot_y_axis_edit14,'String')
 eval(['set(gca,''ylim'',' handles.plotinfo.yrange ')'])
 guidata(hObject,handles);
 
%set (gca'ylim',newY);

function plot_z_axis_edit15_Callback(hObject, eventdata, handles)
% hObject    handle to plot_z_axis_edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of plot_z_axis_edit15 as text
%        str2double(get(hObject,'String')) returns contents of plot_z_axis_edit15 as a double
handles.plotinfo.zrange=get(handles.plot_z_axis_edit15,'String')
 eval(['set(gca,''zlim'',' handles.plotinfo.zrange ')'])
 guidata(hObject,handles);
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% here's the operational BEEF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% it does this for virtually every call back, so be sure to get this right!
function replot( handles )
% Main routine for updating image
% radian - degree conversions
d2r = pi/180.;
r2d = 1/d2r;

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
   [xa,ya]=xycoord(1,chdg+crot);
   [th,ra]=cart2pol(xa,ya);
   th=th*r2d;
   cpry = [cpitch croll th]-handles.instloc(2).pry;  %subtracts adcp pry vals
   %cpry = [cpitch croll th]-instloc(2).pry;  %subtracts adcp pry vals
   % apply this to the tripod
   handles.instloc(1).pry = cpry;
   %guidata(hObject,handles); % Store the changes.
end
%save sonar_output.mat inst instloc tripod cmpss plotinfo
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
  % plot_azdata2(handles); hold on
  plot_azdata2Native(handles); hold on
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
% this shouldn't be hard wired should come from the GUI axis limits
%axis([-3 3 -3 3 -1 2])
xlims=str2num(get(handles.plot_x_axis_edit13,'String'));
ylims=str2num(get(handles.plot_y_axis_edit14,'String'));
zlims=str2num(get(handles.plot_z_axis_edit15,'String'));
axis([xlims(1) xlims(2) ylims(1) ylims(2) zlims(1) zlims(2)])
view(az,el)
grid on
xlabel('x')
ylabel('y')
zlabel('z')
hold off



