;This file discribes the location of each button in the GUI of NIRS Lab controling program,
;  St => Start, EN => Stop, CL => Clear, ZR => Zero Reset, DR => Drift Reset
global NirsLabBtnColors := {}
NirsLabBtnColors["Active"] :=   { "ST": "84FFDA", "EN": "FFA0C6", "CL": "FFFFFF", "MK": "FAB9FF", "ZR": "44DBFF", "DR": "CAFFFF"}
NirsLabBtnColors["Deactive"] := { "ST": "A0D1C3", "EN": "D1ABBB", "CL": "D1D1D1", "MK": "CFB5D1", "ZR": "87C3D1", "DR": "BCD1D1"}
global NirsLabBtnColorPosition := { "ST": [300, 1060], "EN": [400, 1060], "CL": [500, 1075], "MK": [565, 1075], "ZR": [635, 1075], "DR": [700, 1075]}
global NirsLabBtnClickPosition := { "ST": [300, 1090], "EN": [400, 1090], "CL": [500, 1090], "MK": [565, 1090], "ZR": [635, 1090], "DR": [700, 1090]}
