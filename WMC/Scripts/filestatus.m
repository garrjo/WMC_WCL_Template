/*************************************************************************************************************
 ~ filestatus.m by The Elusive Melon 2006 - getBitrate, getSamplerate and getNumChannels by Plague.
 
 ~ Made for Melonscopic v1.0
 
 ~ Script Overview: This script controls mono / stereo, bitrate and frequency, and ticker. Also does the play / pause status symbols.

 ~ This script is free to use, but please keep this header inside the code, and make sure
   that the .m file is included as well as the .maki file. 
*************************************************************************************************************/

#include "../../../lib/std.mi"
#include "../../../lib/config.mi"

Function String getBitrate(String info);
Function String getSamplerate(String info);
Function Int getNumChannels(String info);
Function UpdateChannel();

Global Text Bitrate, Samplerate, ticker;
Global Layer mono, stereo, surround, play, pause, kbps, khz;

System.onScriptLoaded() {

	Group mainGrp = getScriptGroup();

	// Get Status Symbol layers
	mono = mainGrp.findObject("m_mono");
	stereo = mainGrp.findObject("m_stereo");
	surround = mainGrp.findObject("m_surround");
	play = mainGrp.findObject("status_play");
	pause = mainGrp.findObject("status_pause");
	kbps = mainGrp.findObject("m_kbps");
	khz = mainGrp.findObject("m_khz");
	ticker = mainGrp.findObject("songticker");


	// Get Bitrate/Samplerate layers
  	Bitrate = mainGrp.findObject("Bitrate");
  	Samplerate = mainGrp.findObject("Samplerate");

	if (System.getStatus() == 0) 
	{
	mono.hide();
	stereo.hide();
	surround.hide();
	play.hide();
	pause.hide();
	kbps.hide();
	khz.hide();
	ticker.setXMLParam("alpha","128");
	}
	
		
	if (System.getStatus() == -1)     
  	{
    		Pause.show();
		Play.Hide();
  	}
   	
 	
  	if (System.getStatus() == 1)  
  	{
    		Play.show();
		Pause.Hide();
		kbps.show();
	    khz.show();
		Bitrate.setText(getBitrate(getSongInfoText()));
		Samplerate.setText(getSamplerate(getSongInfoText()));				
  	}

	UpdateChannel();
}

UpdateChannel() {

				
	if (getNumChannels(getSongInfoText()) == 1) 
	{
			
	   	if (System.getStatus() == -1) 
		{
		mono.setXMLParam("alpha","128");
		Bitrate.setXMLParam("alpha","128");
		Samplerate.setXMLParam("alpha","128");
		kbps.setXMLParam("alpha","128");
		khz.setXMLParam("alpha","128");
		stereo.hide();
		surround.hide();
		mono.show();
	   	}

		else if (System.getStatus() == 1) {
		mono.setXMLParam("alpha","200");
		Bitrate.setXMLParam("alpha","200");
		Samplerate.setXMLParam("alpha","200");
		kbps.setXMLParam("alpha","180");
		khz.setXMLParam("alpha","180");
		stereo.hide();
		surround.hide();
		mono.show();
		}
		
	}
	 
	 else if (getNumChannels(getSongInfoText()) == 2) 
	{
		

		if (System.getStatus() == -1 ) 
		{
		stereo.setXMLParam("alpha","128");
		Bitrate.setXMLParam("alpha","128");
		Samplerate.setXMLParam("alpha","128");
		kbps.setXMLParam("alpha","128");
		khz.setXMLParam("alpha","128");
		stereo.show();
		surround.hide();
		mono.hide(); 
		}
	 	   	
		else if (System.getStatus() == 1 )
		{
		stereo.setXMLParam("alpha","200");
		Bitrate.setXMLParam("alpha","200");
		Samplerate.setXMLParam("alpha","200");
		kbps.setXMLParam("alpha","180");
		khz.setXMLParam("alpha","180");
		stereo.show();
		surround.hide();
		mono.hide(); 
		}
	}
		
	else if (getNumChannels(getSongInfoText()) > 2)
	{
		if (System.getStatus() == -1 ) {
			surround.setXMLParam("alpha","128");
			Bitrate.setXMLParam("alpha","128");
			Samplerate.setXMLParam("alpha","128");
			kbps.setXMLParam("alpha","128");
			khz.setXMLParam("alpha","128");
			surround.show();
			stereo.hide();
			mono.hide(); 
		}
	 	   	
		else if (System.getStatus() == 1 ){
			surround.setXMLParam("alpha","200");
			Bitrate.setXMLParam("alpha","200");
			Samplerate.setXMLParam("alpha","200");
			kbps.setXMLParam("alpha","180");
			khz.setXMLParam("alpha","180");
			surround.show();
			stereo.hide();
			mono.hide(); 
		}
	}
	else {
		stereo.hide();
		mono.hide();
		surround.hide();		
	}
	

}


