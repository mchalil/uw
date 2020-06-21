
close all
clear h

graphics_toolkit qt

function update_plot (obj, init = false)

  ## gcbo holds the handle of the control
  h = guidata (obj);
  replot = false;
  recalc = false;
  switch (gcbo)
    case {h.synth_pushbutton}
      v = get (h.text_in_edit, "string");
 
      invoke(h.tts.SV,'Speak',v); 
       
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

endfunction

h.tts = setup_tts();

h.pitches = [3, 6, 1];

 
## text entry
h.plot_title_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "Input Text",
                                "horizontalalignment", "left",
                                "position", [0.05 0.85 0.35 0.08]);

h.text_in_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", " Enter text here...(edit)",
                               "callback", @update_plot,
                               'backgroundcolor', 'white',
                               'horizontalalignment', 'left',
                               'verticalalignment', 'top',
                               "position", [0.05 0.50 0.9 0.35]);


## Synthesis command 
h.synth_pushbutton = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Synthesize",
                                "callback", @update_plot,
                                "position", [0.6 0.4 0.35 0.09]);

## volume label
h.volume_label = uicontrol ("style", "text",
                           "units", "normalized",
                           "string", "Volume:",
                           "horizontalalignment", "left",
                           "position", [0.05 0.12 0.35 0.08]);

h.volume_slider = uicontrol ("style", "slider",
                            "units", "normalized",
                            "string", "slider",
                            "callback", @update_plot,
                            "value", 0.4,
                            "position", [0.05 0.05 0.4 0.06]);

## Pitch label
h.pitch_label = uicontrol ("style", "text",
                               "units", "normalized",
                               "string", "Pitch:",
                               "horizontalalignment", "left",
                               "position", [0.05 0.4 0.35 0.09]);
                               % [0.05 0.32 0.35 0.08]


h.pitch_list = uicontrol ("style", "listbox",
                                "units", "normalized",
                                "string", { 
                                           "Normal",
                                           "High",
                                           "Low"},
                                "callback", @update_plot,
                                "position", [0.05 0.22 0.4 0.18]);

                                
set (gcf, "color", get(0, "defaultuicontrolbackgroundcolor"))
guidata (gcf, h)
update_plot (gcf, true);

pitch = get (h.pitch_list, "value");
h.tts.SV.Rate = h.pitches(pitch);

volume = get(h.volume_slider, "value");
volume = ceil(volume*100);
h.tts.SV.volume = volume;
