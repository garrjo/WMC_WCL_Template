#include <lib/std.mi>
#include <lib/config.mi>

Function UpdateVis(int iC);
Function UpdateOptions(int iC);
Function MakeVisMenu();
Function MakeTimer();

Global AnimatedLayer MainVis, Vis1, Vis2; //Vis3, Vis4, Vis5, Vis6, Vis7, Vis8, Vis9, Vis10, Vis11, Vis12;
Global Double Level, OneFrame;

Global Container main;
Global Button s_avsload, prevVis, nextVis, s_prevVis, s_nextVis;
Global Group page1, page2; // page3, page4, page5, page6, page7, page8, page9, page10, page11, page12, page13, page14;
Global Int iClick, iMenu, LastFrame, VisStyle, Caps; // VisStyle = 0 for wide, Caps = 1 for on
Global Timer AVStimer, VisTimer;
Global Vis visnormal, vismirror1, vismirror2;
Global PopupMenu VisMenu, OptionMenu;

System.onScriptLoaded() {

	main = getContainer("Main");
	Group mainGrp = getScriptGroup();

	page1 = mainGrp.findObject("vis");	//contains normal vis
	
	visnormal = page1.findObject("vis");
	vismirror1 = page1.findObject("vis");
	vismirror2 = page1.findObject("vis");

	s_avsload = mainGrp.findObject("vis");

	iClick = 0; // This allows the AVS to load on double click

	AVStimer = new Timer;
	AVStimer.setDelay(250);

	iMenu = getPrivateInt("WMC","iMenu",2);
	VisStyle = getPrivateInt("WMC","VisStyle",0);
	Caps = getPrivateInt("WMC","Caps",1);

	MakeTimer();
	UpdateVis(iMenu);

	if (Caps) {
		visnormal.setXMLParam("peaks","1");
		vismirror1.setXMLParam("peaks","1");
		vismirror2.setXMLParam("peaks","1");
	}
	else {
		visnormal.setXMLParam("peaks","0");
		vismirror1.setXMLParam("peaks","0");
		vismirror2.setXMLParam("peaks","0");
	}

	if (VisStyle) {
		visnormal.setXMLParam("bandwidth","thin");
		vismirror1.setXMLParam("bandwidth","thin");
		vismirror2.setXMLParam("bandwidth","thin");
	}
	else {
		visnormal.setXMLParam("bandwidth","wide");
		vismirror1.setXMLParam("bandwidth","wide");
		vismirror2.setXMLParam("bandwidth","wide");
	}

}

s_avsload.onLeftButtonUp(int x,int y) { // Code below is the double click work around

	iClick = iClick + 1;
	AVStimer.stop();
	AVStimer.start();

	if (iClick >=2) {
		if (!isNamedWindowVisible("guid:{0000000A-000C-0010-FF7B-01014263450C}")) {
	        	showWindow("guid:{0000000A-000C-0010-FF7B-01014263450C}", "", false);
	        }
		else hideNamedWindow("guid:{0000000A-000C-0010-FF7B-01014263450C}");
		iClick = 0;
	}

	complete;
}

AVStimer.onTimer() {
	AVStimer.stop();
	iClick = 0;
}

System.onScriptUnloading() {

	delete VisTimer;
	delete AVStimer;
	setPrivateInt("mBrio","iMenu",iMenu);
	setPrivateInt("mBrio","VisStyle",VisStyle);
	setPrivateInt("mBrio","Caps",Caps);

}

// Vis Menu and Vis Toggle Buttons

s_prevVis.onLeftButtonUp(int x,int y) {

	if (iMenu == 1) iMenu = 5; // originally iMenu = 17;
	else iMenu = iMenu - 1;

	UpdateVis(iMenu);

	complete;

}

s_nextVis.onLeftButtonUp(int x,int y) {

	if (iMenu == 5) iMenu = 1; // originally iMenu = 17
	else iMenu = iMenu + 1;

	UpdateVis(iMenu);

	complete;

}

s_avsload.onRightButtonDown(int x, int y) {
	MakeVisMenu();

	int temp = iMenu;

  	iMenu = VisMenu.popAtMouse();
	int iMenuDummy = iMenu;
	
	if (iMenu > 0 && iMenu < 6) UpdateVis(iMenu); // originally iMenu < 18
	else iMenu = temp;

	if (iMenuDummy > 99 && iMenuDummy < 102) UpdateOptions(iMenuDummy);

	delete VisMenu;
	delete OptionMenu;
	
	complete;
}

MakeVisMenu(){

	VisMenu = New PopupMenu;
	OptionMenu = New PopupMenu;

	OptionMenu.addCommand("Thin Visualization",100, VisStyle,0);
	OptionMenu.addCommand("Show Peaks",101, Caps,0);
	
	VisMenu.addSubMenu(OptionMenu,"Visualization Options");
	VisMenu.addSeparator();
	VisMenu.addCommand("Visualization Off", 1, iMenu == 1, 0);
	VisMenu.addSeparator();
	VisMenu.addCommand("Spectrum Analyzer", 2, iMenu == 2, 0);
	VisMenu.addCommand("Oscilloscope Mode", 3, iMenu == 3, 0);
	VisMenu.addCommand("Inverted Spectrum", 4, iMenu == 4, 0);
	VisMenu.addCommand("Mirrored Spectrum", 5, iMenu == 5, 0);
	
	complete;
}