System.onPlay() {
	Play.show();
	Pause.hide();
	kbps.show();
	khz.show();
	ticker.setXMLParam("alpha","255");

	UpdateChannel();
}

System.onPause() {
	Play.hide();
	Pause.show();
	ticker.setXMLParam("alpha","200");

	UpdateChannel();
}

System.onStop() {
	Bitrate.setText("");
  	Samplerate.setText("");
	Play.hide();
	Pause.hide();
	mono.hide();
	stereo.hide();
	surround.hide();
	kbps.hide();
	khz.hide();
	ticker.setXMLParam("alpha","128");
	
	UpdateChannel();
}

System.onResume() {
  	Play.show();
  	Pause.hide();
  	kbps.show();
	khz.show();
	ticker.setXMLParam("alpha","255");
   
	UpdateChannel();
}

System.onScriptUnloading() {

}

System.onInfoChange(String info) {
  Bitrate.setText(getBitrate(getSongInfoText()));
  Samplerate.setText(getSamplerate(getSongInfoText()));

  UpdateChannel();
}


string getBitrate(String info) {
int searchResult;
String rtn;
  for (int i = 0; i < 5; i++) {
    rtn = getToken(strlower(info), " ", i);
    searchResult = strsearch(rtn, "kbps");
    if (searchResult > 0) {
      rtn = Strleft(rtn, searchResult);
      searchResult = strsearch(rtn, ".");
      if (searchResult > 0) rtn = Strleft(rtn, searchResult);
      if (strlen(rtn) == 1) rtn = "  " + rtn;
      else if (strlen(rtn) == 2) rtn = " " + rtn;
      return rtn;
    }
  }
  return "";
}

string getSamplerate(String info) {
int searchResult;
String rtn;
  for (int i = 0; i < 5; i++) {
    rtn = getToken(strlower(info), " ", i);
    searchResult = strsearch(rtn, "khz");
    if (searchResult > 0) {
      rtn = Strleft(rtn, searchResult);
      searchResult = strsearch(rtn, ".");
      if (searchResult > 0) rtn = Strleft(rtn, searchResult);
      if (strlen(rtn) == 1) rtn = " " + rtn;
      return rtn;
    }
  }
  return "";
}

int getNumChannels(String info) {
String rtn;
  for (int i = 0; i < 5; i++) {
    rtn = getToken(info, " ", i);
    if (StrSearch(strlower(rtn), "mono") != -1) return 1;
    if (StrSearch(strlower(rtn), "stereo") != -1) return 2;
    if (strsearch(strlower(rtn), "channel") != -1) {
      int tmp = strsearch(strlower(info), "channel");
      if (strmid(info, tmp - 1, 1) == " ") return stringToInteger(getToken(info, " ", i - 1));
      else {
        if (strmid(info, tmp - 2, 1) == " ") return stringToInteger(strmid(info, tmp - 1, 1));
        else if (strmid(info, tmp - 3, 1) == " ") return stringToInteger(strmid(info, tmp - 2, 2));
      }
    }
  }
  return -1;
}
