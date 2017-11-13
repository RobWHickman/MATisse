%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   DO NOT EDIT ANY OF THIS SECTION- IT SETS UP GUIDE FOR MATLAB    %
%function to run the MATisse GUI
%these functions control the behaviour of the various buttons/etc in the
%GUI and what they run
%generally best to avoid messing here if possible 

%guidata(hObject, handles) is used at the end of functions to return the
%handles from that function for GUIDE (the MATLAB GUI program) to work with
function varargout = MATisse(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MATisse_OpeningFcn, ...
                   'gui_OutputFcn',  @MATisse_OutputFcn, ...
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

% --- Executes just before MATisse is made visible.
function MATisse_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for MATisse
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = MATisse_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%










%%  STRING OUTPUT
%first set the strings for the experiment you are about to run
%who is running the trial and which monkey is being tested
%set the experimenter
function Set_Experimenter_Callback(hObject, eventdata, handles)
clear handles.parameters.save_info.experimenter;
handles.parameters.save_info.experimenter = get(handles.Set_Experimenter,'String');
%display the new experimenter upon enter
display(strcat('Experimenter Changed to: ', handles.parameters.save_info.experimenter))
guidata(hObject, handles);
%set the default
function Set_Experimenter_CreateFcn(hObject, eventdata, handles)
handles.parameters.save_info.experimenter = "Robert";
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

%set the primate being tested
function Set_Primate_Callback(hObject, eventdata, handles)
clear handles.parameters.save_info.primate;
handles.parameters.save_info.primate = get(handles.Set_Primate,'String');
%display the new primate upon enter
display(strcat('Primate Changed to: ', handles.parameters.save_info.primate))
guidata(hObject, handles);
%set the default
function Set_Primate_CreateFcn(hObject, eventdata, handles)
handles.parameters.save_info.primate = "some_monkey";
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);










%%  EXPERIMENT BUTTONS
%functions to run the scripts which will set up the BDM task and then
%execute it
%made up of three buttons Set, Generate, and Run

%first set up the task
%this will set the inputs and ask you to find two folders:
%1) to set where the data from the experiment will be saved at the end of
%everything
%2) to set where to run the task from- this should be a folder with
%functions called Generate and Run inside it and a parameters file with the
%task conditions
function Set_button_Callback(hObject, eventdata, handles)
disp('Setting System...')
handles.parameters = matisse_set(handles.parameters);
%save this data
guidata(hObject, handles);

%function to set up as much as possible before hitting run
%anything really intensive in the Run function is done before any stimulus
%presentation anyway, but best to separate out as much as possible before
%even that
function Gen_button_Callback(hObject, eventdata, handles)
if isfield(handles.parameters,'save_info')
    disp('Generating Experiment...')
    [handles.parameters, handles.stimuli, handles.hardware, handles.results, handles.task_window] =  Generate(handles.hardware);
else
    disp('save_info not found! Did you remember to run Set?')
end
guidata(hObject, handles);

%function to actually run the task
%runs one trial at a time and outputs a mat file with all the data for the
%task (note experiment parameters will reflect the parameters on the LAST
%trial so don't change halfway through)
%also spits out the current means for each fractal to update the GUI
function Run_button_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    disp('Running Trials...')
    %if no trial variable is found it means we havent run the script yet,
    %so set the trial to 1
    if ~exist('trial')
        trial = 1;
    end
    set(handles.Run_button,'string','running!','enable','on','BackgroundColor','green');
    while get(hObject,'value') && trial < handles.parameters.total_trials
        %run a single trial
        handles.results = Run(handles.parameters, handles.stimuli, handles.hardware, handles.results, handles.task_window);
        %about 60ms of dead space here
        %save the output
        guidata(hObject, handles);
        %update the graph
        axes(handles.BidHistory_axes);
        bar(handles.experiment_summary.means);
        %update the text
        set(handles.text32, 'String', trial);
        set(handles.text31, 'String', handles.experiment_summary.correct);
        set(handles.text30, 'String', handles.experiment_summary.error);
        set(handles.text26, 'String', handles.experiment_summary.percent_correct);
        set(handles.text33, 'String', handles.experiment_summary.rewarded);
        set(handles.text34, 'String', handles.experiment_summary.not_rewarded);
        set(handles.text37, 'String', handles.experiment_summary.total_water);
        set(handles.text38, 'String', handles.experiment_summary.total_juice);
        %update the app information
        trial = trial + 1;
        drawnow
    end
    %a screen to show whilst paused
    draw_pause_screen(handles.screen_info, handles.parameters, handles.task_window)
    %change the button to show we've paused the experiment
    set(handles.Run_button,'string','Paused...','enable','on','BackgroundColor','[1, 1, 1]');
end

%quick function that saves the output from the experiment
%really if everything is going right there should only be one file per
%monkey per day
function Save_button_Callback(hObject, eventdata, handles)
save_data(handles.save_info, handles.full_output, handles.experiment_summary);
display('data saved!');










%% QUITTING FUNCTIONS
%small function to clear everything and restart MATisse
function Clear_button_Callback(hObject, eventdata, handles)
clear_all();
%quits modig
function Exit_button_Callback(hObject, eventdata, handles)
%close stuff
close all;
sca;










%% TESTING FUNCTIONS
%functionto set to 'test' mode when instead of a joystick/eye tracker, the
%mouse and keyboard can be used to run experiments
%is piped into Generate() as either a 0 (testmode off) or a 1 (testmode)
function Mode_button_Callback(hObject, eventdata, handles)
clear handles.hardware.inputs.settings.testmode;
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	set(handles.Mode_button,'string','Test ON','enable','on','BackgroundColor','green');
    handles.hardware.inputs.settings.testmode = 1;
    %display(handles.Mode_button.Value);
elseif button_state == get(hObject,'Min')
	set(handles.Mode_button,'string','Test OFF','enable','on','BackgroundColor','red');
    handles.hardware.inputs.settings.testmode = 0;
    %display(handles.hardware.inputs.settings.testmode.Value);
end
guidata(hObject, handles);
function Mode_button_CreateFcn(hObject, eventdata, handles)
handles.hardware.inputs.settings.testmode = 0;
guidata(hObject, handles);

%tests the bias on the joystick
%use this to correct to zero so that 'at rest' - when the monkey is not
%moving it- it shows 0v
function Joystick_button_Callback(hObject, eventdata, handles)
%reset the devices
daqreset();
%get the joystick data
joystick = find_joystick(200, 'analog');
%start(joystick); %throw an error- not sure why
pause(1);
%get the current joystick voltages (when stationary)
test_data = peekdata(joystick,30);
test_data_x = test_data(:,1);
display('remaining x bias:');
joy_x   = -(mean(test_data_x)) + handles.hardware.inputs.settings.joystick_x_bias
test_data_y = test_data(:,2);
display('remaining y bias:');
joy_y   = -(mean(test_data_y)) + handles.hardware.inputs.settings.joystick_y_bias

%edit the bias in the GUI
function Set_Y_Bias_Callback(hObject, eventdata, handles)
clear handles.hardware.inputs.settings.joystick_y_bias;
handles.hardware.inputs.settings.joystick_y_bias = get(handles.Set_Y_Bias,'String');
guidata(hObject, handles);
function Set_X_Bias_Callback(hObject, eventdata, handles)
clear handles.hardware.inputs.settings.joystick_x_bias;
handles.hardware.inputs.settings.joystick_x_bias = get(handles.Set_X_Bias,'String');
guidata(hObject, handles);
function Set_Y_Bias_CreateFcn(hObject, eventdata, handles)
%set defalt bias to 0
handles.hardware.inputs.settings.joystick_y_bias = 0;
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);
function Set_X_Bias_CreateFcn(hObject, eventdata, handles)
handles.hardware.inputs.settings.joystick_x_bias = 0;
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

