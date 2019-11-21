# MATisse
### MATLAB rewrite of the primate BDM task

- version 2.1.0 
- 20/3/2019
- written by Robert Hickman in the lab of Prof. Wolfram Schultz

contact: robwhickman@gmail.com

A rewrite of the Becker-DeGroot-Marshack auction task in Matlab's PsychToolBox

Task suite allows for 3 main tasks:

- Free reward 'Pavlovian' task- animal is given free reward unsignalled or after appearance of fractal
- Selection of binary choices between:
  - fractal:fractal for juice rewards
  - budget:budget for water
  - fractal:budget- classical binary choice task
  - fractal + budget: budget - 'BCb' bundle choice task
- Auction tasks where monkey must bid for a fractal and either pays the first or second price

Also optimised for working in coordination with a C++ program to sample National Instruments cards and record electrophysiological data in realtime. Connection via TCP/IP handshake.
