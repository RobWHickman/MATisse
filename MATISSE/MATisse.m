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
%suppress common warnings we dont care about
warning('off','daq:digitalio:adaptormismatch')
warning('off','daq:analoginput:adaptormismatch')

%set the background picture
%commented for now as is super messy
% axes(handles.background)
% matisse_image = imread('../../MATISSE/matisse.jpg');
% image(matisse_image)
% axis off
% axis image
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
handles.parameters.save_info.experimenter = 'Robert';
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
handles.parameters.save_info.primate = 'some_monkey';
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
    %update the task checks with the values of the checkboxes
    requirement_vector = [get(handles.Fixation_check, 'Value'),...
        get(handles.Centered_check, 'Value'),...
        get(handles.Bidding_check, 'Value'),...
        get(handles.Finalised_check, 'Value'),...
        get(handles.Targeted_check, 'Value')];
    handles.parameters.task_checks.Requirement = requirement_vector';
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
display('running!');
if get(hObject,'Value')
    if ~isfield(handles.parameters, 'total_trials')
        display('trials not found!');
        handles.parameters.total_trials = 0;
    end
    display(handles.parameters.total_trials);
    while get(hObject,'Value') && handles.parameters.total_trials < 1000
        %set(handles.Run_button,'string','running...','enable','on','BackgroundColor','[1, 0, 1]');
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
        set(handles.text57, 'String', handles.results.experiment_summary.left);
        set(handles.text58, 'String', handles.results.experiment_summary.right);
       
        %update the GUI with these fields
        drawnow;
    end
    %if the task is paused by hitting the button again
    %n.b. only pauses at the end of a trial
    %set(handles.Run_button,'string','stopped...','enable','on','BackgroundColor','[1, 1, 1]');
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
pause(0.2);
%get the current joystick voltages (when stationary)
test_data = peekdata(joystick,120);
test_data_x = test_data(:,1);
display('remaining x bias:');
joy_x   = mean(test_data_x)
test_data_y = test_data(:,2);
display('remaining y bias:');
joy_y   = (mean(test_data_y))
%automatically update the x and y bias and the gui with these values
%can be overridden manually after
set(handles.Set_X_Bias,'String', num2str(-joy_x));
handles.hardware.inputs.settings.joystick_x_bias = get(handles.Set_X_Bias,'String');
set(handles.Set_Y_Bias,'String', num2str(-joy_y));
handles.hardware.inputs.settings.joystick_y_bias = get(handles.Set_Y_Bias,'String');
guidata(hObject, handles);

%edit the bias in the GUI
function Set_Y_Bias_Callback(hObject, eventdata, handles)
clear handles.hardware.inputs.settings.joystick_y_bias;
handles.hardware.inputs.settings.joystick_y_bias = get(handles.Set_Y_Bias,'String');
display('set new joystick Y bias');
guidata(hObject, handles);
function Set_X_Bias_Callback(hObject, eventdata, handles)
clear handles.hardware.inputs.settings.joystick_x_bias;
handles.hardware.inputs.settings.joystick_x_bias = get(handles.Set_X_Bias,'String');
display('set new joystick X bias');
guidata(hObject, handles);
function Set_Y_Bias_CreateFcn(hObject, eventdata, handles)
%set defalt bias to 0
handles.hardware.inputs.settings.joystick_y_bias = '0';
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);
function Set_X_Bias_CreateFcn(hObject, eventdata, handles)
handles.hardware.inputs.settings.joystick_x_bias = '0';
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

%set the joystick sensitivity
function Joystick_sensitivty_Callback(hObject, eventdata, handles)
clear handles.hardware.inputs.settings.joystick_sensitivity;
handles.hardware.inputs.settings.joystick_sensitivity = str2num(get(handles.Joystick_sensitivty,'String'));
display('set new joystick sensitivity');
guidata(hObject, handles);
function Joystick_sensitivty_CreateFcn(hObject, eventdata, handles)
handles.hardware.inputs.settings.joystick_sensitivity = str2num('0.01');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

%set the joystick scalar (how fast it makes the bar travel)
function Joystick_scalar_Callback(hObject, eventdata, handles)
clear handles.hardware.inputs.settings.joystick_scalar;
handles.hardware.inputs.settings.joystick_scalar = str2num(get(handles.Joystick_scalar,'String'));
display('set new joystick scalar');
guidata(hObject, handles);
%default is 8
function Joystick_scalar_CreateFcn(hObject, eventdata, handles)
handles.hardware.inputs.settings.joystick_scalar = str2num('8');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


