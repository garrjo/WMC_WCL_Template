/*--------------------------------------------------------------------
 System functions.

 This scripts handles various system functions, like toggling of some
 configuration options (crossfading for example), and temporary output
 in the song ticker (volume, seek, clicks on the player buttons).

Edited By Darren Horrocks (aka Bizzy D.)
added "Shade, Min, Men, Bal, vistoggle, optinotoggle, doubletoggle, ontoptoggle, fileinfo"
--------------------------------------------------------------------*/

#include </lib/std.mi>
#include </lib/config.mi>

Function setTempText(String txt);
Function emptyTempText();

Global Text Songticker;
Global Slider Volbar, Seeker, SeekGhost;
Global Timer Songtickertimer, Wobbler;
Global Int WobblerWay;

Class GuiObject HintObject;
Class ToggleButton HintToggleButton;

Global HintObject Play, Stop, Previous, Next, Pause, Thinger, Open, Eq, Ml, Pl, Shade, Min, Men, Bal, vistoggle, optinotoggle, doubletoggle, ontoptoggle, fileinfo;
Global HintToggleButton ToggleXFade, ToggleShuffle, ToggleRepeat;

Class ConfigAttribute ToggleConfigAttribute;
Global ToggleConfigAttribute attr_repeat, attr_shuffle, attr_crossfade;

System.onScriptUnloading() {
  delete Songtickertimer;
  delete Wobbler;
}

System.onScriptLoaded() {

  // Timers won't start until .start(); is called
  Songtickertimer = new Timer;
  Songtickertimer.setDelay(1000);

  Layout mainnormal = getContainer("Main").getLayout("Normal");

  // Get buttons
  ToggleXFade = mainnormal.getObject("Crossfade");
  ToggleShuffle = mainnormal.getObject("Shuffle");
  ToggleRepeat = mainnormal.getObject("Repeat");

  // Get songticker, Volbar & Seeker
  Songticker = mainnormal.getObject("Songticker");
  Volbar = mainnormal.getObject("Volume");
  Seeker = mainnormal.getObject("Seeker");
  SeekGhost = mainnormal.getObject("SeekerGhost");

  // Get Various buttons
  Play = mainnormal.getObject("Play");
  Pause = mainnormal.getObject("Pause");
  Stop = mainnormal.getObject("Stop");
  Next = mainnormal.getObject("Next");
  Previous = mainnormal.getObject("Previous");
  Thinger = mainnormal.getObject("Thinger");
  Open = mainnormal.getObject("Eject");
  Shade = mainnormal.getObject("Winshade");
  Min = mainnormal.getObject("Minimize");
  men = mainnormal.getobject("sysbutton");
  bal = mainnormal.getobject("ballslider");
  vistoggle = mainnormal.getobject("vistog");
  optinotoggle = mainnormal.getobject("optiontog"); 
  doubletoggle = mainnormal.getobject("toggledoublesize");
  ontoptoggle = mainnormal.getobject("toggleAllWaysOnTop");
  fileinfo = mainnormal.getobject("fileinfo");

  Eq = mainnormal.getObject("Eq");
  Ml = mainnormal.getObject("Ml");
  Pl = mainnormal.getObject("Pl");

  // Set buttons status
  ConfigItem item;
  item = Config.getItem("Playlist editor");
  if (item != NULL) {
    attr_repeat = item.getAttribute("repeat");
    attr_shuffle = item.getAttribute("shuffle");
  }
  item = Config.getItem("Crossfader");
  if (item != NULL) {
    attr_crossfade = item.getAttribute("Enabled");
  } 
  
  if (ToggleXFade != NULL && attr_crossfade != NULL) ToggleXFade.setActivated(StringToInteger(attr_crossfade.getData()));
  if (ToggleShuffle != NULL && attr_shuffle != NULL) ToggleShuffle.setActivated(StringToInteger(attr_shuffle.getData()));
  if (ToggleRepeat != NULL && attr_repeat != NULL) ToggleRepeat.setActivated(StringToInteger(attr_repeat.getData()));

  if (SeekGhost != NULL)
    SeekGhost.setAlpha(0);

  if (Thinger != NULL) {
    Wobbler = new Timer;
    Wobbler.setDelay(50);
  }

}

Songtickertimer.onTimer() {
  Songticker.setText("");
  stop();
}

Volbar.onSetPosition(int p) {
  Float f;
  f = p;
  f = f / 255 * 100;
  setTempText("Volume Is Now " + System.integerToString(f) + " Percent");
}

Volbar.onSetFinalPosition(int p) {
  Songticker.setText("");
}

