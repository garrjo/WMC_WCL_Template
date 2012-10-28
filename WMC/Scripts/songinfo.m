#include <lib/std.mi>

Function string tokenizeSongInfo(String tkn, String sinfo);

Global GuiObject sterspeaker, monspeaker;
Global Text infolineExampleText, bitrateText, FrequencyText;
Global Layout Main;
Global Timer songInfoTimer;
Global String SongInfoString;

System.onScriptLoaded()
{
  Main = getContainer("Main").getLayout("Normal");
  sterspeaker = Main.getObject("sterspeaker");
  monspeaker = Main.getObject("monspeaker");
  infolineExampleText = Main.getObject("infoline");
  bitrateText = main.getObject("bitrateText");
  FrequencyText = main.getObject("frequency");
  songInfoTimer = new Timer;
  songInfoTimer.setDelay(1);
  if ( getLeftVUMeter() ) songInfoTimer.start();
  sterspeaker.hide();
  monspeaker.hide();
}

System.onScriptUnloading(){
	delete songInfoTimer;
}

System.onPlay(){
	songInfoTimer.start();
}

System.onStop(){
	songInfoTimer.stop();
	monspeaker.hide();
	sterspeaker.hide();
}

System.onResume(){
	songInfoTimer.start();
}

System.onPause(){
	songInfoTimer.stop();
}

songInfoTimer.onTimer(){
String tkn;
	SongInfoString = infolineExampleText.getText();

	//Channels
	tkn = tokenizeSongInfo("Channels", SongInfoString);
	if (tkn=="stereo"){monspeaker.hide(); sterspeaker.show();}
	else{monspeaker.show(); sterspeaker.hide();}

	//Bitrate
	tkn = tokenizeSongInfo("Bitrate", SongInfoString);
	bitrateText.setText(tkn);

	//Frequency
	tkn = tokenizeSongInfo("Frequency", SongInfoString);
	FrequencyText.setText(tkn);

}


tokenizeSongInfo(String tkn, String sinfo){
int searchResult;
String rtn;
if (tkn=="Bitrate"){
		for (int i = 0; i < 5; i++) {
			rtn = getToken(sinfo, " ", i);
			searchResult = strsearch(rtn, "kbps");
			if (searchResult>0) return Strleft(rtn, 3);
		}
		return "";
}
if (tkn=="Channels"){
		for (int i = 0; i < 5; i++) {
			rtn = getToken(sinfo, " ", i);
			searchResult = strsearch(rtn, "tereo");
			if (searchResult>0) return rtn;
			searchResult = strsearch(rtn, "ono");
			if (searchResult>0) return rtn;
		}
		return "";
}
if (tkn=="Frequency"){
		for (int i = 0; i < 5; i++) {
			rtn = getToken(sinfo, " ", i);
			searchResult = strsearch(rtn, "kHz");
			if (searchResult>0) return Strleft(rtn, 2);
		}
		return "";
}
if (tkn=="ABR"){
		for (int i = 0; i < 5; i++) {
			rtn = getToken(sinfo, " ", i);
			searchResult = strsearch(rtn, "bps)");
			if (searchResult>0) return rtn;
		}
		return "";
}


else return "";
}