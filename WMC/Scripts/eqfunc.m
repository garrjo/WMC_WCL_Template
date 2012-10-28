/*************************************************************************************************************
 ~ eqfunc.m by Peacemaker 2012
 
 ~ Made for WMC default player v1.0
 
 ~ Script Overview: This script controls the resizing of the playlist window and reloacting image placements.

*************************************************************************************************************/

#include <lib/std.mi>
#include <lib/config.mi>

Global Container PL;
Global Layout plNormal;
Global Group mainGrp;
Global Layer plFrameBottomRight;
Global Button resizeFrameBtn;
Global Int plCurH, plCurW, plDefH, plDefW, plDiffH, plDiffW;

System.onScriptLoaded() {
	mainGrp = getScriptGroup();
	resizeFrameBtn = mainGrp.findObject("wa2.player.pl.resize.dummy.button");
	plFrameBottomRight = mainGrp.findObject("wa2.player.pl.frame.bottom.right");
	plDefW = 275;
	plDefH = 116;
}

resizeFrameBtn.onLeftButtonUp(int x, int y) {
	/*plDiffW = ((x - plDefW)-plDefW);  stuff to do*/
	plFrameBottomRight.setXMLParam("x","200"); /*("79"+plDiffW); stuff to do*/
}
System.onScriptUnloading() 
{
}