%test that the solenoids are functional
%will run the solenoid functions from the task
%this will overwrite the results so run it before running the task
function Solenoid_button_Callback(hObject, eventdata, handles)
if ~isfield(handles, 'results')
    handles.hardware = find_solenoid(handles.hardware);
    if handles.hardware.outputs.settings.calibration == 0
        fake_results = release_liquid('no_parameters', handles.hardware, 'no_results', 'test_tap');
    elseif handles.hardware.outputs.settings.calibration == 1
        fake_results = release_liquid('no_parameters', handles.hardware, 'no_results', 'calibrate');
    else
        display('illegal solenoid test state');
    end
else
    display('results field exists! run test solenoid before running task to prevent overwriting')
end
%set the buttons state back to 0 (off)
set(handles.Solenoid_button,'value',0);

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
display(handles.results.full_output_table.trial_results);

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
clear handles.hardware.inputs.settings.fixation_test;
joystick_fixation = get(handles.Joystick_fixation, 'Value');
if joystick_fixation == 1
    handles.hardware.inputs.settings.fixation_test = 'joystick';
else
    handles.hardware.inputs.settings.fixation_test = 'eye_tracker';
end
guidata(hObject, handles);
function Eye_fixation_Callback(hObject, eventdata, handles)
clear handles.hardware.inputs.settings.fixation_test;
eye_fixation = get(handles.Eye_fixation, 'Value');
if eye_fixation == 1
    handles.hardware.inputs.settings.fixation_test = 'eye_tracker';
else
    handles.hardware.inputs.settings.fixation_test = 'joystick';
end
guidata(hObject, handles);
function Joystick_fixation_CreateFcn(hObject, eventdata, handles)
%set default to be eyetracker
handles.hardware.inputs.settings.fixation_test = 'joystick';
guidata(hObject, handles);

%whether or not the monekys bid must be targeted to a semi-transparent
%recatngle within the bidspace
%activiates check targeting and updates the task_checks in parameters
%the drawing functions in these epochs are found in targeting_epochs within
%the generate_task folder
function Offer_targeting_Callback(hObject, eventdata, handles)
clear handles.parameters.targeting.requirement;
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	set(handles.Offer_targeting,'string','Targeting ON','enable','on','BackgroundColor','green');
    handles.parameters.targeting.requirement = 1;
    %turn the targeting check on
    set(handles.Targeted_check,'value',1);
    %display(handles.Mode_button.Value);
elseif button_state == get(hObject,'Min')
	set(handles.Offer_targeting,'string','Targeting OFF','enable','on','BackgroundColor','red');
    handles.parameters.targeting.requirement = 0;
    %turn the targeting check off
    set(handles.Targeted_check,'value',0);
end
guidata(hObject, handles);
function Offer_targeting_CreateFcn(hObject, eventdata, handles)
handles.parameters.targeting.requirement = 0;
guidata(hObject, handles);

%parameters for the targeting
%should the targetbox be filled or just an outline
function Filled_targetbox_Callback(hObject, eventdata, handles)
clear handles.parameters.targeting.filled;
filled_targetbox = get(handles.Filled_targetbox, 'Value');
handles.parameters.targeting.filled = filled_targetbox;
guidata(hObject, handles);
function Filled_targetbox_CreateFcn(hObject, eventdata, handles)
handles.parameters.targeting.filled = 1;
guidata(hObject, handles);

%should the targetbox shrink as the monkey gets more results correct
%shrinks to max 10% of the bidspace
%starts at the initial size
function Static_targetbox_Callback(hObject, eventdata, handles)
clear handles.parameters.targeting.static;
static_targetbox = get(handles.Static_targetbox, 'Value');
handles.parameters.targeting.static = static_targetbox;
guidata(hObject, handles);
function Static_targetbox_CreateFcn(hObject, eventdata, handles)
handles.parameters.targeting.static = 1;
guidata(hObject, handles);

%the size of the static box or the initial (max) size of the shrinking
%target box
function Targetbox_startsize_Callback(hObject, eventdata, handles)
clear handles.parameters.targeting.startsize;
%must be between zero and one
if  str2num(get(handles.Targetbox_startsize,'String')) > 1 |...
        str2num(get(handles.Targetbox_startsize,'String')) < 0
    display('Must be a percentage! (between 0 and 1)');
else
    handles.parameters.targeting.startsize = str2num(get(handles.Targetbox_startsize,'String'));
    display(strcat('Targetbox Startsize changed to: ', num2str(handles.parameters.targeting.startsize)));
