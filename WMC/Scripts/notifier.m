#include <lib/std.mi>
#include "attribs.m"

Function reset();
Function createNotifier();
Function showNotifier(Int w);
Function onNext();

Function Int fillNextTrackInfo(String corneroverride);
Function Int fillCustomInfo(String customstring);

Function checkPref(int bypassfs);

Global Container notifier_container;
Global Layout notifier_layout;
Global Timer notifier_timer;
Global String last_autotitle;

Global Boolean b_tohide = 0;

// ------------------------------------------------------------------------------
// init
// ------------------------------------------------------------------------------
System.onScriptLoaded() {
  initAttribs();
  notifier_timer = new Timer;
}

// ------------------------------------------------------------------------------
// shutdown
// ------------------------------------------------------------------------------
System.onScriptUnloading() {
  delete notifier_timer;
}

// ------------------------------------------------------------------------------
// called by the system when the global hotkey for notification is pressed
// ------------------------------------------------------------------------------
System.onShowNotification() {
  if (checkPref(1)) return;
  createNotifier();
  String str;
  if (getStatus() == STATUS_PLAYING) str = "Playing";
  if (getStatus() == STATUS_PAUSED) str = "Playback Paused";
  if (getStatus() == STATUS_STOPPED) str = "Playback Stopped";
  showNotifier(fillNextTrackInfo(str));
  complete; // prevents other scripts from getting the message
  return 1; // tells anybody else that might watch the returned value that, yes, we implemented that
}

// ------------------------------------------------------------------------------
// called by the system when the title for the playing item changes, this could be the result of the player
// going to the next track, or of an update in the track title
// ------------------------------------------------------------------------------
System.onTitleChange(String newtitle) {
  if (last_autotitle == newtitle) return;
  if (StrLeft(newtitle, 1) == "[") {
    if (StrLeft(newtitle, 7) == "[Buffer" ||
        StrLeft(newtitle, 4) == "[ICY") return;
  }
  last_autotitle = newtitle;
  onNext();
}

// ------------------------------------------------------------------------------
// called by the system when the user clicks the next button
// ------------------------------------------------------------------------------
onNext() {
  if (checkPref(0)) return;
  createNotifier();
  showNotifier(fillNextTrackInfo(""));
}

// ------------------------------------------------------------------------------
// called by the system when the user clicks the play button
// ------------------------------------------------------------------------------
System.onPlay() {
  if (checkPref(0)) return;
  createNotifier();
  showNotifier(fillNextTrackInfo("Playing"));
}

// ------------------------------------------------------------------------------
// called by the system when the user clicks the pause button
// ------------------------------------------------------------------------------
System.onPause() {
  if (checkPref(0)) return;
  createNotifier();
  showNotifier(fillCustomInfo("Playback Paused"));
}

// ------------------------------------------------------------------------------
// called by the system when the user clicks the pause button again
// ------------------------------------------------------------------------------
System.onResume() {
  if (checkPref(0)) return;
  createNotifier();
  showNotifier(fillNextTrackInfo("Resuming Playback"));
}

// ------------------------------------------------------------------------------
// called by the system when the user clicks the play button
// ------------------------------------------------------------------------------
System.onStop() {
  if (checkPref(0)) return;
  createNotifier();
  showNotifier(fillCustomInfo("End of Playback"));
}

// ------------------------------------------------------------------------------
// checks if we should display anything
// ------------------------------------------------------------------------------
Int checkPref(int bypassfs) {
  if (!bypassfs && notifier_disablefullscreen_attrib.getData() == "1" && isVideoFullscreen()) return 1;
  if (notifier_never_attrib.getData() == "1") return 1;
  if (notifier_minimized_attrib.getData() == "1" && !isMinimized()) return 1;
  if (notifier_windowshade_attrib.getData() == "1") {
    if (isMinimized()) return 0;
    Container c = getContainer("main");
    if (!c) return 1;
    Layout l = c.getCurLayout();
    if (!l) return 1;
    if (l.getId() != "shade") return 1;
  }
  return 0;
}

