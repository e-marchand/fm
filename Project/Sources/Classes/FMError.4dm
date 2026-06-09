// Structured error for a failed `fm` execution, so FMResult.throw() yields a usable 4D error.

property errCode : Integer
property message : Text

property exitCode : Integer
property command : Text

Class constructor($exitCode : Integer; $message : Text; $command : Text)
	This:C1470.exitCode:=$exitCode
	This:C1470.errCode:=$exitCode
	This:C1470.command:=String:C10($command)
	If (Length:C16(String:C10($message))>0)
		This:C1470.message:=$message
	Else
		This:C1470.message:="fm exited with code "+String:C10($exitCode)
	End if
