/*********************************************************************

PLAYLIST COLOR (ADAPTER) HEXTORGB FROM PLEDIT.TXT

*********************************************************************/
#include <lib/std.mi>

// **** global variables *****

global Container plcont;
global Layout pl;
global Windowholder playlistobj;

global slider redslider, greenslider, blueslider, textSlider;

System.onScriptLoaded() {
  plcont = getContainer("PL");
  pl = plcont.getLayout("normal");
  playlistobj = pl.findObject("pl_holder");
  playlistobj.setXMLParam("backgroundcolor",(integerToString(255)+","+integerToString(255)+","+integerToString(255)));
}