// ------------------------------------------------------------------------------
// fade in/out completed
// ------------------------------------------------------------------------------
notifier_layout.onTargetReached() {
  int a = notifier_layout.getAlpha();
  if (a == 255) {
    notifier_timer.setDelay(StringToInteger(notifier_holdtime_attrib.getData()));
    notifier_timer.start();
  }
  else if (a == 0) {
    reset();
  }
}

// ------------------------------------------------------------------------------
// hold time elapsed
// ------------------------------------------------------------------------------
notifier_timer.onTimer() {
  stop();
  if (notifier_layout.isTransparencySafe()) {
    notifier_layout.setTargetA(0);
    notifier_layout.setTargetSpeed(StringToInteger(notifier_fadeouttime_attrib.getData()) / 1000);
    notifier_layout.gotoTarget();
  } else {
    reset();
  }
}

// ------------------------------------------------------------------------------
// when notifier is clicked, bring back the app from minimized state if its minimized and focus it
// ------------------------------------------------------------------------------
notifier_layout.onLeftButtonDown(int x, int y) {
  notifier_timer.stop();
  notifier_layout.cancelTarget();
  reset();
  restoreApplication();
  activateApplication();
}

// ------------------------------------------------------------------------------
// close the notifier window, destroys the container automatically because it's dynamic
// ------------------------------------------------------------------------------
reset() {
  notifier_container.close();
  notifier_container = NULL;
  notifier_layout = NULL;
}

// ------------------------------------------------------------------------------
createNotifier() {
  if (notifier_container == NULL) {
    notifier_container = newDynamicContainer("notifier");
    if (!notifier_container) return; // reinstall duh!
    if (isDesktopAlphaAvailable())
      notifier_layout = notifier_container.getLayout("desktopalpha");
    else
      notifier_layout = notifier_container.getLayout("normal");
    if (!notifier_layout) return; // reinstall twice, man
  } else {
    notifier_layout.cancelTarget();
    notifier_timer.stop();
  }
}

// ------------------------------------------------------------------------------
showNotifier(int w) {
  w = w + 32;
  int x = getViewportWidth() + getViewportLeft() - w - 2;
  int y = getViewportHeight() + getViewportTop() - 80 - 2;

  // show if not there or if already shown then lets resize on the fly (bento style)
  if (!notifier_layout.isVisible()) {
    notifier_layout.resize(x, y, w, 80);
  }
  else {
    notifier_layout.resize(notifier_layout.getguiX(), y, notifier_layout.getGuiW(), 80);
  }

  if (notifier_layout.isTransparencySafe()) {
    notifier_layout.show();
    notifier_layout.setTargetA(255);
    notifier_layout.setTargetX(x);
    notifier_layout.setTargetY(y);
    notifier_layout.setTargetW(w);
    notifier_layout.setTargetH(80);
    notifier_layout.setTargetSpeed(StringToInteger(notifier_fadeintime_attrib.getData()) / 1000);
    notifier_layout.gotoTarget();
  } else {
    notifier_layout.setAlpha(255);
    notifier_layout.show();
    notifier_timer.setDelay(StringToInteger(notifier_holdtime_attrib.getData()));
    notifier_timer.start();
  }
}

