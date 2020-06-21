MATLAB/OCTAVE GUI for Text to Speech 
====================================

This script uses windows TTS COM SAPI.SpVoice which is available for both MATLAB and OCTAVE. 
The test to be coverted into speech is enetered in the UI text box. The Volume and rendering 
Pace can selected in GUI. The output of text to speech is rendered in the PC through the default speaker. 


Running with OCTAVE
=================
1. Install OCTAVE. 

download the windows installer from https://www.gnu.org/software/octave/ and install. Version used 5.1.0

2. Install OCTAVE windows COM package 
launch OCTAVE and type 
>> pkg install -forge  windows

3. Load package
>> pkg load windows

4. Run the script 
>> vsynth

5. Run Synthesiser 
Enter the text to be convereted to speech in the GUI text box. Press Synthesize button. Select the Pitch / Pace and the volume.


Last updated on 20-Jun-2020 by @mchalil

 
 

   