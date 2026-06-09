// Base parameters for `fm` command-line calls.
// Mirrors the OpenAIParameters shape so both backends feel consistent.

// MARK:- execution params

// Function to call asynchronously each time data is received. /!\ Be sure your current process not die.
property onData : 4D:C1709.Function

// Function to call asynchronously when finished. /!\ Be sure your current process not die.
property onTerminate : 4D:C1709.Function

// Function to call asynchronously when finished with success. /!\ Be sure your current process not die.
property onResponse : 4D:C1709.Function

// Function to call asynchronously when finished with errors. /!\ Be sure your current process not die.
property onError : 4D:C1709.Function

// Function to call asynchronously when finished or when data is received. /!\ Be sure your current process not die.
property formula : 4D:C1709.Function

// replace This object when calling formula
property _formulaThis : Object

// If error occurs, throw it.
property throw : Boolean:=False:C215

// Duration in seconds before the external process is killed if still alive (0 = no timeout).
property timeout : Real:=0

// MARK:- common params

// Model to use: "system" (on-device, default) or "pcc" (Private Cloud Compute). Empty = `fm` default.
property model : Text:=""

// MARK:- constructor
Class constructor($object : Object)
	If ($object=Null:C1517)
		return
	End if

	// copy simple attributes
	var $key : Text
	For each ($key; $object)
		This:C1470[$key]:=$object[$key]
	End for each

	// copy functions (not always available in $object keys)
	For each ($key; ["onData"; "onTerminate"; "onResponse"; "onError"; "formula"])
		If ((This:C1470[$key]=Null:C1517) && ($object[$key]#Null:C1517))
			This:C1470[$key]:=$object[$key]
		End if
	End for each

	This:C1470._formulaThis:=$object

	// MARK:- command line

	// Build the list of command-line arguments (flags + quoted values), without the executable and subcommand.
Function args() : Collection
	var $args : Collection:=[]
	If (Length:C16(String:C10(This:C1470.model))>0)
		$args.push("--model")
		$args.push(This:C1470._quote(This:C1470.model))
	End if
	return $args

	// Wrap a value in double quotes, escaping backslashes and double quotes, so it survives command-line tokenization.
Function _quote($value : Text) : Text
	$value:=Replace string:C233(String:C10($value); "\\"; "\\\\")
	$value:=Replace string:C233($value; "\""; "\\\"")
	return "\""+$value+"\""

Function _isAsync() : Boolean
	return ((This:C1470.onData#Null:C1517) && (OB Instance of:C1731(This:C1470.onData; 4D:C1709.Function)))\
		 || ((This:C1470.onTerminate#Null:C1517) && (OB Instance of:C1731(This:C1470.onTerminate; 4D:C1709.Function)))\
		 || ((This:C1470.onResponse#Null:C1517) && (OB Instance of:C1731(This:C1470.onResponse; 4D:C1709.Function)))\
		 || ((This:C1470.onError#Null:C1517) && (OB Instance of:C1731(This:C1470.onError; 4D:C1709.Function)))\
		 || ((This:C1470.formula#Null:C1517) && (OB Instance of:C1731(This:C1470.formula; 4D:C1709.Function)))
