function varargout = emdtracker(varargin)
% EMDTRACKER M-file for emdtracker.fig
%      EMDTRACKER, by itself, creates a new EMDTRACKER or raises the existing
%      singleton*.
%
%      H = EMDTRACKER returns the handle to a new EMDTRACKER or the handle to
%      the existing singleton*.
%
%      EMDTRACKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EMDTRACKER.M with the given input arguments.
%
%      EMDTRACKER('Property','Value',...) creates a new EMDTRACKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before emdtracker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to emdtracker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help emdtracker

% Last Modified by GUIDE v2.5 08-Jun-2010 00:49:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @emdtracker_OpeningFcn, ...
                   'gui_OutputFcn',  @emdtracker_OutputFcn, ...
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


% --- Executes just before emdtracker is made visible.
function emdtracker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to emdtracker (see VARARGIN)

% Choose default command line output for emdtracker
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes emdtracker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = emdtracker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on Choose Tracking Target
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file_input = get(handles.inputFile,'String');
dir_input = get(handles.inputDir,'String');
back_input = get(handles.backInputFile,'String');
box_width = get(handles.boxWidth,'String');
box_height = get(handles.boxHeight,'String');
area_thresh = get(handles.areaThreshold,'String');

filename = char(file_input);
dirname = char(dir_input);
backfile = char(back_input);
box_width = str2num(box_width);
box_height = str2num(box_height);
area_thresh = str2num(area_thresh);
axes(handles.axes1);
global inCord;
inCord = getInput(filename,dirname, backfile, 'box.png',box_width,box_height,  area_thresh);

% --- Executes on Find Target
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global outCord;

file_input = get(handles.targetFile,'String');
dir_input = get(handles.targetDir,'String');
back_input = get(handles.backTargetFile,'String');
filename = char(file_input);
dirname = char(dir_input);
backfile = char(back_input);

area_thresh = get(handles.areaThreshold,'String');
area_thresh = str2num(area_thresh);

filepath = sprintf('%s/%s',dirname,filename);

useNbr = 0;
if (get(handles.nbrCheck,'Value') == get(handles.nbrCheck,'Max'))
   useNbr = 1;
end
axes(handles.axes2);
[val, cord] = match_scan(filename, dirname, backfile, 'box.png',  10, area_thresh, useNbr);
outCord = cord;


function inputFile_Callback(hObject, eventdata, handles)
% hObject    handle to inputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputFile as text
%        str2double(get(hObject,'String')) returns contents of inputFile as a double


% --- Executes during object creation, after setting all properties.
function inputFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function backInputFile_Callback(hObject, eventdata, handles)
% hObject    handle to backInputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of backInputFile as text
%        str2double(get(hObject,'String')) returns contents of backInputFile as a double


% --- Executes during object creation, after setting all properties.
function backInputFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backInputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on Source Tracking
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global inCord;
dir_input = get(handles.inputDir,'String');
dirname = char(dir_input);

box_width = get(handles.boxWidth,'String');
box_height = get(handles.boxHeight,'String');
num_frames = get(handles.numInputFrames,'String');

box_width = str2num(box_width);
box_height = str2num(box_height);
num_frames = str2num(num_frames);

trackingext('img',dirname, num_frames, double([inCord(2) inCord(1)]), box_width, box_height);
axes(handles.axes1);
play_image_strip('img','.',0,num_frames);

% --- Executes on Load Source Image
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file_input = get(handles.inputFile,'String');
dir_input = get(handles.inputDir,'String');
filename = char(file_input);
dirname = char(dir_input);
axes(handles.axes1);
filepath = sprintf('%s/%s',dirname,filename);
img = imread(filepath);
imshow(img);


% --- Executes on Load Target Image
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file_input = get(handles.targetFile,'String');
dir_input = get(handles.targetDir,'String');
filename = char(file_input);
dirname = char(dir_input);
axes(handles.axes2);
filepath = sprintf('%s/%s',dirname,filename);
img = imread(filepath);
imshow(img);

% ---Track handover target
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global outCord;
dir_input = get(handles.targetDir,'String');
dirname = char(dir_input);

trackingext('img',dirname, 80, double([outCord(2) outCord(1)]), 33, 45);
axes(handles.axes2);
play_image_strip('img','.',0,80);


function inputDir_Callback(hObject, eventdata, handles)
% hObject    handle to inputDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputDir as text
%        str2double(get(hObject,'String')) returns contents of inputDir as a double


% --- Executes during object creation, after setting all properties.
function inputDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function targetFile_Callback(hObject, eventdata, handles)
% hObject    handle to targetFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of targetFile as text
%        str2double(get(hObject,'String')) returns contents of targetFile as a double


% --- Executes during object creation, after setting all properties.
function targetFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function backTargetFile_Callback(hObject, eventdata, handles)
% hObject    handle to backTargetFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of backTargetFile as text
%        str2double(get(hObject,'String')) returns contents of backTargetFile as a double


% --- Executes during object creation, after setting all properties.
function backTargetFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backTargetFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function targetDir_Callback(hObject, eventdata, handles)
% hObject    handle to targetDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of targetDir as text
%        str2double(get(hObject,'String')) returns contents of targetDir as a double


% --- Executes during object creation, after setting all properties.
function targetDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Choose Handover Input
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir_input = get(handles.inputDir,'String');
back_input = get(handles.backInputFile,'String');
dirname = char(dir_input);
backfile = char(back_input);
num_frames = get(handles.numInputFrames,'String');
num_frames = str2num(num_frames);

box_width = get(handles.boxWidth,'String');
box_height = get(handles.boxHeight,'String');
area_thresh = get(handles.areaThreshold,'String');

box_width = str2num(box_width);
box_height = str2num(box_height);
area_thresh = str2num(area_thresh);

last_input_frame=sprintf('%s%.4d.png','img',num_frames);
axes(handles.axes1);

getInput(last_input_frame,dirname, backfile, 'box.png',box_width,box_height, area_thresh);



function numInputFrames_Callback(hObject, eventdata, handles)
% hObject    handle to numInputFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numInputFrames as text
%        str2double(get(hObject,'String')) returns contents of numInputFrames as a double


% --- Executes during object creation, after setting all properties.
function numInputFrames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numInputFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boxWidth_Callback(hObject, eventdata, handles)
% hObject    handle to boxWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boxWidth as text
%        str2double(get(hObject,'String')) returns contents of boxWidth as a double


% --- Executes during object creation, after setting all properties.
function boxWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boxHeight_Callback(hObject, eventdata, handles)
% hObject    handle to boxHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boxHeight as text
%        str2double(get(hObject,'String')) returns contents of boxHeight as a double


% --- Executes during object creation, after setting all properties.
function boxHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function areaThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to areaThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of areaThreshold as text
%        str2double(get(hObject,'String')) returns contents of areaThreshold as a double


% --- Executes during object creation, after setting all properties.
function areaThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to areaThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in nbrCheck.
function nbrCheck_Callback(hObject, eventdata, handles)
% hObject    handle to nbrCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nbrCheck
