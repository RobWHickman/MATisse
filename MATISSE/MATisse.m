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
    %load the table containing the monkeys we run
    load ../../misc/monkey_table.mat
    handles.parameters.participants.primate_table = monkeys;
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

%Function to run the task
%comprised of two buttons- Generate, Run
%Generate creates the order and stimuli and finds the hardware, Run runs
%each trial in a while loop
%function to set up as much as possible before hitting run
%anything really intensive in the Run function is done before any stimulus
%presentation anyway, but best to separate out as much as possible before
%even that
function Gen_button_Callback(hObject, eventdata, handles)
    if isfield(handles.parameters.directories,'save')
        disp('Generating Experiment...')
        %update the task checks with the values of the checkboxes
        requirement_vector = [get(handles.Fixation_check, 'Value'),...
            get(handles.Centered_check, 'Value'),...
            get(handles.Bidding_check, 'Value'),...
            get(handles.Finalised_check, 'Value'),...
            get(handles.Targeted_check, 'Value')];
        handles.parameters.task_checks.requirements = requirement_vector';
        %generate the task
        [handles.parameters, handles.hardware, handles.stimuli, handles.task_window] =  matisse_generate(handles.parameters, handles.hardware, handles.stimuli, handles.modifiers);
        %update the GUI with the calculated max trials
        %this can be edited after
        set(handles.Total_trials,'String', num2str(handles.parameters.trials.max_trials));
        %confirm that everything has loaded
        disp('everything generated as expected')
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
    disp('running!');
    if get(hObject,'Value')
        set(handles.Run_button,'string','running...','enable','on','BackgroundColor','[1, 0, 1]');
        while get(hObject,'Value') && handles.results.trials.correct < handles.parameters.trials.max_trials
            [handles.results, handles.parameters] = Run(handles.parameters, handles.stimuli, handles.hardware, handles.modifiers, handles.results, handles.task_window);
            %save the data about the experimental set up at the start of
            %the task
            if handles.parameters.trials.total_trials < 1
                handles.results = assign_experiment_metadata(handles.parameters, handles.stimuli, handles.hardware, handles.results);
            end
            handles.parameters.total_trials = handles.parameters.total_trials + 1;
            disp('trial number:');
            %the trials are zero indexed so add one
            disp(handles.parameters.trials.total_trials + 1);
            %save the results and parameters that came out of the last
            %trial
            guidata(hObject, handles);
            %update the graph
            axes(handles.Bidhistory_axes);
            bar(handles.results.experiment_summary.means);
            %update the text
            set(handles.total_text, 'String', handles.parameters.total_trials);
            set(handles.correct_text, 'String', handles.results.experiment_summary.correct);
            set(handles.error_text, 'String', handles.results.experiment_summary.error);
            set(handles.percent_text, 'String', handles.results.experiment_summary.percent_correct);
            set(handles.rewarded_text, 'String', handles.results.experiment_summary.rewarded);
            set(handles.unrewarded_text, 'String', handles.results.experiment_summary.not_rewarded);
            set(handles.water_text, 'String', handles.results.experiment_summary.total_budget);
            set(handles.juice_text, 'String', handles.results.experiment_summary.total_reward);
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

%Functions to quit the task
%most important is to save the data 
%quick function that saves the output from the experiment
function Save_button_Callback(hObject, eventdata, handles)
    save_data(handles.parameters, handles.results);
    disp('data saved!');
%small function to clear everything and restart MATisse
function Clear_button_Callback(hObject, eventdata, handles)
    clear_all();
    %quits modig
function Exit_button_Callback(hObject, eventdata, handles)
    %close stuff
    close all;
    sca;
   
%Functions to set the involvement of monkey/human in the task and to Set
%the task to be run
%will be used to set what the output is saved and also can be used
%to set defaults-e.g. with which taps to use
function Set_experimenter_Callback(hObject, eventdata, handles)
    clear handles.parameters.participants.experimenter;
    handles.parameters.participants.experimenter = get(handles.Set_experimenter,'String');
    %display the new experimenter upon enter
    disp(strcat('Experimenter Changed to: ', handles.parameters.participants.experimenter))
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
    disp(strcat('Primate Changed to: ', handles.parameters.participants.primate))
    if ~any(strmatch(handles.parameters.participants.primate, handles.parameters.participants.primate_table.Name))
        disp('Could not find monkeys name in table- are you sure it has been typed correctly?');
    end
guidata(hObject, handles);
%set the default
function Set_primate_CreateFcn(hObject, eventdata, handles)
    handles.parameters.participants.primate = 'some_monkey';
guidata(hObject, handles);
%set the task up using these parameters
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

%function which determines which file (if not the default
%interval_times.mat) should set the timings of the epochs
function Timing_filestring_Callback(hObject, eventdata, handles)
    timing_filestring = get(handles.Timing_filestring,'String');
    handles.parameters.timing.load_filestring = timing_filestring;
    %throw an error if the timing file isn't found in the current directory
    assert(exist(fullfile(cd, string), 'file') == 2, '!timing file not found in current directory!');
guidata(hObject, handles);    
function Timing_filestring_CreateFcn(hObject, eventdata, handles)
    handles.parameters.timing.load_filestring = missing;
