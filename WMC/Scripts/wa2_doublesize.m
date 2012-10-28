#include <lib/std.mi>

Global Togglebutton dblToggle;
Global Layout Main, EQ, PL;     // in WA2 doublesize affects
                                // main window AND EQ window

System.onScriptLoaded()
{
  Main = getContainer("Main").getlayout("normal");
  EQ = getContainer("EQ").getlayout("normal");
  PL = getContainer("PL").getlayout("normal");
  dblToggle = Main.getObject("toggledoublesize");
}

dblToggle.onLeftClick()
{
  if (Main.getScale() < 2)
  {
    Main.setScale(Main.getScale()*2);
  }
  else
  {
    Main.setScale(Main.getScale()/2);
  }
  if (EQ.getScale() < 2)
  {
    EQ.setScale(EQ.getScale()*2);
  }
  else
  {
    EQ.setScale(EQ.getScale()/2);
  }
  if (PL.getScale() < 2)
  {
    PL.setScale(PL.getScale()*2);
  }
  else
  {
    PL.setScale(PL.getScale()/2);
  }
}