%   DO NOT EDIT ANY OF THIS SECTION- IT SETS UP GUIDE FOR MATLAB    %
function varargout = MATisse(varargin)
    %Begin initialization code - DO NOT EDIT
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
%Executes just before MATisse is made visible.
function MATisse_OpeningFcn(hObject, eventdata, handles, varargin)
    %suppress common warnings we dont care about
    warning('off','daq:digitalio:adaptormismatch')
    warning('off','daq:analoginput:adaptormismatch')
    %set the default directory to Desktop/MATisse
    root = ['C:/Users/', getenv('username'), '/Desktop/MATisse/task/BDM/'];
    cd(root);
    handles.output = hObject;
    % Update handles structure
guidata(hObject, handles);
%Outputs from this function are returned to the command line.
function varargout = MATisse_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

%you can edit from here on

%Functions to set the involvement of monkey/human in the task
%will be used to set what the output is saved and also can be used
%to set defaults-e.g. with which taps to use
function Set_experimenter_Callback(hObject, eventdata, handles)
    clear handles.parameters.participants.experimenter;
    handles.parameters.participants.experimenter = get(handles.Set_experimenter,'String');
    %display the new experimenter upon enter
    display(strcat('Experimenter Changed to: ', handles.parameters.participants.experimenter))
guidata(hObject, handles);
%set the default
function Set_experimenter_CreateFcn(hObject, eventdata, handles)
    handles.parameters.participants.experimenter = 'Robert';
guidata(hObject, handles);
%set the primate being tested
function Set_primate_Callback(hObject, eventdata, handles)
    clear handles.parameters.participants.primate;
    handles.parameters.participants.primate = get(handles.Set_primate,'String');
    %display the new primate upon enter
    display(strcat('Primate Changed to: ', handles.parameters.participants.primate))
    if ~any(strmatch(handles.parameters.participants.primate, handles.parameters.participants.primate_table.Name))
        display('Could not find monkeys name in table- are you sure it has been typed correctly?');
    end
guidata(hObject, handles);
%set the default
function Set_primate_CreateFcn(hObject, eventdata, handles)
    handles.parameters.participants.primate = 'some_monkey';
    load ../../misc/monkey_table.mat
    handles.parameters.participants.primate_table = monkeys;
guidata(hObject, handles);

%Functions to set the type of task that will be running
%will be used to direct towards the correct task folder and
%to modify src functions (e.g. no need to create budgets in Pavlovian task)
%the default taks is the BDM and this string and folder is set in the
%create function for the Binary Choice task
function Binary_choice_CreateFcn(hObject, eventdata, handles)
    %default task (set at startup) is the BDM
    handles.parameters.task.type = 'BDM';
guidata(hObject, handles);
function Pavlovian_learning_CreateFcn(hObject, eventdata, handles)
guidata(hObject, handles);
function Binary_choice_Callback(hObject, eventdata, handles)
    clear handles.parameters.task.type
    binary_button_state = get(hObject,'Value');
    if binary_button_state == get(hObject,'Max')
        %light up the currently active buttons
        set(handles.Binary_choice,'string','Binary Choice','enable','on','BackgroundColor','green');
        set(handles.Pavlovian_learning,'string','Pavlovian','enable','on','BackgroundColor','red');
        set(handles.Pavlovian_learning,'value',0);
        handles.parameters.task.type = 'BC';
        %set the directory to the pavlovian task
        cd('../Binary_Choice');
    elseif binary_button_state == get(hObject,'Min')
        set(handles.Binary_choice,'string','Binary Choice','enable','on','BackgroundColor','red');
        handles.parameters.task.type = 'BDM';
        handles.parameters = rmfield(handles.parameters, 'binary_choice');
        %set the directory back to the root
        cd('../BDM/');
    end