Seeker.onSetPosition(int p) {
  if (!SeekGhost) {
    Float f;
    f = p;
    f = f / 255 * 100;
    Float len = getPlayItemLength();
    if (len != 0) {
      int np = len * f / 100;
      setTempText("Seek to " + integerToTime(np) + " / " + integerToTime(len) + " (" + integerToString(f) + "%)");
    }
  }
}

SeekGhost.onSetPosition(int p) {
  if (getalpha() == 0) setAlpha(128);
  Float f;
  f = p;
  f = f / 255 * 100;
  Float len = getPlayItemLength();
  if (len != 0) {
    int np = len * f / 100;
    setTempText("Seek to " + integerToTime(np) + " / " + integerToTime(len) + " (" + integerToString(f) + "%)");
  }
}

SeekGhost.onsetfinalposition(int p) {
  Songticker.setText("");
  SeekGhost.setAlpha(0);
}

HintToggleButton.onLeftButtonDown(int x, int y) {
  if (HintToggleButton == ToggleXFade) setTempText("Toggle crossfade");
  else if (HintToggleButton == ToggleRepeat) setTempText("Toggle repeat");
  else if (HintToggleButton == ToggleShuffle) setTempText("Toggle shuffle");
}

HintToggleButton.onLeftButtonUp(int x, int y) {
  emptyTempText();
}

HintToggleButton.onToggle(int onoff) {
  String cmd, txt;
  Wac dest;
  ConfigAttribute item;
  item = NULL;
  if (HintToggleButton == ToggleXFade) {
    item = attr_crossfade;
    txt = "Crossfade";
  } else if (HintToggleButton == ToggleRepeat) {
    item = attr_repeat;
    txt = "Repeat";
  } else if (HintToggleButton == ToggleShuffle) {
    item = attr_shuffle;
    txt = "Shuffle";
  }
  if (item != NULL) {
    item.setData(IntegerToString(onoff));
    String s;
    if (onoff) s = "on"; else s = "off";
    setTempText(txt + " now " + s);
  }
}

HintObject.onLeftButtonDown(int x, int y) {
  if (HintObject == Play) setTempText("Play");
  else if (HintObject == Stop) setTempText("Stop");
  else if (HintObject == Pause) setTempText("Pause");
  else if (HintObject == Next) setTempText("Next");
  else if (HintObject == Previous) setTempText("Previous");
  else if (HintObject == Thinger) setTempText("Thinger");
  else if (HintObject == Open) setTempText("Open");
  else if (HintObject == Eq) setTempText("Equalizer");
  else if (HintObject == ML) setTempText("Media Library");
  else if (HintObject == Pl) setTempText("Playlist Editor");
  else if (HintObject == shade) setTempText("Toggle Winshade Mode");
  else if (HintObject == Min) setTempText("Minimize");
  else if (HintObject == men) setTempText("Sysmenu");
  else if (HintObject == bal) setTempText("Balance Cant Be Changed Yet");
  else if (HintObject == vistoggle) setTempText("Visualization Menu");
  else if (HintObject == optinotoggle) setTempText("Options Menu");
  else if (HintObject == doubletoggle) setTempText("Toggle Double Size");
  else if (HintObject == ontoptoggle) setTempText("Toggle Allways On-Top");
  else if (HintObject == fileinfo) setTempText("File Info Box");
}

HintObject.onLeftButtonUp(int x, int y) {
  emptyTempText();
}

Thinger.onEnterArea() {
 WobblerWay = 1;
 Wobbler.start();
}

Thinger.onLeaveArea() {
 Wobbler.stop();
 setAlpha(255);
}

Wobbler.onTimer() {
  int curalpha = Thinger.getAlpha() + WobblerWay * 24;
  if (curalpha <= 96) { curalpha = 96; WobblerWay = -WobblerWay; }
  if (curalpha > 255) { curalpha = 255; WobblerWay = -WobblerWay; }
  Thinger.setAlpha(curalpha);
}

setTempText(String txt) {
  Songtickertimer.stop();
  Songticker.setText(txt);
  Songtickertimer.start();
}

emptyTempText() {
  Songticker.setText("");
  Songtickertimer.stop();
}

Songticker.onNotify(String s1, String s2, int i1, int i2) {
  setTempText(s1);
}

ToggleConfigAttribute.onDataChanged() {
  ToggleButton t = NULL;
  if (ToggleConfigAttribute == attr_crossfade) t = ToggleXFade;
  else if (ToggleConfigAttribute == attr_shuffle) t = ToggleShuffle;
  else if (ToggleConfigAttribute == attr_repeat) t = ToggleRepeat;
  if (t != NULL)
    t.setActivated(StringToInteger(getData()));
}

