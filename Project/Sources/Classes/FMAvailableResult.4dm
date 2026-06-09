// Result of `fm available`. Parses the human-readable availability status.

Class extends FMResult

// True if the checked model is reported as available.
Function get available : Boolean
	var $text : Text:=This:C1470.text
	return (Position:C15("available"; $text)>0) && (Position:C15("not available"; $text)=0)
