DefaultConfig := { "LAST_SERVER": "127.0.0.1"
                 , "LAST_PORT":   "2333" }

global ConfigFileName
global Config

ConfigFileName = %A_ScriptDir%\.config
Config := MergeConfig(DefaultConfig, ReadConfig())

global sServer := Config["LAST_SERVER"]
global sPort := Config["LAST_PORT"]

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