UpdateVis(int iC) {

	page1.hide();
	page2.hide();

	delete VisTimer;

	if (iC == 1) {
		page1.show();
		visnormal.setMode(0);
	}
	if (iC == 2) {
		page1.show(); 
		visnormal.setMode(1); 
		visnormal.setXMLParam("flipv","0"); 
		visnormal.setXMLParam("y","0");
	}
	if (iC == 3) { 
		page1.show();
		visnormal.setMode(2); 
		visnormal.setXMLParam("flipv","0"); 
		visnormal.setXMLParam("y","0");
	}
	if (iC == 4) { 
		page1.show();
		visnormal.setMode(1);
		visnormal.setXMLParam("flipv","1");
		visnormal.setXMLParam("y","0");
	}
	if (iC == 5) page2.show();

	/*if (iC == 6) {
		page3.show();
		MainVis = Vis1;
	        OneFrame = 255/(MainVis.getLength());
		MakeTimer();
		VisTimer.start();
	}	
	if (iC == 7) {
		page4.show();
		MainVis = Vis2;
		OneFrame = 255/(MainVis.getLength());
		MakeTimer();
		VisTimer.start();
	}
	if (iC == 8) {
		page5.show();
		MainVis = Vis3;
		OneFrame = 255/(MainVis.getLength());
		MakeTimer();
		VisTimer.start();
	}
	if (iC == 9) {
		page6.show();
		MainVis = Vis4;
		OneFrame = 255/(MainVis.getLength());
		MakeTimer();
		VisTimer.start();
	}
	if (iC == 10) {
		page7.show();
		MainVis = Vis5;
		OneFrame = 255/(MainVis.getLength());
		MakeTimer();
		VisTimer.start();
	}
	if (iC == 11) {
		page8.show();
		MainVis = Vis6;
		OneFrame = 255/(MainVis.getLength());
		MakeTimer();
		VisTimer.start();
	}
	if (iC == 12) {
		page9.show();
		MainVis = Vis7;
		OneFrame = 255/(MainVis.getLength());
		MakeTimer();
		VisTimer.start();
	}
	if (iC == 13) {
		page10.show();
		MainVis = Vis8;
		OneFrame = 255/(MainVis.getLength());
		MakeTimer();
		VisTimer.start();
	}
	if (iC == 14) {
		page11.show();
		MainVis = Vis9;
		OneFrame = 255/(MainVis.getLength());
		MakeTimer();
		VisTimer.start();
	}
	if (iC == 15) {
		page12.show();
		MainVis = Vis10;
		OneFrame = 255/(MainVis.getLength());
		MakeTimer();
		VisTimer.start();
	}
	if (iC == 16) {
		page13.show();
		MainVis = Vis11;
		OneFrame = 255/(MainVis.getLength());
		MakeTimer();
		VisTimer.start();
	}
	if (iC == 17) {
		page14.show();
		MainVis = Vis12;
		OneFrame = 255/(MainVis.getLength());
		MakeTimer();
		VisTimer.start();
	} */

	complete;

}

UpdateOptions(int iC) {
	
	if (iC == 100) {
		if (VisStyle) {
			VisStyle = 0;
			visnormal.setXMLParam("bandwidth","wide");
			vismirror1.setXMLParam("bandwidth","wide");
			vismirror2.setXMLParam("bandwidth","wide");
		}
		else {
			VisStyle = 1;
			visnormal.setXMLParam("bandwidth","thin");
			vismirror1.setXMLParam("bandwidth","thin");
			vismirror2.setXMLParam("bandwidth","thin");
		}
	}

	if (iC == 101) {
		if (Caps) {
			Caps = 0;
			visnormal.setXMLParam("peaks","0");
			vismirror1.setXMLParam("peaks","0");
			vismirror2.setXMLParam("peaks","0");
		}
		else {
			Caps = 1;
			visnormal.setXMLParam("peaks","1");
			vismirror1.setXMLParam("peaks","1");
			vismirror2.setXMLParam("peaks","1");
		}
	}
	

}

// Custom Vis Functions

VisTimer.onTimer() {
	Level = ((System.getLeftVuMeter() + System.getRightVuMeter())/2);
	//UpdateAnimation(Level/OneFrame);
}

/*UpdateAnimation(Int Frame){
	{
	MainVis.setStartFrame(LastFrame);
     	MainVis.setEndFrame(Frame);
     	MainVis.play();
     	LastFrame = Frame;
	}
} */

MakeTimer() {
		VisTimer = new Timer;
		VisTimer.setDelay(10);
}