// ------------------------------------------------------------------------------
Int fillNextTrackInfo(String corneroverride) {
  Int maxv = 0;
  Int stream = 0;
  Boolean isAolRadio = 0;

  if (!notifier_layout) return 0;

  Group g_text = notifier_layout.findObject("notifier.text");
  Group g_albumart = notifier_layout.findObject("notifier.albumart");

  Group p = notifier_layout;
  Text plentry = p.findObject("plentry");
  Text nexttrack = p.findObject("nexttrack");
  Text _title = p.findObject("title");
  Text album = p.findObject("album");
  Text artist = p.findObject("artist");
  Text endofplayback = p.findObject("endofplayback");

//  DebugString("got callback for " + getPlayItemString(), 0);

  // Get Stream Name - if no stream returns ""
  string s = getPlayItemMetaDataString("streamname");
  string stype = getPlayItemMetaDataString("streamtype"); //"streamtype" will return "2" for SHOUTcast and "3" for AOL Radio

  // Are we listening to AOl Radio (uvox://)
  isAolRadio = (stype == "3");
  // map CBS/StreamTheWorld to AOL Radio
  isAolRadio = (isAolRadio||(strsearch(getPlayItemString(), "208.80.52.") >= 0));
  isAolRadio = (isAolRadio||(strsearch(getPlayItemString(), "208.80.53.") >= 0));
  isAolRadio = (isAolRadio||(strsearch(getPlayItemString(), "208.80.54.") >= 0));
  isAolRadio = (isAolRadio||(strsearch(getPlayItemString(), "208.80.55.") >= 0));

  if (stype == "2" || isAolRadio) stream = 1;

  if (endofplayback) endofplayback.hide();

  if (plentry) {
    plentry.setText(integerToString(getPlaylistIndex()+1)+translate(" of ")+integerToString(getPlaylistLength()));
    plentry.show();
  }
  if (nexttrack) {
    if (corneroverride == "") {
      if (!stream) {
        if (!isVideo()) {
          nexttrack.setText("New track");
        }
        else {
          nexttrack.setText("New video");
        }
      }
      else {
        if (isAolRadio) {
          nexttrack.setText("AOL Radio");
        }
        else {
          nexttrack.setText("On air");
        }
      }
    }
    else {
      nexttrack.setText(corneroverride);
    }
    nexttrack.show();
  }

  string set_artist = "";
  string set = "";
  if (_title) {
    String str;
    if (!stream) {
      _title.setXmlParam("ticker", "0");
      _title.setXmlParam("display", "");

      str = getPlayitemMetaDataString("title"); 
      if (str == "") str = getPlayitemDisplayTitle();
      String l = getPlayItemMetaDataString("length");
      if (l != "") {
        str += " (" + integerToTime(stringtointeger(l)) + ")";
      }
      _title.setText(str);
    }
    else {
      if (isAolRadio && str = getPlayItemMetaDataString("uvox/title") != "") {
        _title.setText(str);
      }
      else if (str = getPlayItemMetaDataString("streamtitle") != "") {
        int v = strsearch(str, " - "); // We divide the string by a " - " sublimiter - no luck for old / wrong tagged stations
        if (v > 0) {
          set_artist = strleft (str, v); // Store artist
          string str = strright (str, strlen(str) - 3 - v);
          _title.setText(str);
        }
        else {
          _title.setXmlParam("ticker", "1"); // These titles can be _very_ long
          _title.setText(str);
        }
      }
      else {
        _title.setXmlParam("ticker", "1");
        _title.setXmlParam("display", "songtitle");
        _title.setText("");
      }
    }
    _title.show();
  }

  if (artist) {
    if (!stream) {
      if (isVideo()) {
        artist.setText("");
      }
      else {
        artist.setText(getPlayitemMetaDataString("artist"));
      }
    }
    else {
      // Check first if we're playing AOL Radio
      if (isAolRadio && set = getPlayItemMetaDataString("uvox/artist") != "") {
        artist.setText(set);
      }
      // Perhaps we've stored the artist before?
      else if (set_artist != "") {
        artist.setText(set_artist);
      }
      // Then display the station name
      else if (s != "") {
        artist.setText(s);
      }
      // So, we've had no luck - just display a static text :(
      else {
        if (isVideo()) {
          artist.setText("Internet TV"); 
        }
        else {
          artist.setText("Internet Radio");
        }
      }
    }
    artist.show();
  }

  if (album) { 
    String str;
    if (!stream && !isVideo()) {
      album.setXmlParam("display", "");
      str = getPlayitemMetaDataString("album");
      String l = getPlayitemMetaDataString("track");
      if (l != "" && l != "-1") str += " (" + translate("Track ") + l + ")";
      album.setText(str);
    }
    else {
      album.setXmlParam("display", "");
      // Playing AOL Radio with metadata?
      if (isAolRadio && set = getPlayItemMetaDataString("uvox/album") != "") {
        album.setText(set);
      }
      // we have divided the songname - let's display the station name
      else if (set_artist != "" && s != "") {
        album.setText(s);
      }
      // no luck either...
      else {
        album.setText("");
        album.setXmlParam("display", "songinfo_localise");
      }
    }
    album.show();
  }

  // Album Art Stuff

  layer cover, webcover;
  if (g_albumart) {
    cover = g_albumart.findObject("notifier.cover");
    webcover = g_albumart.findObject("notifier.webcover");
  }

  Boolean showAlbumArt = FALSE;

  if (cover != NULL && webcover != NULL) {
    if (stream) {
      // Detect if we are listening to AOL Radio
      if (strlower(strleft(getPlayItemString(), 4)) == "uvox") {
        s = getPlayItemMetaDataString("uvox/albumart");
        if (s != "") {
          webcover.setXmlParam("image", "http://broadband-albumart.music.aol.com/scan/" + s);
          if (webcover.isInvalid()) {
            showAlbumArt = FALSE;
          }
          else {
            cover.hide();
            webcover.show();
            showAlbumArt = TRUE;
          }
        }
      }
    }
    else {
      if (cover.isInvalid()) { // Check if the album art obj shows a pic
        showAlbumArt = FALSE;
      }
      else {
        webcover.hide();
        cover.show();
        showAlbumArt = TRUE;				
      }
    }
  }
	
  if (showAlbumArt) {
    if (g_albumart) g_albumart.show();
    if (g_text) g_text.setXmlParam("x", "75");
    if (g_text) g_text.setXmlParam("w", "-95");		
  }
  else {
    if (g_albumart) g_albumart.hide();
    if (g_text) g_text.setXmlParam("x", "15");
    if (g_text) g_text.setXmlParam("w", "-35");		
  }

  if (g_text) g_text.show();

  maxv = artist.getAutoWidth();
  if (maxv < album.getAutoWidth()) maxv = album.getAutoWidth();
  if (maxv < _title.getAutoWidth()) maxv = _title.getAutoWidth();
  if (maxv < (nexttrack.getAutoWidth() + plentry.getAutoWidth() - 5) ) maxv = nexttrack.getAutoWidth() + plentry.getAutoWidth() - 5;
  if (maxv < 128) maxv = 128;
  if (maxv > getViewportWidth()/4) maxv = getViewportWidth()/4;
  
  return maxv + ( showAlbumArt * 80 );
}

// ------------------------------------------------------------------------------
Int fillCustomInfo(String customtext)
{
  Group p = notifier_layout;
  Group g_text = p.findObject("notifier.text");
  Group g_albumart = p.findObject("notifier.albumart");
  Text plentry = p.findObject("plentry");
  Text nexttrack = p.findObject("nexttrack");
  Text _title = p.findObject("title");
  Text album = p.findObject("album");
  Text artist = p.findObject("artist");
  Text endofplayback = p.findObject("endofplayback");

  if (g_text) { g_text.hide(); }
  if (g_albumart) g_albumart.hide();

  if (plentry) { plentry.hide(); }
  if (nexttrack) nexttrack.hide();
  if (_title) { _title.hide(); }
  if (artist) { artist.hide(); }
  if (album) { album.hide(); }

  if (endofplayback != NULL /*&& s_endofplayback  != NULL*/) {
    endofplayback.setText(translate(customtext)+" ");
    //s_endofplayback.setText(translate(customtext)+" ");
    int aw = endofplayback.getAutoWidth();
    endofplayback.show();
    //s_endofplayback.show();
    if (aw > 128)
      return aw;
  }
  return 128;
}