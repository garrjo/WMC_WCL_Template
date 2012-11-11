#include <lib/std.mi>

#define VIS_GUID "{0000000A-000C-0010-FF7B-01014263450C}"

Global WindowHolder avs;
Global Timer TmrCallback;

System.onScriptUnloading() {
  delete TmrCallback;
}

System.onScriptLoaded() {
  avs = getScriptGroup().findObject("avs");

  TmrCallback = new timer;
  TmrCallback.setDelay(1);
}

TmrCallback.onTimer() {
  if (!system.isNamedWindowVisible(VIS_GUID)) return;
  
  stop();
  region r = new region;
  r.loadFromBitmap("avs.map");
  avs.setRegion(r);
  delete r;
}

System.onLookForComponent(String guid) {
  if (guid == VIS_GUID) {
    TmrCallback.start();
    return avs;
  }
}
