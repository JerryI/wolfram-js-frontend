(*import shared libraries*)
Import/@FileNames["*.wls", "shared"];

(*load core modules*)
Import["modules/db.wls"];
Import["modules/misc.wls"];
Import["modules/notifications.wls"];
Import["modules/svhost.wls"];
Import["modules/watcher.wls"];

(*notebooks support*)
Import["modules/converter.wls"];
Import["modules/cells.wls"];
Import["modules/notebook.wls"];

(*load libs from the services*)
Import/@FileNames["lib.wls", "services", 2];

(*check*)
If[FileExistsQ["running.lock"],
  console["log", ">>crashed before"];
  PushNotification["kitchen", "Wolfram Engine crashed. We are sorry &#128546;"];
];

(*clear pages*)
Put["running.lock"];

(*dunno if it helps here*)
$HistoryLength = 0;

temp = <||>;

settings["processes"] = <||>;
settings["memory"] = {Round[MemoryInUse[]/1024,1]/1024//N};
settings["cpu"] = 0;
settings["notifications"] = <||>;

(*debug stream*)
$Messages = {OpenWrite[Method -> "Toast"]};

(*async tasks*)

CronTasks["ping pong"] = SessionSubmit[
 ScheduledTask[WebSocketBroadcast[server, Pong[]], 
  Quantity[5, "Seconds"]]];

CronTasks["hide notifications"] = SessionSubmit[
 ScheduledTask[
(settings["notifications"][#]["hide"] = True) &/@ (Select[settings["notifications"]//Keys,  (settings["notifications", #, "date"] < (Now - settings["notifications", #, "duration"]))&]),
  Quantity[2, "Minutes"]]];

CronTasks["remove notifications"] = SessionSubmit[
 ScheduledTask[
(settings["notifications"][#] = .;)&/@ (Select[settings["notifications"]//Keys,  (settings["notifications"][#]["date"] < (Now - Quantity[1, "Days"]))&]),
  Quantity[6, "Hours"]]];  

CronTasks["backup"] = SessionSubmit[
 ScheduledTask[CBackup,
  Quantity[60, "Minutes"]]];

CronTasks["timestamp"] = SessionSubmit[
 ScheduledTask[console["log", "<*Now*>"]; console["memory stat"];,
  Quantity[20, "Minutes"]]]; 

CronTasks["forecast"] = SessionSubmit[
 ScheduledTask[Forecast, "Daily"]];    
 
    

  

  

