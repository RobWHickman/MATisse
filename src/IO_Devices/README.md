# Functions for generating the BDM task
###edited by Robert Hickman 03/11/2017

The functions in this folder are used to allow the monkey (or coder) to interact with the task. They are set up the input/output devices and also define the rules by which they manipulate the task.

###Input devices
####Debugging
- mouse: the mouse position to define if the participant is 'fixating' on the first epoch cross
- keyboard: up/down arrows for moving the bidding bar

####Primate
- eye camera: **not yet coded in**
- joystick: y axis control of the bidding bar

###Output devices
####Debugging
- screens: display the task
- speakers: produce sound to indicate the remaining budget and reward delivered to the participant

####Primate
- screens: display the task
- solenoid: allow juice to flow to the monkey according to the remaining budget and earned reward
- speakers: **not yet coded- put in to indicate new trial?**


## to do:

- write the functions for the outputs: speakers for task precession/ error and speakers/solenoid for reward
- add eye tracker into finding fixation devices
- add direction checking for joystick/keyboard
- add fixation device checking for fixation devices