guidata(hObject, handles);
function Pavlovian_learning_Callback(hObject, eventdata, handles)
    clear handles.parameters.task.type
    pav_button_state = get(hObject,'Value');
    if pav_button_state == get(hObject,'Max')
        %light up the currently active buttons
        set(handles.Pavlovian_learning,'string','Pavlovian','enable','on','BackgroundColor','green');
        set(handles.Binary_choice,'string','Binary Choice','enable','on','BackgroundColor','red');
        set(handles.Binary_choice,'value',0);
        handles.parameters.task.type = 'PAV';
        %set the directory to the pavlovian task
        cd('../Pavlovian_Learning');
    elseif pav_button_state == get(hObject,'Min')
        set(handles.Pavlovian_learning,'string','Pavlovian','enable','on','BackgroundColor','red');
        handles.parameters.task.type = 'BDM';
        %set the directory back to the root
        cd('../BDM/');
    end
guidata(hObject, handles);

%Functions to order the experiment
%set a total number of trials and then use this to (if wanted) create a
%pseudo-random order of stimuli to reduce the cost of task switching to the
%monkey. These combinations are set when Generate() is run
function Total_trials_Callback(hObject, eventdata, handles)
    clear handles.parameters.trials.max_trials;
    %can manually set the max_trials here
    handles.parameters.trials.max_trials = str2num(get(handles.Total_trials,'String'));
guidata(hObject, handles);
function Total_trials_CreateFcn(hObject, eventdata, handles)
    %use 200 as a good initial estimate
    handles.parameters.trials.max_trials = 200;
    %will always start at 0 trials
    handles.parameters.trials.total_trials = 0;
guidata(hObject, handles);
%whether the stimuli should be generated in a pseudo-random order when
%generating or completely random on a trial by trial basis
function Random_stimuli_Callback(hObject, eventdata, handles)
    clear handles.parameters.trials.random_stimuli
    stimuli_button_state = get(hObject,'Value');
    if stimuli_button_state == get(hObject,'Max')
        set(handles.parameters.trials.random_stimuli,'string','Random Stimuli','enable','on','BackgroundColor','green');
        handles.parameters.trials.random_stimuli = 1;
    elseif button_state == get(hObject,'Min')
        set(handles.Random_stimuli,'string','Pseudo-Random','enable','on','BackgroundColor','red');
        handles.parameters.trials.random_stimuli = 0;
    end
guidata(hObject, handles);
%defaults to zero (non random stimuli order)
function Random_stimuli_CreateFcn(hObject, eventdata, handles)
    handles.parameters.trials.random_stimuli = 0;
guidata(hObject, handles);

%Checkboxes to set which task checks are active for the block to be run
%these don't need functions as they will simply be read from and used to
%create a vector of requirements in Generate()
function Centered_check_Callback(hObject, eventdata, handles)
function Fixation_check_Callback(hObject, eventdata, handles)
function Bidding_check_Callback(hObject, eventdata, handles)
function Finalised_check_Callback(hObject, eventdata, handles)
function Targeted_check_Callback(hObject, eventdata, handles)

%Functions to modify the task in ways that we don't want to when recording
%but are useful elsewhere
%testmode allows the task to be run without hardware so is good for
%debugging away from 313
%listenmode allows the task to listen to interactions with the GUI whilst
%running the task. This can fuck up the timing a bit but is useful when
%doing behavioural training (e.g. when headposting and want to give free
%juice)
%allows for the task to be run without adequate hardware
function Test_paradigm_Callback(hObject, eventdata, handles)
    clear handles.parameters.modification.testmode
    test_button_state = get(hObject,'Value');
    if test_button_state == get(hObject,'Max')
        set(handles.Test_paradigm,'string','Test ON','enable','on','BackgroundColor','green');
        handles.parameters.modification.testmode = 1;
        set(handles.Centered_check,'value',0);
        %give a warning message
        display('Testing mode on- hardware not taken into account');
    elseif test_button_state == get(hObject,'Min')
        set(handles.Test_paradigm,'string','Test OFF','enable','on','BackgroundColor','red');
        handles.parameters.modification.testmode = 0;
        display('Testing mode off');
    end
guidata(hObject, handles);
function Test_paradigm_CreateFcn(hObject, eventdata, handles)
    handles.parameters.modification.testmode = 0;