guidata(hObject, handles);    

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
    clear handles.parameters.break.testmode
    test_button_state = get(hObject,'Value');
    if test_button_state == get(hObject,'Max')
        set(handles.Test_paradigm,'string','Test ON','enable','on','BackgroundColor','green');
        handles.parameters.break.testmode = 1;
        set(handles.Centered_check,'value',0);
        %give a warning message
        disp('Testing mode on- hardware not taken into account');
    elseif test_button_state == get(hObject,'Min')
        set(handles.Test_paradigm,'string','Test OFF','enable','on','BackgroundColor','red');
        handles.parameters.break.testmode = 0;
        disp('Testing mode off');
    end
guidata(hObject, handles);
function Test_paradigm_CreateFcn(hObject, eventdata, handles)
    handles.parameters.break.testmode = 0;
guidata(hObject, handles);
%allows the GUI to interrupt the normal running of the task
function Listen_mode_Callback(hObject, eventdata, handles)
    clear handles.parameters.break.listenmode
    listen_button_state = get(hObject,'Value');
    if listen_button_state == get(hObject,'Max')
        set(handles.Listen_mode,'string','Test ON','enable','on','BackgroundColor','green');
        handles.parameters.break.listenmode = 1;
        set(handles.Centered_check,'value',0);
        %give a warning message
        disp('Listening mode on- this will affect task timings');
    elseif listen_button_state == get(hObject,'Min')
        set(handles.Listen_mode,'string','Test OFF','enable','on','BackgroundColor','red');
        handles.parameters.break.listenmode = 0;
        disp('Listening mode off');
    end
guidata(hObject, handles);
function Listen_mode_CreateFcn(hObject, eventdata, handles)
    handles.parameters.break.listenmode = 0;
guidata(hObject, handles);

