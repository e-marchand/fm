//%attributes = {"invisible":true}
// Test helper: records that a named async callback fired into Storage.fmEvents.
#DECLARE($name : Text)

Use (Storage:C1525.fmEvents)
	Storage:C1525.fmEvents[$name]:=Num:C11(Storage:C1525.fmEvents[$name])+1
End use