guidata(hObject, handles);
%allows the GUI to interrupt the normal running of the task
function Listen_mode_Callback(hObject, eventdata, handles)
    clear handles.parameters.modification.listenmode
    listen_button_state = get(hObject,'Value');
    if listen_button_state == get(hObject,'Max')
        set(handles.Listen_mode,'string','Test ON','enable','on','BackgroundColor','green');
        handles.parameters.modification.listenmode = 1;
        set(handles.Centered_check,'value',0);
        %give a warning message
        display('Listening mode on- this will affect task timings');
    elseif listen_button_state == get(hObject,'Min')
        set(handles.Listen_mode,'string','Test OFF','enable','on','BackgroundColor','red');
        handles.parameters.modification.listenmode = 0;
        display('Listening mode off');
    end
guidata(hObject, handles);
function Listen_mode_CreateFcn(hObject, eventdata, handles)
    handles.parameters.modification.listenmode = 0;
guidata(hObject, handles);


function Remove_fractals_Callback(hObject, eventdata, handles)
    clear handles.modifiers.fractals.no_fractals;
    showing_fractals = get(handles.Remove_fractals, 'Value');
    handles.modifiers.fractals.no_fractals = showing_fractals;
    %display a message
    if showing_fractals == get(hObject,'Min')
        display('no longer showing fractals- trials will not be rewarded with juice');
    elseif showing_fractals == get(hObject,'Max')
        display('fractals will be shown and rewarded again');
    end
guidata(hObject, handles);
function Remove_fractals_CreateFcn(hObject, eventdata, handles)
    handles.modifiers.fractals.no_fractals = 0;
guidata(hObject, handles);
function Fractal_numbers_Callback(hObject, eventdata, handles)
    %set the number of fractals to load via string
    clear handles.modifiers.fractals.number_of_fractals;
    fractal_numbers = str2num(get(handles.Fractal_numbers, 'String'));
    handles.modifiers.fractals.number_of_fractals = fractal_numbers;
    display(['looking for first', num2str(handles.modifiers.fractals.number_of_fractals), ' fractals in image folder']);
guidata(hObject, handles);
function Fractal_numbers_CreateFcn(hObject, eventdata, handles)
    %set the default to 3
    handles.modifiers.fractals.number_of_fractals = 3;
guidata(hObject, handles);
function Fractal_names_Callback(hObject, eventdata, handles)
    %set the string at the start of the fractal files via string
    clear handles.modifiers.fractals.fractal_string;
    fractal_string = get(handles.Fractal_names, 'String');
    handles.modifiers.fractals.fractal_string = num2str(fractal_string);
    display(['looking for fractal files beginning with', handles.modifiers.fractals.fractal_string, ' in image folder']);
guidata(hObject, handles);
function Fractal_names_CreateFcn(hObject, eventdata, handles)
    %set the default to 3
    handles.modifiers.fractals.fractal_string = 'RL';
guidata(hObject, handles);

function frac_mag_1_Callback(hObject, eventdata, handles)
    fractals_vector = [str2num(get(handles.frac_mag_1, 'String')),str2num(get(handles.frac_mag_2, 'String')),str2num(get(handles.frac_mag_3, 'String')),...
        str2num(get(handles.frac_mag_4, 'String')),str2num(get(handles.frac_mag_5, 'String')),str2num(get(handles.frac_mag_6, 'String'))];
    display(['currently using ', num2str(fractals_vector(1:handles.modifiers.fractals.number_of_fractals)), 'ml of juice']);
guidata(hObject, handles);
function frac_mag_1_CreateFcn(hObject, eventdata, handles)
    frac_mag_1 = 0.15;
guidata(hObject, handles);
function frac_mag_2_Callback(hObject, eventdata, handles)
    fractals_vector = [num2str(get(handles.frac_mag_1, 'Value')),num2str(get(handles.frac_mag_2, 'Value')),num2str(get(handles.frac_mag_3, 'Value')),...
        num2str(get(handles.frac_mag_4, 'Value')),num2str(get(handles.frac_mag_5, 'Value')),num2str(get(handles.frac_mag_6, 'Value'))];
    display(['currently using ', num2str(fractals_vector(1:handles.modifiers.fractals.number_of_fractals)), 'ml of juice']);
