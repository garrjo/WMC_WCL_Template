/*************************************************************************************************************
 ~ filestatus.m by The Elusive Melon 2006 - getBitrate, getSamplerate and getNumChannels by Plague.
 ~ updated specifically for the WMC/WMC Project (it has been forked quite heavily) - Joe G. (garetjax)
 
 ~ Made for Melonscopic v1.0
 
 ~ Script Overview: This script controls mono / stereo, bitrate and frequency, and ticker. Also does the play / pause status symbols.

 ~ This script is free to use, but please keep this header inside the code, and make sure
   that the .m file is included as well as the .maki file. 
*************************************************************************************************************/

#include <lib/std.mi>
#include <lib/config.mi>

Function String getBitrate(String info);
Function String getSamplerate(String info);
Function Int getNumChannels(String info);
Function UpdateTicker();
Function UpdateChannel();

Global Text kbps, khz, Samplerate, ticker, Bitrate, Samplerate;
Global Layer mono, stereo;
Global Layout main;
Global Container MainContainer;

System.onScriptLoaded() {

	MainContainer = getContainer("Main");
  main = MainContainer.getLayout("normal");
	// Get Status Symbol layers
	mono = main.findObject("Mono");
	stereo = main.findObject("Stereo");
	khz = main.findObject("Khz");
	kbps = main.findObject("kbps");
	ticker = main.findObject("songticker");
  
	// Get Bitrate/Samplerate layers
  	Bitrate = main.findObject("bitrateText");
  	Samplerate = main.findObject("frequency");
  UpdateTicker();

	if (System.getStatus() == 0) 
	{
	  mono.hide();
	  stereo.hide();
	  kbps.hide();
	  khz.hide();
	  ticker.setXMLParam("alpha","128");
   	UpdateTicker();
	}
	
		
	if (System.getStatus() == -1)     
  	{
      //Status Is Crap
   	  UpdateTicker();
  	}
	
  	if (System.getStatus() == 1)  
  	{
		  kbps.show();
      khz.show();
      Bitrate.setText(getBitrate(getSongInfoText()));
      Samplerate.setText(getSamplerate(getSongInfoText()));
      UpdateTicker();
  	}

	UpdateChannel();
}

UpdateChannel() 
{

				
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
		mono.show();
	   	}

		else if (System.getStatus() == 1) {
		mono.setXMLParam("alpha","200");
		Bitrate.setXMLParam("alpha","200");
		Samplerate.setXMLParam("alpha","200");
		kbps.setXMLParam("alpha","180");
		khz.setXMLParam("alpha","180");
		stereo.hide();
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
		mono.hide(); 
		}
	}
		
	else if (getNumChannels(getSongInfoText()) > 2)
	{
		if (System.getStatus() == -1 ) {
			Bitrate.setXMLParam("alpha","128");
			Samplerate.setXMLParam("alpha","128");
			kbps.setXMLParam("alpha","128");
			khz.setXMLParam("alpha","128");
			stereo.hide();
			mono.hide(); 
		}
	 	   	
		else if (System.getStatus() == 1 ){
			Bitrate.setXMLParam("alpha","200");
			Samplerate.setXMLParam("alpha","200");
			kbps.setXMLParam("alpha","180");
			khz.setXMLParam("alpha","180");
			stereo.hide();
			mono.hide(); 
		}
	}
	else {
		stereo.hide();
		mono.hide();
	}
}

UpdateTicker()
{
  ticker.setText(getPlayItemMetaDataString("track")+". "+getPlayItemMetaDataString("artist")+" - "+getPlayItemMetaDataString("title"));
}

System.onPlay() {
	kbps.show();
	khz.show();
	ticker.setXMLParam("alpha","255");
  UpdateTicker();
	UpdateChannel();
}

System.onPause() {
	ticker.setXMLParam("alpha","200");
  ticker.setText("Player has Paused");
	UpdateChannel();
}

System.onStop() {
	Bitrate.setText("---");
  Samplerate.setText("--");
	mono.hide();
	stereo.hide();
	kbps.hide();
	khz.hide();
	ticker.setXMLParam("alpha","128");
  ticker.setText("Player has Stopped");
	UpdateChannel();
}

System.onResume() {
  kbps.show();
  khz.show();
  ticker.setXMLParam("alpha","255");
  UpdateTicker();
  UpdateChannel();
}

System.onScriptUnloading() {
}

System.onInfoChange(String info) {
  Bitrate.setText(getBitrate(getSongInfoText()));
  Samplerate.setText(getSamplerate(getSongInfoText()));
  UpdateTicker();
  UpdateChannel();
}

System.onVolumeChanged(Int newvol)
{
  ticker.setText("Volume"+newvol); 
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
