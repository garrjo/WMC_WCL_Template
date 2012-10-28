#include "lib/std.mi"

Global Slider volslide;
Global Layer vollayer;
Global String XMLtext;

System.onScriptLoaded()
{
  volslide = getContainer("Main").getLayout("normal").getObject("Volume");
  vollayer = getContainer("Main").getLayout("normal").getObject("myVolLayer");

  XMLtext = "voltest.testslider"+integerToString((volslide.getPosition()*27)/255);
  vollayer.setXMLParam("image", XMLtext);
}

volslide.onSetPosition(int newpos)
{
  XMLtext = "voltest.testslider"+integerToString((newpos*27)/255);

  vollayer.setXMLParam("image", XMLtext);
}