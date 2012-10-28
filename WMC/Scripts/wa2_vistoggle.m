//-----------------------------------------------
// 'Visualization Menu' script
//
// Brings up a nifty menu,
// containing Classic Vis and AVS Vis.
//
// Made for Bizzy D.'s Wa2 -> Wa3 skin converter
// by ThePlague (Linus Brolin)
//-----------------------------------------------

#include <lib/std.mi>

Global Button VisToggle; 
Global Popupmenu VisChoice;
Global Int choice;
Global Boolean OldVis, AvsVis;
Global Wac classic;
Global Wac avs;

System.onScriptLoaded()
{
  VisToggle = System.getContainer("main").getLayout("normal").getObject("vistog");
  // Get components
  classic = getWac("{DED13748-0AA6-48AE-8045-9A4975E51253}");
  avs = getWac("{0000000A-000C-0010-FF7B-01014263450C}");

  VisChoice = New PopupMenu;
  VisChoice.addCommand("Visualization Menu",5,0,1);
  VisChoice.addSeparator();
  VisChoice.addCommand("Classic Visualization",1,0,0);
  VisChoice.addCommand("Visualization Studio",2,0,0);


// Trying to make it check the command at startup if the component
// is loaded (doesn't work yet though).
//----------------------------------------------------------------
//  VisChoice.checkCommand(1, (classic.isVisible() == true));
//  VisChoice.checkCommand(2, (avs.isVisible() == true));
//----------------------------------------------------------------
}

VisToggle.OnLeftButtonUp(int x, int y)
{
  VisChoice.checkCommand(1, (OldVis == 1));
  VisChoice.checkCommand(2, (AvsVis == 1));
  choice = VisChoice.popAtMouse();
  If (choice == 1){
    If (classic.isVisible() == 0){
      OldVis = 1;
      classic.show();
    }else if (classic.isVisible() == 1){
      OldVis = 0;
      classic.hide();
    }
  }else if (choice == 2){
    If (avs.isVisible() == 0){
      AvsVis = 1;
      avs.show();
    }else if (avs.isVisible() == 1){
      AvsVis = 0;
      avs.hide();
    }
  }
  Complete;
}

