global LogListIconSrc := ["Default", "ST", "EN", "CL", "MK", "ZR", "DR", "LT", "LK", "UL", "EX", "ER", "PING", "WHO", "RS"]
global IconIndex := {"ST": 2, "EN": 3, "CL": 4, "MK": 5, "ZR": 6, "DR": 7, "LK": 9, "UL": 10, "EX": 11, "ER": 12, "PING": 13, "WHO": 14, "RS": 15}

Menu, Tray, Icon, assets\Icon.ico

Gui, Main: New, -MaximizeBox +MinSize546x, ezNirsTrigger
Gui, Font, s8 w500, Segoe UI
Gui, Add, Tab3, vMainTab, General|Log|About

Gui, Add, Picture, w36 h36 vStatus, assets\disconnected.png
Gui, Add, Text   , xp+50  yp+2 w310, ezNirsTrigger uses the following information to connect your LabNirs with the experiment server.
Gui, Add, Text   , xp-50  yp+45, Server:
Gui, Add, Text   , xp     yp+20, Port:
Gui, Add, Text   , xp+50  yp-20 w100 vgServer, %sServer%
Gui, Add, Text   , xp     yp+20 w100 vgPort, %sPort%
Gui, Add, Text   , xp-50  yp+30, To change the experiment server you want to `nconnect to, click Server Config.
Gui, Add, Text   , xp     yp+40, To connect to the experiment and start auto `ntriggering, click Connect.
Gui, Add, Button , xp+250 yp-35 w120 h20 gOpenServerConfig vConfigButton, &Server Config
Gui, Add, Button , xp     yp+40 w120 h20 gConnectServer vConnectButton, &Connect

Gui, Add, Picture, xp-250 yp+50 w36 h36 vProgramIcon, assets\program.png
Gui, Add, Text   , xp+50  yp+2 w310, The status of the LabNirs control panel will list below, the panel must be found before making any trigger.
Gui, Add, Text   , xp-50  yp+45, Status:
Gui, Add, Text   , xp     yp+20, Id:
Gui, Add, Text   , xp+50  yp-20 vgStatus, %wStatus%
Gui, Add, Text   , xp     yp+20 vgId w100, %wId%
Gui, Add, Text   , xp-50  yp+30, To find and lock the control panel of LabNirs `nclick Find Window.
Gui, Add, Button , xp+250 yp+5 w120 h20 gFindWindow vFindWindowButton, &Find Window

Gui, Tab, 2
Gui, Add, ListView, vLogList w370 h300 0x2, Time|Delay|Data
Gui, Add, Button  , xp+270 yp+310 w100 gExportFile, &Export
Gui, Add, Button  , xp-110 yp     w100 gClearList, &Clear

Gui, Tab, 3
Gui, Add, Picture, x20 y25  w370 h93, assets\logo.png
Gui, Add, text   , x20 y120 w375 0x10
Gui, Add, Picture,        yp+10 w36 h36, assets\icon.png
Gui, Add, Text   , xp+45  yp-2  , ezNirsTrigger (Beta 1.2.2)
Gui, Add, Text   , xp     yp+17 , Cpoyright 2017 Losses Territory Studio.
Gui, Add, Text   , xp     yp+17 w310, This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published  by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
;Gui, Add, Text   , xp     yp+17 , This program is free software: you can redistribute it and/or modify `nit under the terms of the GNU General Public License as published `nby the Free Software Foundation, either version 3 of the License, or `n(at your option) any later version.
Gui, Add, Link,    xp     yp+80 w310, The icon of this program is made by <a href="https://www.flaticon.com/authors/pixel-buddha">Pixel Buddha</a>, the other icons in this program are from <a href="https://icons8.com/">Icons8</a>, and the socket library by <a href="https://github.com/G33kDude/Socket.ahk">G33kDude</a> thanks for their generous and outstanding work.
Gui, Add, Text   , xp     yp+55 w310, NOTICE: All the artwork in this program was under their own license but not GPLV3, check their own website to know more about that.

IconCount := LogListIconSrc.MaxIndex()
LogListIcons := IL_Create(IconCount)
LV_SetImageList(LogListIcons)

Loop %IconCount% {
  ThisIconName := LogListIconSrc[A_Index]
  ThisFileName = assets\%ThisIconName%.png
  IL_Add(LogListIcons, ThisFileName)
}

LV_ModifyCol(1, "80")
LV_ModifyCol(2, "70")
LV_ModifyCol(3, "170")

Gui, Config: New, -MaximizeBox -MinimizeBox +MinSize546x, ezNirsTrigger
Gui, Font, s8, Segoe UI
Gui, Add, Tab3    , vConfigGenetal, General
Gui, Add, Text    , xp+15  yp+30 , You can set your server information in this page, to confirm if the `nserver is available, click Test Connection.
Gui, Add, GroupBox, xp     yp+45 w410 h130, Server Information:
Gui, Add, Text    , xp+10  yp+30, Server &address:
Gui, Add, Text    , xp     yp+27, Server &port:
Gui, Add, Edit    , xp+150 yp-33 w220 vtServer, %sServer%
Gui, Add, Edit    , xp     yp+27 w220 vtPort  , %sPort%
Gui, Add, Button  , xp+110 yp+40 w120 gTestConnection vTestButton, &Test Connection
Gui, Tab
Gui, Add, Button  , x300     w70 gConfirmServerConfig, OK
Gui, Add, Button  , xp+80 yp w70 gCancelServerConfig, Cancel

Gui, Main:Show