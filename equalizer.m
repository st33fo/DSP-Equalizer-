function varargout = equalizer(varargin)
% EQUALIZER MATLAB code for equalizer.fig
%      EQUALIZER, by itself, creates a new EQUALIZER or raises the existing
%      singleton*.
%
%      H = EQUALIZER returns the handle to a new EQUALIZER or the handle to
%      the existing singleton*.
%      EQUALIZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EQUALIZER.M with the given input arguments.
%
%      EQUALIZER('Property','Value',...) creates a new EQUALIZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before equalizer_OpeningFcn g
%ets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to equalizer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help equalizer

% Last Modified by GUIDE v2.5 25-Apr-2018 21:21:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @equalizer_OpeningFcn, ...
                   'gui_OutputFcn',  @equalizer_OutputFcn, ...
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


% --- Executes just before equalizer is made visible.
function equalizer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to equalizer (see VARARGIN)

% Choose default command line output for equalizer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);




% --- Outputs from this function are returned to the command line.
function varargout = equalizer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
%This function browses for audio files in the .wav format. 
[filename pathname] =uigetfile({'*.wav'},'File Selector');
handles.fullpathname = strcat(pathname,filename);
set(handles.address,'String',handles.fullpathname)
guidata(hObject,handles)

function play_equalizer(hObject, handles)
global player;
global OGplayer;
[handles.y,handles.Fs] = audioread(handles.fullpathname); %takes the filename found from the browse function and reads it


%Gets the values of the sliders when it moves (Controls the amplitude)
handles.band1=get(handles.slider1,'value'); %low pass
handles.band2=get(handles.slider2,'value'); %band pass500
handles.band3=get(handles.slider3,'value'); % bandpass 1125
handles.band4=get(handles.slider4,'value');%bandpass4750
handles.band5=get(handles.slider5,'value');  %highpass15000

%Displays the values of the sliders above
set(handles.text34, 'String',handles.band1);
set(handles.text35, 'String',handles.band2);
set(handles.text36, 'String',handles.band3);
set(handles.text37, 'String',handles.band4);
set(handles.text38, 'String',handles.band5);




segment = handles.y(handles.Fs*20:handles.Fs*40); %takes a portion 

%filtering the song
Hd1 = lowpass125;
coef1 = 10^(handles.band1/20);
filt1 = coef1*filter(Hd1,segment);

 Hd2 = bandpass500;
 coef2 = 10^(handles.band2/20);
 filt2 = coef2*filter(Hd2,segment);

Hd3 = bandpass1125;
coef3 = 10^(handles.band3/20);
filt3 = coef3*filter(Hd3,segment);

Hd4 = bandpass4750;
coef3 = 10^(handles.band3/20);
filt4 = coef3*filter(Hd4,segment);

Hd5 = highpass15000;
coef4 = 10^(handles.band4/20);
filt5 = coef4*filter(Hd5,segment);

%handles.Filtered = filt1+filt2;
handles.Filtered = filt1 + filt2 + filt3 + filt4 + filt5; % only plays the song through one filter, need to figure out how to combine all filters

 
OGplayer = audioplayer(segment,handles.Fs); %original audio song file
player = audioplayer(handles.Filtered, handles.Fs);%filtered song player

 axes(handles.axes1);
 plot(segment); %plot original sound file
 xlabel('Sample Number Fs = 44100');
 ylabel('Amplitude');

 axes(handles.axes2);
 plot(handles.Filtered); %plots filtered sound file
 xlabel('Sample Number Fs = 44100');
 ylabel('Amplitude');

 
axes(handles.axes12); %OG fft of song
plot(abs(fft(segment))), title('abs(fft)') 
ylabel('Amplitude');
xlabel('Frequency(Hz)');
 
 axes(handles.axes9);%fft of filtered
plot(abs(fft(handles.Filtered))), title('abs(fft)') 
ylabel('Amplitude');
xlabel('Frequency(Hz)');
 
guidata(hObject,handles)
%



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.band1=get(handles.slider1,'value');

%Displays the values of the sliders above
set(handles.text34, 'String',handles.band1);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.band2=get(handles.slider2,'value');

%Displays the values of the sliders above
set(handles.text35, 'String',handles.band2);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.band4=get(handles.slider4,'value');

%Displays the values of the sliders above
set(handles.text37, 'String',handles.band4);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.band5=get(handles.slider5,'value');

%Displays the values of the sliders above
set(handles.text38, 'String',handles.band5);




% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
play_equalizer(hObject,handles);
play(player);
guidata(hObject, handles)

% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
play_equalizer(hObject,handles);
pause(player);
guidata(hObject, handles)

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.band3=get(handles.slider3,'value');

%Displays the values of the sliders above
set(handles.text36, 'String',handles.band3);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% Resets to 0dB for all sliders
band1=0;
band2=0;
band3=0;
band4=0;
band5=0;

set(handles.slider1,'value',band1);
set(handles.slider2,'value',band2);
set(handles.slider3,'value',band3);
set(handles.slider4,'value',band4);
set(handles.slider5,'value',band5);

