# PriMAT_BDM
### MATLAB rewrite of the primate BDM task

- version 1.2.0 
- 2nd November 2017
- written by Robert Hickman in the lab of Prof. Wolfram Schultz

contact: robwhickman@gmail.com

A rewrite of the Becker-DeGroot-Marshack auction task in Matlab's PsychToolBox

## Set Up
:construction: :construction: :construction:

## Running

## MATisse
The task runs through the MATLAB Interactive Session Software Environment (MATisse), a GUI built in MATLAB that allows the various scripts to be run without having to look at any code necessarily. Both the GUI (the .fig file) and the code running the processes behind this are found in the MATisse folder in the main directory.

### running the task through MATisse

The GUI has four main buttons (blue) which actually set everything up and run the task. These are helpfully labelled 'Set', 'Generate', 'Run' and 'Save' and do exactly what they say.
 - Set: prompts the user to select a folder to run the task from, and a folder to save the final output to. At the end, the working directory is changed to the task folder so only the Generate and Run scripts in this will be selected
 - Generate: **write**
 - Run: **write** n.b. pressing the Run button during the task will pause which can then be restarted later, though I'd reccommend not doing this if possible as it isn't properly configured yet **to be fixed**
 - Save: saves the results array to the folder specified in Set. This will be saved as a concatenation of the system datetime, the experimenter, the monkey tested and the name of the task folder

### calibrating the task through MATisse

It also contains various other buttons/ boxes. The two above the task buttons are used to specify which experimenter is running the task and which monkey is being tested. The values will be updated (and a confirmation message printer to the console) upon clicking away from the box. These two strings are used to name the results upon saving the data.

The two buttons in the bottom left of the GUI are 'Clear' and 'Exit'. Clear will reset matlab to a fresh session and reopen MATisse and is useful if there is some configuration error (e.g. doubly assigning some variable that hasn't been fixed yet **to be fixed**). Exit is used to close all open screens, but will not clear the console. (I think Exit throws an error **to be fixed**)

The three Test buttons are 'Test', 'Test Joystick' and 'Test Solenoid. 
'Test' will activate test mode, which allows the task to be run with just a keyboard and mouse (instead of looking for external devices like a joystick or solenoid). 
'Test Joystick' will look for a joystick and then return the mean x and y values. This is useful to run before experiments to account for any bias in the joystick which can cause the bid to change without monkey input. Any bias can be corrected using the input boxes above the button.
'Test Solenoid' does the same but for the solenoid and will output a small amount of juice to check that MATisse is talking to the solenoids properly.

## Objects
The task sorts almost all the objects generated into four categories:
 - Parameters: the task parameters. The main subcategories are the timings of each epoch and the 
 - Stimuli: the properties of the stimuli to be run in PTB, e.g. the fractals, the bidspace, etc.
 - Devices: the inputs/outputs used to interact with the task. Either the mouse/keyboard or the joystick + the solenoid to release the juice
 - Results: the results of the task to be saved

MATisse will also generate an input table of combinations of fractal values, reward types, and **finish writing**

