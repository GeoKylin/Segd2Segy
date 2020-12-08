function varargout = segd2segy(varargin)
% SEGD2SEGY MATLAB code for segd2segy.fig
%      SEGD2SEGY, by itself, creates a new SEGD2SEGY or raises the existing
%      singleton*.
%
%      H = SEGD2SEGY returns the handle to a new SEGD2SEGY or the handle to
%      the existing singleton*.
%
%      SEGD2SEGY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGD2SEGY.M with the given input arguments.
%
%      SEGD2SEGY('Property','Value',...) creates a new SEGD2SEGY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segd2segy_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segd2segy_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segd2segy

% Last Modified by GUIDE v2.5 07-Dec-2020 20:17:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segd2segy_OpeningFcn, ...
                   'gui_OutputFcn',  @segd2segy_OutputFcn, ...
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


% --- Executes just before segd2segy is made visible.
function segd2segy_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segd2segy (see VARARGIN)

% Choose default command line output for segd2segy
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes segd2segy wait for user response (see UIRESUME)
% uiwait(handles.figure1);
evalin('base','clear; clc;')
addpath(genpath(pwd));

% --- Outputs from this function are returned to the command line.
function varargout = segd2segy_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_choose.
function button_choose_Callback(hObject, eventdata, handles)
% hObject    handle to button_choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base','clear; clc;')
set_status(handles, 'Converting ...');

[filenames,pathname] = uigetfile({'*.sgd;*.segd;*.SGD;*.SEGD',...
        'SEG-D Files (*.sgd,*.segd,*.SGD,*.SEGD)'; ...
        '*.*','All Files (*.*)'},'Choose SEGD Files', 'MultiSelect', 'on');

if isequal(class(filenames),'char')
    filenames = cellstr(filenames);
end

if ~isequal(filenames,0)
    if get(handles.select_traces,'value')
        b = get(handles.edit_begin,'string');
        e = get(handles.edit_end,'string');
        if isempty(b)
            set_status(handles, 'Error, no begin trace!');
        elseif isempty(e)
            set_status(handles, 'Error, no end trace!');
        else
            traces = [str2double(b), str2double(e)];
            convert_segd(handles, traces, filenames, pathname);
        end
    else
        convert_segd(handles, [], filenames, pathname);
    end
else
    set_status(handles, 'No SEGD file chosen!');
end


% --- Executes on button press in select_traces.
function select_traces_Callback(hObject, eventdata, handles)
% hObject    handle to select_traces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of select_traces
if get(handles.select_traces,'value')
    set(handles.select_auxiliary,'value',0);
    set(handles.edit_begin,'enable','on');
    set(handles.edit_end,'enable','on');
else
    set(handles.edit_begin,'enable','off');
    set(handles.edit_end,'enable','off');
end


function edit_begin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_begin as text
%        str2double(get(hObject,'String')) returns contents of edit_begin as a double


% --- Executes during object creation, after setting all properties.
function edit_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_end_Callback(hObject, eventdata, handles)
% hObject    handle to edit_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_end as text
%        str2double(get(hObject,'String')) returns contents of edit_end as a double


% --- Executes during object creation, after setting all properties.
function edit_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_about.
function button_about_Callback(hObject, eventdata, handles)
% hObject    handle to button_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msg = {'SEGD to SEGY converter',...
       'Version: 1.0',...
       'Developed by: Wang Kai',...
       'Institute of Geology and Geophysics',...
       'Chinese Academy of Sciences',...
       'Email: wangkai185@mails.ucas.ac.cn',...
       'Latest modified: 2020/12/07'};
msgbox(msg, 'About');


% --- Executes on button press in select_auxiliary.
function select_auxiliary_Callback(hObject, eventdata, handles)
% hObject    handle to select_auxiliary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of select_auxiliary
if get(handles.select_auxiliary,'value')
    set(handles.select_traces,'value',0);
    set(handles.edit_begin,'enable','off');
    set(handles.edit_end,'enable','off');
end


function set_status(handles, status)
set(handles.text_status,'string',['Status: ',status]);


function convert_segd(handles, traces, filenames, pathname)
for f=1:length(filenames)
    file = fullfile(pathname, filenames{f});
    disp(['==> Read ',file])

    if get(handles.select_traces,'value')
        [data, t] = segd_read(file, 'traces', traces);
    else
        [data, t] = segd_read(file);
    end
    
    if get(handles.select_auxiliary,'value')
        data = data(:,2:end);
    end
    
    dt = t(2);
    ns = length(t);
    numtraces = size(data,2);

    SEGD = File(file,'permission','r','machineformat','ieee-be');
    dth = Headers(SEGD.fid,'demuxTraceHeader');
    filenum = getHeaderValue(dth,'fileNumber').toNumber();
    
    fileout = split(file, '.');
    fileout = [fileout{1}, '_f1.r', num2str(filenum), '.sgy'];

    disp(['==> Convert ', file, ' to ', fileout, ' ...']);
    disp(' ');

    if get(handles.select_traces,'value')
        tr = traces(1):1:traces(2);
    elseif get(handles.select_auxiliary,'value')
        tr = 2:1:numtraces+1;
    else
        tr = 1:1:numtraces;
    end
    
    traceheader = zeros(120, numtraces); %one row = 2 byte
    traceheader(2,:) = tr; %4 byte, double row
    traceheader(4,:) = 1:1:numtraces; %4 byte, double row
    traceheader(6,:) = filenum * ones(1,numtraces); %4 byte, double row
    traceheader(8,:) = tr; %4 byte, double row
    traceheader(15,:) = ones(1,numtraces); %2 byte, single row
    traceheader(58,:) = ns * ones(1,numtraces); %2 byte, single row
    traceheader(59,:) = dt *1e6 * ones(1,numtraces); %2 byte, single row

    altwritesegy(fileout, data, dt, ns, numtraces, [], [], [], [], traceheader);
end
set_status(handles, 'Finished');
