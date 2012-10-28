#include "lib/std.mi"

Global Togglebutton dblToggle;
Global Layout norm, EQnorm;     // in WA2 doublesize affects
                                // main window AND EQ window

System.onScriptLoaded()
{
  norm = getContainer("main").getlayout("normal");
  EQnorm = getContainer("eq").getlayout("normal");
  dblToggle = norm.getObject("toggledoublesize");
}

dblToggle.onLeftClick()
{
  if (norm.getScale() < 2)
  {
    norm.setScale(norm.getScale()*2);

  }
  else
  {
    norm.setScale(norm.getScale()/2);

  }


  if (EQnorm.getScale() < 2)
  {

    EQnorm.setScale(EQnorm.getScale()*2);
    eqnorm.setx(eqnorm.getx()*2)
  }
  else
  {

    EQnorm.setScale(EQnorm.getScale()/2);
  }
}