end
guidata(hObject, handles);
function Targetbox_startsize_CreateFcn(hObject, eventdata, handles)
handles.parameters.targeting.startsize = str2num('0.5');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);





%toggle button to decide if the joystick is simply binary (forward and back the same amount each frame)
%or if it has acceleration (the further forward the joystick, the more the bar moves)
function Joystick_movement_Callback(hObject, eventdata, handles)
clear handles.hardware.inputs.settings.joystick_velocity;
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	set(handles.Joystick_movement,'string','Velocity Joystick','enable','on','BackgroundColor','green');
    handles.hardware.inputs.settings.joystick_velocity = 1;
    %display(handles.Mode_button.Value);
elseif button_state == get(hObject,'Min')
	set(handles.Joystick_movement,'string','Binary Joystick','enable','on','BackgroundColor','red');
    handles.hardware.inputs.settings.joystick_velocity = 0;
end
guidata(hObject, handles);
%set default to binary
function Joystick_movement_CreateFcn(hObject, eventdata, handles)
handles.hardware.inputs.settings.joystick_velocity = 0;
guidata(hObject, handles);


function Solenoid_calibration_Callback(hObject, eventdata, handles)
clear handles.hardware.outputs.settings.calibration;
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	set(handles.Solenoid_calibration,'string','','enable','on','BackgroundColor','green');
    handles.hardware.outputs.settings.calibration = 1;
    %display(handles.Mode_button.Value);
elseif button_state == get(hObject,'Min')
	set(handles.Solenoid_calibration,'string','','enable','on','BackgroundColor','red');
    handles.hardware.outputs.settings.calibration = 0;
end
guidata(hObject, handles);
function Solenoid_calibration_CreateFcn(hObject, eventdata, handles)
handles.hardware.outputs.settings.calibration = 0;
guidata(hObject, handles);







%checkboxes controlling which task checks to use
%don't need any code
function Centered_check_Callback(hObject, eventdata, handles)
function Fixation_check_Callback(hObject, eventdata, handles)
function Bidding_check_Callback(hObject, eventdata, handles)
function Finalised_check_Callback(hObject, eventdata, handles)
function Targeted_check_Callback(hObject, eventdata, handles)


%%BUNDLE STUFF%%
function Bundles_width_Callback(hObject, eventdata, handles)
clear handles.parameters.binary_choice.bundle_width
handles.parameters.binary_choice.bundle_width = str2num(get(handles.Bundles_width,'String'));
display(handles.parameters.binary_choice.bundle_width);
guidata(hObject, handles);
function Bundles_width_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.parameters.binary_choice.bundle_width = 40;
guidata(hObject, handles);


%the number of divisions of water budget in the bundle
function Budget_divisions_Callback(hObject, eventdata, handles)
clear handles.parameters.binary_choice.experimenter;
handles.parameters.binary_choice.divisions = str2double(get(handles.Budget_divisions,'String'));
guidata(hObject, handles);
function Budget_divisions_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.parameters.binary_choice.divisions = str2double('10');
guidata(hObject, handles);


function Show_bundles_Callback(hObject, eventdata, handles)

function Remove_fractals_Callback(hObject, eventdata, handles)


function Binary_choice_Callback(hObject, eventdata, handles)
clear handles.parameters.task
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	set(handles.Binary_choice,'string','','enable','on','BackgroundColor','green');
    handles.parameters.task = 'BC';
    handles.parameters.binary_choice.divisions = get(handles.Budget_divisions,'String');
    handles.parameters.binary_choice.bundle_width = get(handles.Bundles_width,'String');
elseif button_state == get(hObject,'Min')
	set(handles.Binary_choice,'string','','enable','on','BackgroundColor','red');
    handles.parameters.task = 'BDM';
    handles.parameters = rmfield(handles.parameters, 'binary_choice');
end
guidata(hObject, handles);
function Binary_choice_CreateFcn(hObject, eventdata, handles)
handles.parameters.task = 'BDM';
guidata(hObject, handles);



% % --- Executes on slider movement.
% function Added_bias_Callback(hObject, eventdata, handles)
% clear handles.hardware.inputs.settings.added_bias;
% slider_state = get(hObject,'Value');
% handles.hardware.inputs.settings.added_bias = slider_state;
% guidata(hObject, handles);
% %set default to 0.5
% function Added_bias_CreateFcn(hObject, eventdata, handles)
% handles.hardware.inputs.settings.added_bias = 0.5;
% guidata(hObject, handles);