%Functions to set whether or not 'rewards' (i.e. contrasted to the 'budget'
%are present and how fractals indicating these rewards should be loaded and
%valued
%remove all fractals (and therefore rewards) from the block
%set the number of distinct rewards (the number of different fractal files
%to load) that can be bid for
function Fractal_numbers_Callback(hObject, eventdata, handles)
    %set the number of fractals to load via string
    clear handles.modifiers.fractals.number;
    fractal_numbers = str2num(get(handles.Fractal_numbers, 'String'));
    handles.modifiers.fractals.number = fractal_numbers;
    disp(['looking for first', num2str(handles.modifiers.fractals.number), ' fractals in image folder']);
    %update the magnitude vector
    handles.modifiers.fractals.magnitude_vector = fractals_vector(1:handles.modifiers.fractals.number);
guidata(hObject, handles);
function Fractal_numbers_CreateFcn(hObject, eventdata, handles)
    %set the default to 3
    handles.modifiers.fractals.number = 3;
guidata(hObject, handles);
%set the names of the fractals to load (looks at the beginning of the
%filename which should be 'R[a-z]'
function Fractal_names_Callback(hObject, eventdata, handles)
    %set the string at the start of the fractal files via string
    clear handles.modifiers.fractals.string;
    fractal_string = get(handles.Fractal_names, 'String');
    handles.modifiers.fractals.string = [num2str(fractal_string), '*.jpg'];
    disp(['looking for fractal files beginning with ', handles.modifiers.fractals.string, ' in image folder']);
guidata(hObject, handles);
function Fractal_names_CreateFcn(hObject, eventdata, handles)
    %set the default to 3
    handles.modifiers.fractals.string = 'RL*.jpg';
guidata(hObject, handles);
%functions to set the value in ml of each fractal
function frac_mag_1_Callback(hObject, eventdata, handles)
    clear handles.modifiers.fractals.fractal_magnitudes
    %get all the fractal values
    fractals_vector = [str2num(get(handles.frac_mag_1, 'String')),str2num(get(handles.frac_mag_2, 'String')),str2num(get(handles.frac_mag_3, 'String')),...
        str2num(get(handles.frac_mag_4, 'String')),str2num(get(handles.frac_mag_5, 'String')),str2num(get(handles.frac_mag_6, 'String'))];
    %display the subset of the vector that is being used
    disp(['currently using ', num2str(fractals_vector(1:handles.modifiers.fractals.number_of_fractals)), 'ml of juice']);
    handles.modifiers.fractals.magnitude_vector = fractals_vector(1:handles.modifiers.fractals.number);
guidata(hObject, handles);
function frac_mag_1_CreateFcn(hObject, eventdata, handles)
    %set defaults for the magnitudes (only using first 3 in base)
    frac_mag_1 = 0.15;
guidata(hObject, handles);
function frac_mag_2_Callback(hObject, eventdata, handles)
    clear handles.modifiers.fractals.fractal_magnitudes
    %get all the fractal values
    fractals_vector = [str2num(get(handles.frac_mag_1, 'String')),str2num(get(handles.frac_mag_2, 'String')),str2num(get(handles.frac_mag_3, 'String')),...
        str2num(get(handles.frac_mag_4, 'String')),str2num(get(handles.frac_mag_5, 'String')),str2num(get(handles.frac_mag_6, 'String'))];
    %display the subset of the vector that is being used
    disp(['currently using ', num2str(fractals_vector(1:handles.modifiers.fractals.number_of_fractals)), 'ml of juice']);
    handles.modifiers.fractals.magnitude_vector = fractals_vector(1:handles.modifiers.fractals.number);
guidata(hObject, handles);
function frac_mag_2_CreateFcn(hObject, eventdata, handles)
    frac_mag_2 = 0.45;
guidata(hObject, handles);
function frac_mag_3_Callback(hObject, eventdata, handles)
    clear handles.modifiers.fractals.fractal_magnitudes
    %get all the fractal values
    fractals_vector = [str2num(get(handles.frac_mag_1, 'String')),str2num(get(handles.frac_mag_2, 'String')),str2num(get(handles.frac_mag_3, 'String')),...
        str2num(get(handles.frac_mag_4, 'String')),str2num(get(handles.frac_mag_5, 'String')),str2num(get(handles.frac_mag_6, 'String'))];
    %display the subset of the vector that is being used
    disp(['currently using ', num2str(fractals_vector(1:handles.modifiers.fractals.number_of_fractals)), 'ml of juice']);
    handles.modifiers.fractals.magnitude_vector = fractals_vector(1:handles.modifiers.fractals.number);
guidata(hObject, handles);
function frac_mag_3_CreateFcn(hObject, eventdata, handles)
    frac_mag_3 = 0.75;
guidata(hObject, handles);
function frac_mag_4_Callback(hObject, eventdata, handles)
    clear handles.modifiers.fractals.fractal_magnitudes
    %get all the fractal values
    fractals_vector = [str2num(get(handles.frac_mag_1, 'String')),str2num(get(handles.frac_mag_2, 'String')),str2num(get(handles.frac_mag_3, 'String')),...
        str2num(get(handles.frac_mag_4, 'String')),str2num(get(handles.frac_mag_5, 'String')),str2num(get(handles.frac_mag_6, 'String'))];
    %display the subset of the vector that is being used
    disp(['currently using ', num2str(fractals_vector(1:handles.modifiers.fractals.number_of_fractals)), 'ml of juice']);
    handles.modifiers.fractals.magnitude_vector = fractals_vector(1:handles.modifiers.fractals.number);
guidata(hObject, handles);
function frac_mag_4_CreateFcn(hObject, eventdata, handles)
    frac_mag_4 = 0.99;
guidata(hObject, handles);
function frac_mag_5_Callback(hObject, eventdata, handles)
    clear handles.modifiers.fractals.fractal_magnitudes
    %get all the fractal values
    fractals_vector = [str2num(get(handles.frac_mag_1, 'String')),str2num(get(handles.frac_mag_2, 'String')),str2num(get(handles.frac_mag_3, 'String')),...
        str2num(get(handles.frac_mag_4, 'String')),str2num(get(handles.frac_mag_5, 'String')),str2num(get(handles.frac_mag_6, 'String'))];
    %display the subset of the vector that is being used
    disp(['currently using ', num2str(fractals_vector(1:handles.modifiers.fractals.number_of_fractals)), 'ml of juice']);
    handles.modifiers.fractals.magnitude_vector = fractals_vector(1:handles.modifiers.fractals.number);
guidata(hObject, handles);
function frac_mag_5_CreateFcn(hObject, eventdata, handles)
    frac_mag_5 = 0.99;
guidata(hObject, handles);
function frac_mag_6_Callback(hObject, eventdata, handles)
    clear handles.modifiers.fractals.fractal_magnitudes
    %get all the fractal values
    fractals_vector = [str2num(get(handles.frac_mag_1, 'String')),str2num(get(handles.frac_mag_2, 'String')),str2num(get(handles.frac_mag_3, 'String')),...
        str2num(get(handles.frac_mag_4, 'String')),str2num(get(handles.frac_mag_5, 'String')),str2num(get(handles.frac_mag_6, 'String'))];
    %display the subset of the vector that is being used
    disp(['currently using ', num2str(fractals_vector(1:handles.modifiers.fractals.number_of_fractals)), 'ml of juice']);
    handles.modifiers.fractals.magnitude_vector = fractals_vector(1:handles.modifiers.fractals.number);
guidata(hObject, handles);
function frac_mag_6_CreateFcn(hObject, eventdata, handles)
    frac_mag_1 = 0.99;
    %set the default vector
    %manual as all the other values haven't been created yet
    handles.modifiers.fractals.magnitude_vector = [0.15, 0.45, 0.75];
guidata(hObject, handles);

%Functions to manipulate the 'budget' (i.e. the water in the bar contrasted
%to the 'reward' fractal for juice)
%the magnitude of the budget (what does the full bar represent in ml)
function Budget_magnitude_Callback(hObject, eventdata, handles)
    clear handles.modifiers.budget.magnitude
    budget_magnitude = get(handles.Budget_magnitude, 'String');
    handles.modifiers.budget.magnitude = str2num(budget_magnitude);
    %display the new magnitude
    disp(['full budget valued at ', budget_magnitude, ' ml of water']);
guidata(hObject, handles);
function Budget_magnitude_CreateFcn(hObject, eventdata, handles)
    handles.modifiers.budget.magnitude = 1.2;
guidata(hObject, handles);
%functions that determine what sort of lines should be placed over the
%budget bar to help the monkeys target their bid to some known amount
function No_lines_CreateFcn(hObject, eventdata, handles)
    handles.modifiers.budget.targeting_lines.type = "none";
guidata(hObject, handles);
function Minor_lines_CreateFcn(hObject, eventdata, handles)
function Major_lines_CreateFcn(hObject, eventdata, handles)
function No_lines_Callback(hObject, eventdata, handles)
    if get(handles.No_lines, 'Value');
        handles.modifiers.budget.targeting_lines.type = "none";
    end
guidata(hObject, handles);
function Minor_lines_Callback(hObject, eventdata, handles)
    if get(handles.Minor_lines, 'Value');
        handles.modifiers.budget.targeting_lines.type = "minor";
    end
guidata(hObject, handles);
function Major_lines_Callback(hObject, eventdata, handles)
    if get(handles.Major_lines, 'Value');
        handles.modifiers.budget.targeting_lines.type = "major";
    end
guidata(hObject, handles);
%the number of divisions of water budget in the bundle (i.e. what the
%bundle water offers values will be). Can also be piped into the budget
function Budget_divisions_Callback(hObject, eventdata, handles)
    clear handles.modifiers.budget.divisions;
    budget_divisions = get(handles.Budget_divisions,'String');
    handles.modifiers.budget.divisions = str2num(budget_divisions);
    %display the number and scale of the divisions
    disp([budget_divisions, ' divisions of the budget bar from ',...
        num2str(handles.modifiers.budget.magnitude/handles.modifiers.budget.divisions),...
        'to ', num2str(handles.modifiers.budget.magnitude), 'ml of water']);
guidata(hObject, handles);
function Budget_divisions_CreateFcn(hObject, eventdata, handles)
    handles.modifiers.budget.divisions = 10;
guidata(hObject, handles);
%should the budget water offer be full, or randomly divided
function Random_budget_Callback(hObject, eventdata, handles)
    clear handles.modifiers.budget.random;
    randomise_budgets = get(handles.Static_targetbox, 'Value');
    handles.modifiers.budget.random = randomise_budgets;
    %if random, budget cannot be pegged
    set(handles.Pegged_budget,'Value', 0);
guidata(hObject, handles);
function Random_budget_CreateFcn(hObject, eventdata, handles)
    handles.modifiers.budget.random = 0;
guidata(hObject, handles);
%should the budget be pegged to the bundle water- i.e. a constant distance
%in value from the bundle water
function Pegged_budget_Callback(hObject, eventdata, handles)
    clear handles.modifiers.budget.pegged;
    peg_budgets = get(handles.Static_targetbox, 'Value');
    handles.modifiers.budget.pegged = peg_budgets;
    %if pegged, budget cannot be random
    set(handles.Random_budget,'Value', 0);
guidata(hObject, handles);
function Pegged_budget_CreateFcn(hObject, eventdata, handles)
    handles.modifiers.budget.pegged = 0;
guidata(hObject, handles);
%if the budget is pegged to the bundle water value, what should the
%difference in value be?
%0 indicates that they will be equal, positive means the budget will be
%less valuable than the bundle and vice versa
function Peg_difference_Callback(hObject, eventdata, handles)
    %only set a budget peg if budgets are meant to be pegged
    if handles.modifiers.budget.pegged
        clear handles.modifiers.budget.peg_difference;
        handles.modifiers.budget.peg_difference = str2num(get(handles.Peg_difference,'String'));
        guidata(hObject, handles);
    %otherwise display a warning message
    else
        disp('Please select "Pegged_budget" first!');
    end
guidata(hObject, handles);
function Peg_difference_CreateFcn(hObject, eventdata, handles)
    handles.modifiers.budget.peg_difference = NaN;
guidata(hObject, handles);
%sets the darkness covering the non-paid out area of water bidspaces to
%make it more like the original task used by Alaa
function Occlusion_darkness_Callback(hObject, eventdata, handles)
    clear handles.modifiers.budget.occlusion_darkness;
    handles.modifiers.budget.occlusion_darkness = 256 * str2num(get(handles.Occlusion_darkness,'String'));
guidata(hObject, handles);
%defaults to zero- transparent
function Occlusion_darkness_CreateFcn(hObject, eventdata, handles)
    handles.modifiers.budget.occlusion_darkness = 256 * 0;
guidata(hObject, handles);
%function that sets the overhang on the budget bar
%determines various aesthetics such as the surrounding highlight box and
%the overhang of target boxes and bidding bars
function Budget_overhang_Callback(hObject, eventdata, handles)
    clear handles.modifiers.budget.overhang;
    overhang = get(handles.Budget_overhang,'String');
    handles.modifiers.budget.occlusion_darkness = str2num(overhang);
guidata(hObject, handles);
function Budget_overhang_CreateFcn(hObject, eventdata, handles)
    handles.modifiers.budget.overhang = 20;
guidata(hObject, handles);

%Functions to define the parameters supplied to a beta distribution to
%determine the computer bids written by Marius
%set as two numbers- alpha and beta via simple string arguments
%need to add in the distribution in Marius' spreadsheet and get it to plot
%to show pdf upon changing
function Alpha_parameter_Callback(hObject, eventdata, handles)
    clear handles.modifiers.distribution.alpha_parameter;
    alpha_value = get(handles.Alpha_parameter, 'String');
    handles.modifiers.distribution.alpha_parameter = str2num(alpha_value);
    %display the new value
    disp(['Alpha parameter set to ', alpha_value]);
guidata(hObject, handles);
function Alpha_parameter_CreateFcn(hObject, eventdata, handles)
    handles.modifiers.distribution.alpha_parameter = 1;
guidata(hObject, handles);
function Beta_parameter_Callback(hObject, eventdata, handles)
    clear handles.modifiers.distribution.beta_parameter;
    beta_value = get(handles.Beta_parameter, 'String');
    handles.modifiers.distribution.beta_parameter = str2num(beta_value);
    %display the new value
    disp(['Beta parameter set to ', beta_value]);
guidata(hObject, handles);
function Beta_parameter_CreateFcn(hObject, eventdata, handles)
    handles.modifiers.distribution.beta_parameter = 1;
guidata(hObject, handles);

%Functions that are specific to certain tasks
%for now just the width for the two binary sides
%sets the width of the bundle sides- how far the bid has to travel to land
%in one of the choices
function Bundles_width_Callback(hObject, eventdata, handles)
    clear handles.modifiers.specific_tasks.binary_choice.bundle_width
    bundle_width = get(handles.Bundles_width,'String');
    %throw a warning if this is greater than 50 (half the screen)
    if bundle_width > 50
        warning('!width is greater than half of the screen!');
    end
    handles.modifiers.specific_tasks.binary_choice.bundle_width = str2num(bundle_width);
    disp(handles.modifiers.specific_tasks.binary_choice.bundle_width);
guidata(hObject, handles);
function Bundles_width_CreateFcn(hObject, eventdata, handles)
    handles.modifiers.specific_tasks.binary_choice.bundle_width = 42;
guidata(hObject, handles);

%set the direction of bidding- which direction the joystick must be moved
%and in which direction it will affect the screen
%these directions should always be the same
function X_axis_bidding_Callback(hObject, eventdata, handles)
    x_dimension_bidding = get(handles.X_axis_bidding, 'Value');
    %if x axis button selected set movement to x axis, else set it to y
    %axis
    if x_dimension_bidding == 1
        handles.hardware.joystick.direction = 'x';
    else
        handles.hardware.joystick.direction = 'y';
    end
guidata(hObject, handles);
function Y_axis_bidding_Callback(hObject, eventdata, handles)
    y_dimension_bidding = get(handles.Y_axis_bidding, 'Value');
    if y_dimension_bidding == 1
        handles.hardware.joystick.direction = 'y';
    else
        handles.hardware.joystick.direction = 'x';
    end
guidata(hObject, handles);
function X_axis_bidding_CreateFcn(hObject, eventdata, handles)
    %default to y axis movement
    handles.hardware.joystick.direction = 'y';
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
    pause(0.1);
    %get the current joystick voltages (when stationary)
    test_data = peekdata(joystick,30);
    test_data_x = test_data(:,1);
    disp('remaining x bias:');
    joy_x   = mean(test_data_x)
    test_data_y = test_data(:,2);
    disp('remaining y bias:');
    joy_y   = mean(test_data_y)
    %automatically update the x and y bias and the gui with these values
    %can be overridden manually after
    set(handles.Set_x_offset,'String', num2str(-joy_x));
    handles.hardware.joystick.bias.x_offset = get(handles.Set_x_offset,'String');
    set(handles.Set_y_offset,'String', num2str(-joy_y));
    handles.hardware.joystick.bias.y_offset = get(handles.Set_y_offset,'String');
    %assign this to the workspace to use later on
    assignin('base', 'joystick_bias_x', [handles.hardware.joystick.bias.x_offset]);
    assignin('base', 'joystick_bias_y', [handles.hardware.joystick.bias.y_offset]);
guidata(hObject, handles);
%function to reinsert already tested values for the joystick bias
function Reinsert_bias_Callback(hObject, eventdata, handles)
    %evaluate in the tested joystick bias
    bias_x = evalin('base', 'joystick_bias_x');
    bias_y = evalin('base', 'joystick_bias_y');
    %set as the joystick bias
    handles.hardware.joystick.bias.y_offset = str2num(bias_y);
    handles.hardware.joystick.bias.x_offset = str2num(bias_x);
    set(handles.Set_y_offset,'String', num2str(handles.hardware.joystick.bias.y_offset));
    set(handles.Set_x_offset,'String', num2str(handles.hardware.joystick.bias.x_offset));
    disp('reinserted joystick bias from workspace');
guidata(hObject, handles);
%adds a bias to the joystick
%makes either side move between 0-10x faster for the same effort
function Manual_bias_Callback(hObject, eventdata, handles)
    clear handles.hardware.joystick.bias.manual_bias;
    slider_state = get(hObject,'Value');
    handles.hardware.joystick.bias.manual_bias = sqrt(1 / (exp(1)^(slider_state-0.5)^4.605));
    %display the difference in strength
    %sqrt as in update_bid_position() one is divided by the manual_bias and
    %the other is multiplied
    disp(strcat('left side now ', num2str(handles.hardware.joystick.bias.manual_bias ^ 2), ' times as strong'));
guidata(hObject, handles);
%set default to 1x (i.e. both sides are equal)
function Manual_bias_CreateFcn(hObject, eventdata, handles)
    handles.hardware.joystick.bias.manual_bias = 1;
guidata(hObject, handles);
function Reset_bias_Callback(hObject, eventdata, handles)
    clear handles.hardware.inputs.settings.manual_bias;
    handles.hardware.joystick.bias.manual_bias = 1;
    disp('both directions set to equal strength');
set(handles.manual_bias,'Value', 0.5);
%edit the bias manually in the GUI
function Set_y_offset_Callback(hObject, eventdata, handles)
    clear handles.hardware.joystick.bias.y_offset;
    handles.hardware.joystick.bias.y_offset = get(handles.Set_y_offset,'String');
    disp('set new joystick Y bias');
guidata(hObject, handles);
function Set_x_offset_Callback(hObject, eventdata, handles)
    clear handles.hardware.joystick.bias.x_offset;
    handles.hardware.joystick.bias.x_offset = get(handles.Set_x_offset,'String');
    disp('set new joystick X bias');
guidata(hObject, handles);
function Set_y_offset_CreateFcn(hObject, eventdata, handles)
%set defalt bias to 0
    handles.hardware.joystick.bias.y_offset = '0';
guidata(hObject, handles);
function Set_x_offset_CreateFcn(hObject, eventdata, handles)
    handles.hardware.joystick.bias.x_offset = '0';
guidata(hObject, handles);
%set the joystick sensitivity- the sensitivity needed to be breached for
%the joystick to move the bid
function Joystick_sensitivty_Callback(hObject, eventdata, handles)
    clear handles.hardware.joystick.sensitivity.movement;
    joystick_sensitivity = get(handles.Joystick_sensitivty,'String');
    handles.hardware.joystick.sensitivity.movement = str2num(joystick_sensitivity);
    disp(['set joystick sensitivity to ', joystick_sensitivity]);
guidata(hObject, handles);
function Joystick_sensitivty_CreateFcn(hObject, eventdata, handles)
    handles.hardware.joystick.sensitivity.movement = str2num('0.05');
guidata(hObject, handles);
%set the centered sensitivity- the sensitivity the monkey must keep the
%joystick movement below to pass a centered check
function Centre_sensitivity_Callback(hObject, eventdata, handles)
    clear handles.hardware.joystick.sensitivity.centered;
    joystick_sensitivity = get(handles.Joystick_sensitivty,'String');
    handles.hardware.joystick.sensitivity.centered = str2num(joystick_sensitivity);
    disp(['set joystick sensitivity to ', joystick_sensitivity]);
guidata(hObject, handles);
function Centre_sensitivity_CreateFcn(hObject, eventdata, handles)
    handles.hardware.joystick.sensitivity.centered = str2num('0.05');
guidata(hObject, handles);
%set the joystick scalar (how fast it makes the bar travel)
%generally around 10 is fast enough for scalar based and 50 for voltage
%based movement
function Joystick_speed_Callback(hObject, eventdata, handles)
    clear handles.hardware.joystick.movement.speed;
    handles.hardware.joystick.movement.speed = str2num(get(handles.Joystick_scalar,'String'));
    disp('set new joystick scalar');
guidata(hObject, handles);
%default is 8- reasonable for scalar based movement
%will be mulitplied by 6 if switch to voltage based movement
function Joystick_speed_CreateFcn(hObject, eventdata, handles)
    handles.hardware.joystick.movement.speed = 8;
guidata(hObject, handles);
%toggle button to decide if the joystick works via a scalar (moves forward
%the same amount each frame) or uses the voltage through the joystick to
%calculate its speed
function Joystick_movement_Callback(hObject, eventdata, handles)
    clear handles.hardware.joystick.movement.scaling;
    button_state = get(hObject,'Value');
    if button_state == get(hObject,'Max')
        set(handles.Joystick_movement,'string','Velocity Joystick','enable','on','BackgroundColor','green');
        handles.hardware.joystick.movement.scaling = 1;
        %multiply the joystick speed by 6 to get a reasonable speed for
        %voltage based movement
        set(handles.Joystick_speed, 'Value', handles.hardware.joystick.movement.speed*6)
    elseif button_state == get(hObject,'Min')
        set(handles.Joystick_movement,'string','Binary Joystick','enable','on','BackgroundColor','red');
        handles.hardware.joystick.movement.scaling = 0;
        %divide the joystick speed by 6 to get a reasonable speed for
        %scaling
        set(handles.Joystick_speed, 'Value', handles.hardware.joystick.movement.speed/6)
    end
guidata(hObject, handles);
%set default to binary
function Joystick_movement_CreateFcn(hObject, eventdata, handles)
    handles.hardware.joystick.movement.scaling = 0;
guidata(hObject, handles);

%Functions to allow the user to specify the monitor to use for the
%experimental task defaults to monitor number 2
function Set_Monitor_Callback(hObject, eventdata, handles)
    clear handles.hardware.screen.number;
    handles.hardware.screen.number = str2num(get(handles.Set_Monitor,'String'));
    disp(strcat('task monitor changed to', num2str(handles.hardware.screen.number)));
guidata(hObject, handles);
function Set_Monitor_CreateFcn(hObject, eventdata, handles)
    handles.hardware.screen.number = 2;
guidata(hObject, handles);

%choose which solenoid to test when calling 'test solenoid'
%in the current set up there are 3 taps
%see release_liquid in IO_Devices
function Select_solenoid_Callback(hObject, eventdata, handles)
    clear handles.hardware.solenoid.calibration.test_tap;
    test_tap = get(handles.Set_Solenoid,'String');
    handles.hardware.solenoid.calibration.test_tap = str2num(test_tap);
    disp(['test solenoid tap changed to', test_tap]);
guidata(hObject, handles);
function Select_solenoid_CreateFcn(hObject, eventdata, handles)
    %set default tap to test to 1
    handles.hardware.solenoid.calibration.test_tap = 1;
guidata(hObject, handles);
%also set the length for the solenoid to open when in test mode
function Solenoid_open_time_Callback(hObject, eventdata, handles)
    clear handles.hardware.solenoid.calibration.open_time;
    open_time = get(handles.Solenoid_open_time,'String');
    handles.hardware.solenoid.calibration.open_time = str2num(open_time);
    disp(['test solenoid opening time changed to', open_time]);
guidata(hObject, handles);
function Solenoid_open_time_CreateFcn(hObject, eventdata, handles)
    %set default tap opening time to 1s
    handles.hardware.solenoid.calibration.open_time = 1;
guidata(hObject, handles);
function Calibrate_solenoid_Callback(hObject, eventdata, handles)
    clear handles.hardware.solenoid.calibration.calibrate;
    button_state = get(hObject,'Value');
    if button_state == get(hObject,'Max')
        set(handles.Solenoid_calibration,'string','','enable','on','BackgroundColor','green');
        handles.hardware.solenoid.calibration.calibrate = 1;
    elseif button_state == get(hObject,'Min')
        set(handles.Solenoid_calibration,'string','','enable','on','BackgroundColor','red');
        handles.hardware.solenoid.calibration.calibrate = 0;
    end
guidata(hObject, handles);
function Calibrate_solenoid_CreateFcn(hObject, eventdata, handles)
    handles.hardware.solenoid.calibration.calibrate = 0;
guidata(hObject, handles);
%test that the solenoids are functional
%will run the solenoid functions from the task
%this will overwrite the results so run it before running the task
function Open_solenoid_Callback(hObject, eventdata, handles)
    if ~isfield(handles, 'results')
        handles.hardware = find_solenoid(handles.hardware);
        if handles.hardware.outputs.settings.calibration == 0
            fake_results = release_liquid('no_parameters', handles.hardware, 'no_results', 'test_tap');
        elseif handles.hardware.outputs.settings.calibration == 1
            fake_results = release_liquid('no_parameters', handles.hardware, 'no_results', 'calibrate');
        else
            disp('illegal solenoid test state');
        end
    else
        disp('results field exists! run test solenoid before running task to prevent overwriting')
    end
    %set the buttons state back to 0 (off)
    set(handles.Solenoid_button,'value',0);
%set which tap contains juice or the budget
%used for when juice is released during the task and when it is given free
function Budget_tap_Callback(hObject, eventdata, handles)
    budget_tap = get(handles.Budget_tap, 'String');
    handles.hardware.solenoid.release.budget_tap = str2num(budget_tap);
    disp(['budget tap set to ', budget_tap]);
guidata(hObject, handles);
function Budget_tap_CreateFcn(hObject, eventdata, handles)
    handles.hardware.solenoid.release.budget_tap = 1;
guidata(hObject, handles);
function Reward_tap_Callback(hObject, eventdata, handles)
    reward_tap = get(handles.Reward_tap, 'String');
    handles.hardware.solenoid.release.reward_tap = str2num(reward_tap);
    disp(['reward tap set to ', reward_tap]);
guidata(hObject, handles);
function Reward_tap_CreateFcn(hObject, eventdata, handles)
    handles.hardware.solenoid.release.reward_tap = 1;
guidata(hObject, handles);
%set whether to give free juice or free water via the GUI
function Free_water_CreateFcn(hObject, eventdata, handles)
    handles.hardware.solenoid.release.free_liquid = 'water';
guidata(hObject, handles);
function Free_water_Callback(hObject, eventdata, handles)
    handles.hardware.solenoid.release.free_liquid = 'water';
guidata(hObject, handles);
function Free_reward_Callback(hObject, eventdata, handles)
    handles.hardware.solenoid.release.free_liquid = 'juice';
guidata(hObject, handles);
function Free_juice_Callback(hObject, eventdata, handles)
%make the button release free juice

%Functions that determine the targeting box presented to the monkey if
%target_check is active
%box can be static or shrink from a starting value as the monkey proceeds
%through the task, and can be filled or just an outline
%should the targetbox be filled or just an outline
function Filled_targetbox_Callback(hObject, eventdata, handles)
    clear handles.stimuli.target_box.filled;
    filled_targetbox = get(handles.Filled_targetbox, 'Value');
    handles.stimuli.target_box.filled = filled_targetbox;
guidata(hObject, handles);
function Filled_targetbox_CreateFcn(hObject, eventdata, handles)
    handles.stimuli.target_box.filled = 1;
guidata(hObject, handles);
%should the targetbox shrink as the monkey gets more results correct
%shrinks to max 10% of the bidspace
%starts at the initial size
function Static_targetbox_Callback(hObject, eventdata, handles)
    clear handles.stimuli.target_box.static;
    static_targetbox = get(handles.Static_targetbox, 'Value');
    handles.stimuli.target_box.static = static_targetbox;
guidata(hObject, handles);
function Static_targetbox_CreateFcn(hObject, eventdata, handles)
    handles.stimuli.target_box.static = 1;
guidata(hObject, handles);
%the size of the static box or the initial (max) size of the shrinking
%target box
function Targetbox_startsize_Callback(hObject, eventdata, handles)
    clear handles.stimuli.target_box.startsize;
    %must be between zero and one
    if  str2num(get(handles.Targetbox_startsize,'String')) > 1 |...
            str2num(get(handles.Targetbox_startsize,'String')) < 0
        disp('Must be a percentage! (between 0 and 1)');
    else
        start_size = get(handles.Targetbox_startsize,'String');
        handles.stimuli.target_box.startsize = str2num(start_size);
        disp(['Targetbox Startsize changed to: ', start_size]);
    end
guidata(hObject, handles);
function Targetbox_startsize_CreateFcn(hObject, eventdata, handles)
    handles.stimuli.target_box.startsize = 0.5;
guidata(hObject, handles);

%Aesthetics
    function Bidhistory_axes_CreateFcn(hObject, eventdata, handles)
    function Bidhistory_axes_DeleteFcn(hObject, eventdata, handles)
    function total_text_CreateFcn(hObject, eventdata, handles)
        handles.results.trials.completed = 0;
        guidata(hObject, handles);
    function correct_text_CreateFcn(hObject, eventdata, handles)
        handles.results.trials.correct = 0;
        guidata(hObject, handles);
    function error_text_CreateFcn(hObject, eventdata, handles)
        handles.results.trials.error = 0;
        guidata(hObject, handles);
    function percent_text_CreateFcn(hObject, eventdata, handles)
    function rewarded_text_CreateFcn(hObject, eventdata, handles)
        handles.results.trials.rewarded = 0;
        guidata(hObject, handles);
    function unrewarded_text_CreateFcn(hObject, eventdata, handles)
        handles.results.trials.unrewarded = 0;
        guidata(hObject, handles);
    function water_text_CreateFcn(hObject, eventdata, handles)
        handles.results.outputs.water = 0;
        guidata(hObject, handles);
    function juice_text_CreateFcn(hObject, eventdata, handles)
        handles.results.outputs.juice = 0;
        guidata(hObject, handles);

function Display_button_Callback(hObject, eventdata, handles)
    display(handles.stimuli.fixation_cross.fixation_cross_info);
function Display_button_CreateFcn(hObject, eventdata, handles)

function Choice_stimuli_Callback(hObject, eventdata, handles)
    clear handles.modifiers.fractals.no_fractals;
    clear handles.modifiers.budgets.no_budgets;
    stimuli_present = get(handles.Choice_stimuli,'Value');
    if ~ismember(2, stimuli_present)
        handles.modifiers.fractals.no_fractals = 1;
        disp('no longer showing fractals- trials will not be rewarded with juice');
    else
        handles.modifiers.fractals.no_fractals = 0;
        disp('fractals will be shown and rewarded again');
    end
    
    if ~ismember(1, stimuli_present)
        handles.modifiers.budgets.no_budgets = 1;
        disp('no longer showing budgets- trials will not be associated with water');
    else
        handles.modifiers.budgets.no_budgets = 0;
        disp('budgets will be shown and paid again');
    end
    
    if ~ismember(1, stimuli_present) && ~ismember(2, stimuli_present)
        disp('no stimuli currently being shown!!');
    end        
guidata(hObject, handles);
function Choice_stimuli_CreateFcn(hObject, eventdata, handles)
    handles.modifiers.fractals.no_fractals = 0;
    handles.modifiers.budgets.no_budgets = 0;
guidata(hObject, handles);


%     function Remove_fractals_Callback(hObject, eventdata, handles)
%     showing_fractals = get(handles.Remove_fractals, 'Value');
%     handles.modifiers.fractals.no_fractals = showing_fractals;
%     %display a message
%     if showing_fractals == get(hObject,'Min')
%         disp('no longer showing fractals- trials will not be rewarded with juice');
%     elseif showing_fractals == get(hObject,'Max')
%         disp('fractals will be shown and rewarded again');
%     end
% guidata(hObject, handles);
% function Remove_fractals_CreateFcn(hObject, eventdata, handles)
%     handles.modifiers.fractals.no_fractals = 0;
% guidata(hObject, handles);
% 
% %remove all budgets (and therefore water)
% function Remove_budgets_Callback(hObject, eventdata, handles)
%     clear handles.modifiers.budgets.no_budgets;
%     showing_budgets = get(handles.Remove_budgets, 'Value');
%     handles.modifiers.budgets.no_budgets = showing_budgets;
%     %display a message
%     if showing_budgets == get(hObject,'Min')
%         disp('no longer showing budgets- trials will not be associated with water');
%     elseif showing_budgets == get(hObject,'Max')
%         disp('budgets will be shown and rewarded again');
%     end
% guidata(hObject, handles);
% function Remove_budgets_CreateFcn(hObject, eventdata, handles)
%     handles.modifiers.budgets.no_budgets = 0;
% guidata(hObject, handles);



function Eyefixation_track_Callback(hObject, eventdata, handles)
    fixate_eyes = get(handles.Eyefixation_track, 'Value');
    if fixate_eyes == 1
        disp('fixation testing using eye tracker');
    else
        disp('fixation testing using joystick only');
    end
    handles.hardware.eye_tracker.fixation = fixate_eyes;
guidata(hObject, handles);
function Eyefixation_track_CreateFcn(hObject, eventdata, handles)
    handles.hardware.eye_tracker.fixation = 0;
guidata(hObject, handles);

function Eyesample_rate_Callback(hObject, eventdata, handles)
    disp('currently not set up!');
guidata(hObject, handles);
function Eyesample_rate_CreateFcn(hObject, eventdata, handles)
    handles.hardware.eyetracker.sample_rate = 200;
guidata(hObject, handles);

function Joysample_rate_Callback(hObject, eventdata, handles)
    disp('currently not set up!');
guidata(hObject, handles);
function Joysample_rate_CreateFcn(hObject, eventdata, handles)
    handles.hardware.joystick.sample_rate = 200;
guidata(hObject, handles);


% --- Executes on button press in Dig_NIbox.
function Dig_NIbox_Callback(hObject, eventdata, handles)
     disp('currently not set up to run digital ni inputs!');
guidata(hObject, handles);

function Dig_NIbox_CreateFcn(hObject, eventdata, handles)
    handles.hardware.ni_inputs = 'analog';
guidata(hObject, handles);

