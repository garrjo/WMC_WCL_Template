#include "lib/std.mi"

Global Togglebutton dblToggle;
Global Layout norm, EQnorm;     // in WA2 doublesize affects
                                // main window AND EQ window

System.onScriptLoaded()
{
  MainNorm = getContainer("main").getlayout("normal");
  EQnorm = getContainer("eqMain").getlayout("normal");
  PLnorm = getContainer("eqMain").getlayout("normal");
  dblToggle = norm.getObject("toggledoublesize");
}

dblToggle.onLeftClick()
{
  if (MainNorm.getScale() < 2)
  {
    MainNorm.setScale(MainNorm.getScale()*2);
    MainNorm.setx(MainNorm.getx()*2);
  }
  else
  {
    MainNorm.setScale(MainNorm.getScale()/2);
  }
  if (EQnorm.getScale() < 2)
  {
    EQnorm.setScale(EQnorm.getScale()*2);
    eqnorm.setx(EQnorm.getx()*2);
  }
  else
  {
    EQnorm.setScale(EQnorm.getScale()/2);
  }

  if(PLnorm.getScale() < 2)
  {
    PLnorm.setScale(PLnorm.getScale()*2);
    PLnorm.setx(PLnorm.getx()*2);
  }
  else
  {
    PLnorm.setScale(PLnorm.getScale()/2);
  }
}