guidata(hObject, handles);
function frac_mag_2_CreateFcn(hObject, eventdata, handles)
    frac_mag_2 = 0.45;
guidata(hObject, handles);
function frac_mag_3_Callback(hObject, eventdata, handles)
    fractals_vector = [num2str(get(handles.frac_mag_1, 'Value')),num2str(get(handles.frac_mag_2, 'Value')),num2str(get(handles.frac_mag_3, 'Value')),...
        num2str(get(handles.frac_mag_4, 'Value')),num2str(get(handles.frac_mag_5, 'Value')),num2str(get(handles.frac_mag_6, 'Value'))];
    display(['currently using ', num2str(fractals_vector(1:handles.modifiers.fractals.number_of_fractals)), 'ml of juice']);
guidata(hObject, handles);
function frac_mag_3_CreateFcn(hObject, eventdata, handles)
    frac_mag_3 = 0.75;
guidata(hObject, handles);
function frac_mag_4_Callback(hObject, eventdata, handles)
    fractals_vector = [num2str(get(handles.frac_mag_1, 'Value')),num2str(get(handles.frac_mag_2, 'Value')),num2str(get(handles.frac_mag_3, 'Value')),...
        num2str(get(handles.frac_mag_4, 'Value')),num2str(get(handles.frac_mag_5, 'Value')),num2str(get(handles.frac_mag_6, 'Value'))];
    display(['currently using ', num2str(fractals_vector(1:handles.modifiers.fractals.number_of_fractals)), 'ml of juice']);
guidata(hObject, handles);
function frac_mag_4_CreateFcn(hObject, eventdata, handles)
    frac_mag_4 = 0.99;
guidata(hObject, handles);
function frac_mag_5_Callback(hObject, eventdata, handles)
    fractals_vector = [num2str(get(handles.frac_mag_1, 'Value')),num2str(get(handles.frac_mag_2, 'Value')),num2str(get(handles.frac_mag_3, 'Value')),...
        num2str(get(handles.frac_mag_4, 'Value')),num2str(get(handles.frac_mag_5, 'Value')),num2str(get(handles.frac_mag_6, 'Value'))];
    display(['currently using ', num2str(fractals_vector(1:handles.modifiers.fractals.number_of_fractals)), 'ml of juice']);
guidata(hObject, handles);
function frac_mag_5_CreateFcn(hObject, eventdata, handles)
    frac_mag_5 = 0.99;
guidata(hObject, handles);
function frac_mag_6_Callback(hObject, eventdata, handles)
    fractals_vector = [num2str(get(handles.frac_mag_1, 'Value')),num2str(get(handles.frac_mag_2, 'Value')),num2str(get(handles.frac_mag_3, 'Value')),...
        num2str(get(handles.frac_mag_4, 'Value')),num2str(get(handles.frac_mag_5, 'Value')),num2str(get(handles.frac_mag_6, 'Value'))];
    display(['currently using ', num2str(fractals_vector(1:handles.modifiers.fractals.number_of_fractals)), 'ml of juice']);
guidata(hObject, handles);
function frac_mag_6_CreateFcn(hObject, eventdata, handles)
    frac_mag_1 = 0.99;
guidata(hObject, handles);


%%%%DELETE EVERYTHING BELOW THIS LINE%%%%


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
    
    %update the GUI with the calculated max trials
    %this can be edited after
    set(handles.Total_trials,'String', num2str(handles.parameters.max_trials));
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
    while get(hObject,'Value') && handles.results.experiment_summary.correct < handles.parameters.max_trials
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
        if strcmp(handles.parameters.task, 'BC')
            set(handles.text57, 'String', handles.results.experiment_summary.left);
            set(handles.text58, 'String', handles.results.experiment_summary.right);
        end
       
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
test_data = peekdata(joystick,50);
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
%assign this to the workspace to use later on
assignin('base', 'joystick_bias_x', [handles.hardware.inputs.settings.joystick_x_bias]);
assignin('base', 'joystick_bias_y', [handles.hardware.inputs.settings.joystick_y_bias]);
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
handles.hardware.inputs.settings.joystick_sensitivity = str2num('0.05');
guidata(hObject, handles);

