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
    [handles.parameters, handles.stimuli, handles.hardware, handles.results, handles.task_window] =  Generate(handles.parameters, handles.hardware);
else
    disp('save_info not found! Did you remember to run Set?')
end
display(handles.parameters.correct_trials);
guidata(hObject, handles);

%function to actually run the task
%runs one trial at a time and outputs a mat file with all the data for the
%task (note experiment parameters will reflect the parameters on the LAST
%trial so don't change halfway through)
%also spits out the current means for each fractal to update the GUI
function Run_button_Callback(hObject, eventdata, handles)
display('running!');
if get(hObject,'Value')
    if ~isfield(handles.parameters, 'total_trials')
        display('trials not found!');
        handles.parameters.total_trials = 0;
    end
    display(handles.parameters.total_trials);
    while get(hObject,'Value') && handles.parameters.total_trials < 10
        set(handles.Run_button,'string','running...','enable','on','BackgroundColor','[1, 0, 1]');
        [handles.results, handles.parameters] = Run(handles.parameters, handles.stimuli, handles.hardware, handles.results, handles.task_window);
        if handles.parameters.total_trials < 1
            handles.results = assign_experiment_metadata(handles.parameters, handles.stimuli, handles.hardware, handles.results);
        end
        handles.parameters.total_trials = handles.parameters.total_trials + 1;
        display('trial number:');
        %the trials are zero indexed so add one
        display(handles.parameters.total_trials + 1);
        guidata(hObject, handles);
        
        %update the graph
        axes(handles.BidHistory_axes);
        bar(handles.results.experiment_summary.means);
        %update the text
        set(handles.text32, 'String', handles.parameters.total_trials);
        set(handles.text31, 'String', handles.results.experiment_summary.correct);
        set(handles.text30, 'String', handles.results.experiment_summary.error);
        set(handles.text26, 'String', handles.results.experiment_summary.percent_correct);
        set(handles.text33, 'String', handles.results.experiment_summary.rewarded);
        set(handles.text34, 'String', handles.results.experiment_summary.not_rewarded);
        set(handles.text37, 'String', handles.results.experiment_summary.total_budget);
        set(handles.text38, 'String', handles.results.experiment_summary.total_reward);
        
        %update the GUI with these fields
        drawnow;
    end
    %if the task is paused by hitting the button again
    %n.b. only pauses at the end of a trial
    set(handles.Run_button,'string','stopped...','enable','on','BackgroundColor','[1, 1, 1]');
    drawnow;
    guidata(hObject, handles);
end


%quick function that saves the output from the experiment
%really if everything is going right there should only be one file per
%monkey per day
function Save_button_Callback(hObject, eventdata, handles)
save_data(handles.parameters, handles.results);
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
clear handles.hardware.testmode;
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	set(handles.Mode_button,'string','Test ON','enable','on','BackgroundColor','green');
    handles.hardware.testmode = 1;
    %display(handles.Mode_button.Value);
elseif button_state == get(hObject,'Min')
	set(handles.Mode_button,'string','Test OFF','enable','on','BackgroundColor','red');
    handles.hardware.testmode = 0;
    %display(handles.hardware.testmode.Value);
end
guidata(hObject, handles);
function Mode_button_CreateFcn(hObject, eventdata, handles)
handles.hardware.testmode = 0;
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
%will run the solenoid functions from the task
%this will overwrite the results so run it before running the task
function Solenoid_button_Callback(hObject, eventdata, handles)
if ~isfield(handles, 'results')
    hardware = find_solenoid();
    results = release_liquid('no_parameters', hardware, 'no_results', 'test_tap')
else
    display('results field exists! run test solenoid before running task to prevent overwriting')
end

%choose which solenoid to test when calling 'test solenoid'
%in the current set up there are 3 taps
%see release_liquid in IO_Devices
function Set_Solenoid_Callback(hObject, eventdata, handles)
clear handles.hardware.outputs.settings.test_tap;
handles.hardware.outputs.settings.test_tap = str2num(get(handles.Set_Solenoid,'String'));
display(strcat('test solenoid tap changed to', num2str(handles.hardware.outputs.settings.test_tap)));
guidata(hObject, handles);
function Set_Solenoid_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%set default tap to test to 1
handles.hardware.outputs.settings.test_tap = 1;
guidata(hObject, handles);
%also set the length for the solenoid to open when in test mode
function Solenoid_open_time_Callback(hObject, eventdata, handles)
clear handles.hardware.outputs.settings.test_open_time;
handles.hardware.outputs.settings.test_open_time = str2num(get(handles.Solenoid_open_time,'String'));
display(strcat('test solenoid opening time changed to', num2str(handles.hardware.outputs.settings.test_open_time)));
guidata(hObject, handles);
function Solenoid_open_time_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%set default tap opening time to 1s
handles.hardware.outputs.settings.test_open_time = 1;
guidata(hObject, handles);


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
function text31_CreateFcn(hObject, eventdata, handles)
guidata(hObject, handles);






%display_button
function pushbutton10_Callback(hObject, eventdata, handles)
display(handles.parameters.targeting);
if handles.parameters.targeting
    display('lolll')
else
    display('nooo')
end




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

%whether or not the monekys bid must be targeted to a semi-transparent
%recatngle within the bidspace
%activiates check targeting and updates the task_checks in parameters
%the drawing functions in these epochs are found in targeting_epochs within
%the generate_task folder
function Offer_targeting_Callback(hObject, eventdata, handles)
clear handles.parameters.targeting;
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	set(handles.Offer_targeting,'string','Targeting ON','enable','on','BackgroundColor','green');
    handles.parameters.targeting = 1;
    %display(handles.Mode_button.Value);
elseif button_state == get(hObject,'Min')
	set(handles.Offer_targeting,'string','Targeting OFF','enable','on','BackgroundColor','red');
    handles.parameters.targeting = 0;
    %display(handles.hardware.testmode.Value);
end
guidata(hObject, handles);
function Offer_targeting_CreateFcn(hObject, eventdata, handles)
handles.hardware.testmode = 0;
guidata(hObject, handles);
