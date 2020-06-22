% create figure and panel on it
startx = 200;
starty = 200;
width = 1200;
height =600;

close all;
clear h;

graphics_toolkit qt
function wav = tts_process(h, str)
  %str
  lines = strsplit(str, ".\n")
  %printf("s = %s", lines{1});
   for i = 1:length(lines)
     wav = invoke(h.tts.SV,'Speak',lines{i})
     
         % Convert uint8 to double precision;
  %  wav = reshape(double(invoke(h.tts.MS,'GetData')),2,[])';
  %  wav = (wav(:,2)*256+wav(:,1))/32768;
  %  wav(wav >= 1) = wav(wav >= 1)-2;
   % delete(h.tts.MS);
   % clear h.tts.MS;
    
   %  plot(wav);
   end
endfunction

function update_plot (obj, init = false)

  ## gcbo holds the handle of the control
  h = guidata (obj);
  replot = false;
  recalc = false;
  switch (gcbo)
    case {h.synth_pushbutton}
      v = get (h.text_in_edit, "string");
      tts_process(h, v);
       
    case {h.text_in_edit}
      % printf("enter text in");
    case {h.volume_slider}
      volume = get(h.volume_slider, "value");
      h.tts.SV.volume = ceil(volume*100);
    case {h.pitch_list}
      pitch = get (h.pitch_list, "value");
      h.tts.SV.Rate = h.pitches(pitch);
  endswitch
  
endfunction

function obj = setup_tts()
if ~ispc, error('Microsoft Win32 SAPI is required.'); end
  
  obj.SV = actxserver('SAPI.SpVoice');
  obj.TK = invoke(obj.SV,'GetVoices');

  obj.fs = 48000;
  
 %  obj.MS = actxserver('SAPI.SpMemoryStream');
 %  obj.MS.Format.Type = sprintf('SAFT%dkHz16BitMono',fix(obj.fs/1000));
 %  obj.SV.AudioOutputStream = obj.MS;  

endfunction


h.tts = setup_tts();

h.pitches = [3, 6, 1];

figure(1, 'position',[startx,starty,width,height]);
p = uipanel ("title", "User Input", "position", [.025 .025 0.97 .6]);

% add two buttons to the panel
h.plot_title_label = uicontrol ("parent", p, "style", "text",
                                "units", "normalized",
                                "string", "Input Text",
                                "horizontalalignment", "left",
                                "position", [0.05 0.85 0.35 0.08]);

h.text_in_edit = uicontrol ("parent", p, "style", "edit",
                               "units", "normalized",
                               "string", " one two three. four five six. seven eigth nine. end",
                               "callback", @update_plot,
                               'backgroundcolor', 'white',
                               'horizontalalignment', 'left',
                               'verticalalignment', 'top',
                               "position", [0.05 0.50 0.9 0.35]);
                               
## Synthesis command 
h.synth_pushbutton = uicontrol ("parent", p, "style", "pushbutton",
                                "units", "normalized",
                                "string", "Synthesize",
                                "callback", @update_plot,
                                "position", [0.6 0.01 0.35 0.2]);

## volume label
h.volume_label = uicontrol ("parent", p, "style", "text",
                           "units", "normalized",
                           "string", "Volume:",
                           "horizontalalignment", "left",
                           "position", [0.6 0.4 0.35 0.09]);

h.volume_slider = uicontrol ("parent", p, "style", "slider",
                            "units", "normalized",
                            "string", "slider",
                            "callback", @update_plot,
                            "value", 0.4,
                            "position", [0.6 0.31 0.35 0.1]);

## Pitch label
h.pitch_label = uicontrol ("parent", p, "style", "text",
                               "units", "normalized",
                               "string", "Pitch:",
                               "horizontalalignment", "left",
                               "position", [0.05 0.4 0.35 0.09]);
                               % [0.05 0.32 0.35 0.08]


h.pitch_list = uicontrol ("parent", p, "style", "listbox",
                                "units", "normalized",
                                "string", { 
                                           "Normal",
                                           "High",
                                           "Low"},
                                "callback", @update_plot,
                                "position", [0.05 0.22 0.4 0.2]);

                               
pan_figure = uipanel ("title", "Plot", "position", [.025 .625 0.97 .35]);
%h.time_plot = figure("parent", pan_figure);

h.ax = axes ("parent", pan_figure, "position", [0.05 0.1 0.9 0.85]);

h.init = 1;

h.val = 10;
    
guidata (gcf, h)
update_plot (gcf, true);
    