%test that the solenoids are functional
function Solenoid_button_Callback(hObject, eventdata, handles)

%choose which solenoid to test
function Set_Solenoid_Callback(hObject, eventdata, handles)
function Set_Solenoid_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%allow the user to specify the monitor to use for the experimental task
%defaults to monitor number 2
function Set_Monitor_Callback(hObject, eventdata, handles)
clear handles.hardware.outputs.screen_info.screen_number;
handles.hardware.outputs.screen_info.screen_number = str2num(get(handles.Set_Monitor,'String'));
display(strcat('task monitor changed to', num2str(handles.hardware.outputs.screen_info.screen_number)));
guidata(hObject, handles);
function Set_Monitor_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%set default monitor to number 2
handles.hardware.outputs.screen_info.screen_number = 2;
guidata(hObject, handles);










%%A E S T H E T I C S
%create and destroy the graph upon opening and closing
function BidHistory_axes_CreateFcn(hObject, eventdata, handles)
function BidHistory_axes_DeleteFcn(hObject, eventdata, handles)
%create the static text
function text26_CreateFcn(hObject, eventdata, handles)
function text30_CreateFcn(hObject, eventdata, handles)
%and so on





% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display(handles.hardware.outputs)
display(handles.hardware.outputs.screen_info)
display(handles.hardware.inputs)
display(handles.hardware.inputs.settings)






%set the direction of bidding
function X_axis_bidding_Callback(hObject, eventdata, handles)
x_dimension_bidding = get(handles.X_axis_bidding, 'Value');
if x_dimension_bidding == 1
    handles.hardware.inputs.settings.direction = 'x';
else
    handles.hardware.inputs.settings.direction = 'y';
end
guidata(hObject, handles);
function Y_axis_bidding_Callback(hObject, eventdata, handles)
y_dimension_bidding = get(handles.Y_axis_bidding, 'Value');
if y_dimension_bidding == 1
    handles.hardware.inputs.settings.direction = 'y';
else
    handles.hardware.inputs.settings.direction = 'x';
end
guidata(hObject, handles);
function X_axis_bidding_CreateFcn(hObject, eventdata, handles)
handles.hardware.inputs.settings.direction = 'y';
guidata(hObject, handles);


%set the method of fixation
function Joystick_fixation_Callback(hObject, eventdata, handles)
joystick_fixation = get(handles.Joystick_fixation, 'Value');
if joystick_fixation == 1
    handles.hardware.inputs.settings.fixation_test = 'joystick';
else
    handles.hardware.inputs.settings.fixation_test = 'eye_tracker';
end
guidata(hObject, handles);
function Eye_fixation_Callback(hObject, eventdata, handles)
eye_fixation = get(handles.Joystick_fixation, 'Value');
if eye_fixation == 1
    handles.hardware.inputs.settings.fixation_test = 'eye_tracker';
else
    handles.hardware.inputs.settings.fixation_test = 'fixation';
end
guidata(hObject, handles);
function Joystick_fixation_CreateFcn(hObject, eventdata, handles)
handles.hardware.inputs.settings.fixation_test = 'eye_tracker';
guidata(hObject, handles);