%set the joystick scalar (how fast it makes the bar travel)
function Joystick_scalar_Callback(hObject, eventdata, handles)
clear handles.hardware.inputs.settings.joystick_scalar;
handles.hardware.inputs.settings.joystick_scalar = str2num(get(handles.Joystick_scalar,'String'));
display('set new joystick scalar');
guidata(hObject, handles);
%default is 50
function Joystick_scalar_CreateFcn(hObject, eventdata, handles)
handles.hardware.inputs.settings.joystick_scalar = str2num('50');
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
display(strmatch(handles.parameters.participants.primate, handles.parameters.participants.primate_table.Name) > 0);

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
    %display(handles.Test_paradigm.Value);
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
    %display(handles.Test_paradigm.Value);
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
    %display(handles.Test_paradigm.Value);
elseif button_state == get(hObject,'Min')
	set(handles.Solenoid_calibration,'string','','enable','on','BackgroundColor','red');
    handles.hardware.outputs.settings.calibration = 0;
end
guidata(hObject, handles);
function Solenoid_calibration_CreateFcn(hObject, eventdata, handles)
handles.hardware.outputs.settings.calibration = 0;
guidata(hObject, handles);









%%BUNDLE STUFF%%
function Bundles_width_Callback(hObject, eventdata, handles)
clear handles.parameters.binary_choice.bundle_width
handles.parameters.binary_choice.bundle_width = str2num(get(handles.Bundles_width,'String'));
display(handles.parameters.binary_choice.bundle_width);
guidata(hObject, handles);
function Bundles_width_CreateFcn(hObject, eventdata, handles)
handles.parameters.binary_choice.bundle_width = 42;
guidata(hObject, handles);







%adds a bias to the joystick
%makes either side move between 0-10x faster for the same effort
function Added_bias_Callback(hObject, eventdata, handles)
clear handles.hardware.inputs.settings.added_bias;
slider_state = get(hObject,'Value');
handles.hardware.inputs.settings.added_bias = sqrt(1 / (exp(1)^(slider_state-0.5)^4.605));
display(strcat('left side now ', num2str(handles.hardware.inputs.settings.added_bias ^ 2), ' times as strong'));
guidata(hObject, handles);
%set default to 1x (i.e. both sides are equal)
function Added_bias_CreateFcn(hObject, eventdata, handles)
handles.hardware.inputs.settings.added_bias = 1;
guidata(hObject, handles);
function Reset_bias_Callback(hObject, eventdata, handles)
clear handles.hardware.inputs.settings.added_bias;
handles.hardware.inputs.settings.added_bias = 1;
display('both directions set to equal strength');
set(handles.Added_bias,'Value', 0.5);















function Budget_tap_Callback(hObject, eventdata, handles)
% hObject    handle to Budget_tap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Budget_tap as text
%        str2double(get(hObject,'String')) returns contents of Budget_tap as a double


% --- Executes during object creation, after setting all properties.
function Budget_tap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Budget_tap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Reward_tap_Callback(hObject, eventdata, handles)
% hObject    handle to Reward_tap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Reward_tap as text
%        str2double(get(hObject,'String')) returns contents of Reward_tap as a double


% --- Executes during object creation, after setting all properties.
function Reward_tap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Reward_tap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





%function to reinsert already tested values for the joystick bias
function Reinsert_bias_Callback(hObject, eventdata, handles)
bias_x = evalin('base', 'joystick_bias_x');
bias_y = evalin('base', 'joystick_bias_y');
handles.hardware.inputs.settings.joystick_y_bias = str2num(bias_y);
handles.hardware.inputs.settings.joystick_x_bias = str2num(bias_x);
set(handles.Set_Y_Bias,'String', num2str(handles.hardware.inputs.settings.joystick_y_bias));
set(handles.Set_X_Bias,'String', num2str(handles.hardware.inputs.settings.joystick_x_bias));
display('reinserted joystick bias from workspace');
guidata(hObject, handles);



% --- Executes on button press in Free_juice.
function Free_juice_Callback(hObject, eventdata, handles)
% hObject    handle to Free_juice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Free_juice







