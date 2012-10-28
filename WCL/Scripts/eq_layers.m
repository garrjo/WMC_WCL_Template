#include <lib/std.mi>

Global Slider pre, eq1, eq2, eq3, eq4, eq5, eq6, eq7, eq8, eq9, eq10;
Global Layer pre_layer, eq1back, eq2back, eq3back, eq4back, eq5back, eq6back, eq7back, eq8back, eq9back, eq10back;
Global String XMLtext;
Function int GetSliderValue(int currentslider);

System.onScriptLoaded()
{
  pre = getContainer("eq").getlayout("normal").getObject("preamp");
  pre_layer = getContainer("eq").getlayout("normal").getObject("preamp_layer");
  eq1 = getContainer("eq").getlayout("normal").getObject("eq1");
  eq1back = getContainer("eq").getlayout("normal").getObject("eq1back");
  eq2 = getContainer("eq").getlayout("normal").getObject("eq2");
  eq2back = getContainer("eq").getlayout("normal").getObject("eq2back");
  eq3 = getContainer("eq").getlayout("normal").getObject("eq3");
  eq3back = getContainer("eq").getlayout("normal").getObject("eq3back");
  eq4 = getContainer("eq").getlayout("normal").getObject("eq4");
  eq4back = getContainer("eq").getlayout("normal").getObject("eq4back");
  eq5 = getContainer("eq").getlayout("normal").getObject("eq5");
  eq5back = getContainer("eq").getlayout("normal").getObject("eq5back");
  eq6 = getContainer("eq").getlayout("normal").getObject("eq6");
  eq6back = getContainer("eq").getlayout("normal").getObject("eq6back");
  eq7 = getContainer("eq").getlayout("normal").getObject("eq7");
  eq7back = getContainer("eq").getlayout("normal").getObject("eq7back");
  eq8 = getContainer("eq").getlayout("normal").getObject("eq8");
  eq8back = getContainer("eq").getlayout("normal").getObject("eq8back");
  eq9 = getContainer("eq").getlayout("normal").getObject("eq9");
  eq9back = getContainer("eq").getlayout("normal").getObject("eq9back");
  eq10 = getContainer("eq").getlayout("normal").getObject("eq10");
  eq10back = getContainer("eq").getlayout("normal").getObject("eq10back");

  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(pre.getPosition()));
  pre_layer.setXMLParam("image", XMLtext);
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(eq1.getPosition()));
  eq1back.setXMLParam("image", XMLtext);
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(eq2.getPosition()));
  eq2back.setXMLParam("image", XMLtext);
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(eq3.getPosition()));
  eq3back.setXMLParam("image", XMLtext);
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(eq4.getPosition()));
  eq4back.setXMLParam("image", XMLtext);
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(eq5.getPosition()));
  eq5back.setXMLParam("image", XMLtext);
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(eq6.getPosition()));
  eq6back.setXMLParam("image", XMLtext);
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(eq7.getPosition()));
  eq7back.setXMLParam("image", XMLtext);
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(eq8.getPosition()));
  eq8back.setXMLParam("image", XMLtext);
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(eq9.getPosition()));
  eq9back.setXMLParam("image", XMLtext);
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(eq10.getPosition()));
  eq10back.setXMLParam("image", XMLtext);

}

pre.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  pre_layer.setXMLParam("image", XMLtext);

}

eq1.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq1back.setXMLParam("image", XMLtext);

}
eq2.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq2back.setXMLParam("image", XMLtext);

}
eq3.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq3back.setXMLParam("image", XMLtext);

}
eq4.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq4back.setXMLParam("image", XMLtext);

}
eq5.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq5back.setXMLParam("image", XMLtext);

}
eq6.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq6back.setXMLParam("image", XMLtext);

}
eq7.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq7back.setXMLParam("image", XMLtext);

}
eq8.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq8back.setXMLParam("image", XMLtext);

}
eq9.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq9back.setXMLParam("image", XMLtext);

}
eq10.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq10back.setXMLParam("image", XMLtext);
}

int GetSliderValue(Int CurrentSlider)
{
  if(CurrentSlider<=-1)
  {
   CurrentSlider = ((CurrentSlider*27)/255)-1;
  }
  else if(CurrentSlider>=0)
  {
    CurrentSlider = ((CurrentSlider*27)/255)+1;
  }
  return CurrentSlider;
}