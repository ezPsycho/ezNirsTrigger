DefaultConfig := { "LAST_SERVER": "127.0.0.1"
                 , "LAST_PORT":   "23333"
                 , "AUTO_CONNECT": "0" }

global ConfigFileName
global Config

ConfigFileName = %A_ScriptDir%\.config
Config := MergeConfig(DefaultConfig, ReadConfig())

global sServer := Config["LAST_SERVER"]
global sPort := Config["LAST_PORT"]
global sAutoConnect := Config["AUTO_CONNECT"]

ModifyConfig(ReplaceConfig)
{
  Config := MergeConfig(Config, ReplaceConfig)
}

SaveConfig()
{
  IfExist, %ConfigFileName%
    FileDelete, %ConfigFileName%

  For Key, Value in Config
  {
    ConfigLine = %key%, %Value%
    FileAppend, %ConfigLine%`r`n, %ConfigFileName%
  }
}

ReadConfig()
{
  ConfigFileContent := {}

  IfExist %ConfigFileName%
  {
    Loop, Read, %ConfigFileName% 
    {
      ConfigLine := StrSplit(A_LoopReadLine, ",")
      ConfigFileContent[trim(ConfigLine[1])] := trim(ConfigLine[2])
    }
  }

  Return ConfigFileContent
}

MergeConfig(Original, New) 
{
  Result := Original

  For Key, Value in New
  {
    Result[Key] := Value
  }

  Return Result
}