#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;#Persistent
#NoTrayIcon
#SingleInstance force
#WinActivateForce
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1
SetMouseDelay, -1
SetWinDelay, -1

global UnsavedData := 0
global wStatus := "Not Found"
global wId := "-"

global gSocket
global gConnected = 0
global gTick = 0

global wNirsLab

#Include %A_ScriptDir%\bin\Socket.ahk
#Include %A_ScriptDir%\bin\EzNirsTrigger.Config.ahk
#Include %A_ScriptDir%\bin\EzNirsTrigger.Data.ahk
#Include %A_ScriptDir%\bin\EzNirsTrigger.Form.ahk

OnExit, CloseProgram
GoSub, SetWindow

Return

MainGuiClose:
  ExitApp
Return

OpenServerConfig:
  Gui, Config:+OwnerMain
  Gui, Config:Show
Return

testConnection:
  Gui, Config:Submit, NoHide
  GuiControl, Disable, ConfigGenetal

  tSocket := new TestSocket()

  tSocket.Connect([tServer, tPort += 0])
  tSocket.sendText("TEST")
Return

ConnectServer:
  UnSavedData := 1
  If (gConnected = 0)
  {
    gSocket := new ActionSocket()
    gSocket.Connect([sServer, sPort])
  }
  Else
  {
    gSocket.Disconnect()
  }
Return

ConfirmServerConfig:
  Gui, Config:Submit

  sServer := tServer
  sPort := tPort

  NewConfig := { "LAST_SERVER": sServer
               , "LAST_PORT":   sPort }
  ModifyConfig(NewConfig)
  SaveConfig()

  GuiControl, Main:, gServer, %sServer%
  GuiControl, Main:, gPort, %sPort%
Return

CancelServerConfig:
  GuiControl, Config:, tServer, %sServer%
  GuiControl, Config:, tPort, %sPort%

  Gui, Config:Submit
Return

CloseProgram:
  If (gConnected = 1)
    gSocket.Disconnect()
  
  If (UnsavedData == 1)
  {
    MsgBox, 35, Confirm, Unsaved data found, export your data before closing the program?
    IfMsgBox, Yes
    {
      GoSub, ExportFile
    }
    IfMsgBox, Cancel
    {
      Return
    }
  }
ExitApp

SetWindow:
  WinGet, wNirsLab, ,fNIRS ahk_class LVDChild ahk_exe fNIRS.exe,

  If WinExist("ahk_id" . wNirsLab) 
  {
    wStatus := "Locked"
    wId := wNirsLab
  } 
  Else 
  {
    wStatus := "Not Found"
    wId := "-"
  }

  GuiControl, Main:, gStatus, %wStatus%
  GuiControl, Main:, gId, %wId%
Return

FindWindow:
  GoSub, SetWindow

  if(wId == "-")
  {
    MsgBox, 16, Error, Can't fetch the window of LabNirs!
  }
Return

ClearList:
  MsgBox, 52, Confirm, This action will clear all the data in the log list, are you sure?
  IfMsgBox, Yes
  {
    Gui, Main:Default
    LV_Delete()
  }
Return

ExportFile:
  Gui, Main:Default
  Gui, Main:ListView, LogList

  FormatTime, CurrentDate , , yy-MM-dd HH-mm-ss
  FileName = %A_ScriptDir%\Data\%CurrentDate%.csv

  IfExist, %FileName%
    FileDelete, %FileName%
  
  Header := ", Time, Delay, Data`r`n"
  FileAppend, %Header%, %FileName%

  Loop % LV_GetCount() 
  {
    line := ""
    Row := A_Index
    Loop % LV_GetCount("Column") 
    {
      Col := A_Index
      LV_GetText(RetrievedText, Row, Col)
      If (Col <> 1)
      {
        line = %line%, %RetrievedText%
      }
      Else
      {
        line = %RetrievedText%
      }
    }

    Fileappend, %Line%`r`n, %FileName%
  }

  UnSavedData := 0
  MsgBox, 36, Confirm, The data have been successfully exported, open it?
  IfMsgBox, Yes
  {
    Run, %FileName%
  }
Return

class TestSocket extends SocketTCP 
{
  onErrorConn() 
  {
    GuiControl, Config:Enable, ConfigGenetal

    MsgBox, 16, Error, Can't connect to the server!
  }

  onSent() 
  {
    GuiControl, Config:Enable, ConfigGenetal
    this.Disconnect()

    MsgBox, 64, Success, successfully connected to the server!
  }
}

class ActionSocket extends SocketTCP 
{
  onConnected()
  {
    gConnected := 1
    gTick := A_TickCount

    GuiControl, Main:, Status, assets\connected.png
    GuiControl, Main:Disable, ConfigButton
    GuiControl, Main:, ConnectButton, &Disconnect

    gSocket.sendText("TP trg")
  }

  onDisConnected()
  {
    gConnected := 0

    GuiControl, Main:, Status, assets\disconnected.png
    GuiControl, Main:Enable, ConfigButton
    GuiControl, Main:, ConnectButton, &Connect
  }

  onRecv()
  {
    RecvTime := A_TickCount
    TickTime := recvTime - gTick


		this.Buffer .= this.RecvText(,, "CP0")
		Lines := StrSplit(this.Buffer, "`n", "`r")
		this.Buffer := Lines.Pop()
		for Index, Line in Lines
		{
      VarSetCapacity(ConvBuf, StrPut(Line, "CP0"))
      StrPut(Line, &ConvBuf, "CP0")
      Command := StrGet(&ConvBuf, "UTF-8")

      If RegExMatch(Command, "^ST|EN|CL|ZR|DR|LK|UL$")
      {
        CommandType := Command
        RT := this.clickButton(Command, RecvTime)
      }
      Else
      Else If !RegExMatch(Command, "^LK|UL|EX$|^EX ")
      {
        CommandType := "MK"
        RT := this.clickButton("MK", RecvTime)
      }
      Else
      {
        RT := ""
      }

      WinActivate, ahk_id %wNirsLab%

      If RegExMatch(Command, "^LK$|^UL$")
      {
        If (Command == "LK")
        {
          Gui, Main:+AlwaysOnTop
          GuiControl, Main:Choose, MainTab, 2
        }
        Else
        {
          Gui, Main:-AlwaysOnTop
        }
      }
      Else If (Command == "EX")
      {
        GoSub, ExportFile
      }
      Else
      {
      }

      Gui, Main:Default

      ThisIcon := IconIndex[CommandType]
      IconCommand = Icon%ThisIcon%
      LV_ADD(IconCommand, TickTime, RT, Command)
      UnsavedData := 1
    }
  }

  onErrorConn()
  {
    MsgBox, 16, Error, Can't connect to the server!
  }
}