%Displays the values of the sliders above
set(handles.text34, 'String',band1);
set(handles.text35, 'String',band2);
set(handles.text36, 'String',band3);
set(handles.text37, 'String',band4);
set(handles.text38, 'String',band5);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
global OGplayer;
play_equalizer(hObject,handles);
stop(player);
play(OGplayer);
guidata(hObject, handles)


%Filters below here
%------------------------------------------------------------------------------------

function Hd = lowpass125
%LOWPASS125 Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.2 and the DSP System Toolbox 9.4.
% Generated on: 17-Apr-2018 14:20:09

% Generalized REMEZ FIR Lowpass filter designed using the FIRGR function.

% All frequency values are in Hz.
Fs = 44000;  % Sampling Frequency

Fpass = 225;              % Passband Frequency
Fstop = 275;              % Stopband Frequency
Dpass = 0.0057563991496;  % Passband Ripple
Dstop = 0.001;            % Stopband Attenuation
dens  = 20;               % Density Factor

% Calculate the coefficients using the FIRGR function.
b  = firgr('minorder', [0 Fpass Fstop Fs/2]/(Fs/2), [1 1 0 0], [Dpass ...
           Dstop], {dens});
Hd = dfilt.dffir(b);

function Hd = bandpass500
%BETTER500 Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.2 and the DSP System Toolbox 9.4.
% Generated on: 17-Apr-2018 14:35:43

% Generalized REMEZ FIR Bandpass filter designed using the FIRGR function.

% All frequency values are in Hz.
Fs = 44000;  % Sampling Frequency

Fstop1 = 225;              % First Stopband Frequency
Fpass1 = 275;              % First Passband Frequency
Fpass2 = 725;              % Second Passband Frequency
Fstop2 = 775;              % Second Stopband Frequency
Dstop1 = 0.001;            % First Stopband Attenuation
Dpass  = 0.0057563991496;  % Passband Ripple
Dstop2 = 0.001;            % Second Stopband Attenuation
dens   = 20;               % Density Factor

% Calculate the coefficients using the FIRGR function.
b  = firgr('minorder', [0 Fstop1 Fpass1 Fpass2 Fstop2 Fs/2]/(Fs/2), [0 ...
           0 1 1 0 0], [Dstop1 Dpass Dstop2], {dens});
Hd = dfilt.dffir(b);

function Hd = bandpass1125
%BANDPASS1125 Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.2 and the DSP System Toolbox 9.4.
% Generated on: 17-Apr-2018 14:23:10

% Generalized REMEZ FIR Bandpass filter designed using the FIRGR function.

% All frequency values are in Hz.
Fs = 44000;  % Sampling Frequency

Fstop1 = 700;              % First Stopband Frequency
Fpass1 = 800;              % First Passband Frequency
Fpass2 = 1450;             % Second Passband Frequency
Fstop2 = 1550;             % Second Stopband Frequency
Dstop1 = 0.001;            % First Stopband Attenuation
Dpass  = 0.0057563991496;  % Passband Ripple
Dstop2 = 0.001;            % Second Stopband Attenuation
dens   = 20;               % Density Factor

% Calculate the coefficients using the FIRGR function.
b  = firgr('minorder', [0 Fstop1 Fpass1 Fpass2 Fstop2 Fs/2]/(Fs/2), [0 ...
           0 1 1 0 0], [Dstop1 Dpass Dstop2], {dens});
Hd = dfilt.dffir(b);

function Hd = bandpass4750
%
Fs = 44000;  % Sampling Frequency

Fstop1 = 1450;             % First Stopband Frequency
Fpass1 = 1550;             % First Passband Frequency
Fpass2 = 7950;             % Second Passband Frequency
Fstop2 = 8050;             % Second Stopband Frequency
Dstop1 = 0.001;            % First Stopband Attenuation
Dpass  = 0.00057563991496;  % Passband Ripple
Dstop2 = 0.001;            % Second Stopband Attenuation
dens   = 20;               % Density Factor

% Calculate the coefficients using the FIRGR function.
b  = firgr('minorder', [0 Fstop1 Fpass1 Fpass2 Fstop2 Fs/2]/(Fs/2), [0 ...
           0 1 1 0 0], [Dstop1 Dpass Dstop2], {dens});
Hd = dfilt.dffir(b);

function Hd = highpass15000
%,HIGHPASS15000 Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.2 and the DSP System Toolbox 9.4.
% Generated on: 17-Apr-2018 14:31:54

% Generalized REMEZ FIR Highpass filter designed using the FIRGR function.

% All frequency values are in Hz.
Fs = 44000;  % Sampling Frequency

Fstop = 7900;             % Stopband Frequency
Fpass = 8100;             % Passband Frequency
Dstop = 0.001;            % Stopband Attenuation
Dpass = 0.0057563991496;  % Passband Ripple
in    = 4;                % Initial order estimate
dens  = 20;               % Density Factor

% Calculate the coefficients using the FIRGR function.
b  = firgr({'mineven', in}, [0 Fstop Fpass Fs/2]/(Fs/2), [0 0 1 1], ...
           [Dstop Dpass], {dens});
Hd = dfilt.dffir(b);
