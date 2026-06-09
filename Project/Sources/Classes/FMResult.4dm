// Base result wrapping a 4D.SystemWorker execution of the `fm` CLI.
// Lazy/guarded parsing, mirroring OpenAIResult.

// The system worker used to run `fm`.
property worker : 4D:C1709.SystemWorker

// The exact command line that was executed (for error reporting).
property command : Text:=""

// to force terminated
property _terminated : Boolean:=False:C215

// to force errors
property _errors : Collection

// when set, get text returns this chunk instead of the full response (streaming)
property _chunk : Variant

// True if the process is terminated.
Function get terminated : Boolean
	return This:C1470._terminated || ((This:C1470.worker#Null:C1517) && (Bool:C1537(This:C1470.worker.terminated)))

// Exit code of the process (-1 if unknown / not terminated normally).
Function get exitCode : Integer
	If ((This:C1470.worker=Null:C1517) || (This:C1470.worker.exitCode=Null:C1517))
		return -1
	End if
	return Num:C11(This:C1470.worker.exitCode)

// True if terminated with exit code 0 and no execution error.
Function get success : Boolean
	If (Not:C34(This:C1470.terminated))
		return False:C215
	End if
	If ((This:C1470.worker#Null:C1517) && (This:C1470.worker.errors#Null:C1517) && (This:C1470.worker.errors.length>0))
		return False:C215
	End if
	return This:C1470.exitCode=0

// Trimmed standard output (or the current chunk when streaming).
Function get text : Text
	If (This:C1470._chunk#Null:C1517)
		return String:C10(This:C1470._chunk)
	End if
	If (This:C1470.worker=Null:C1517)
		return ""
	End if
	return This:C1470._trim(String:C10(This:C1470.worker.response))

// Standard error output.
Function get errorText : Text
	If (This:C1470.worker=Null:C1517)
		return ""
	End if
	return String:C10(This:C1470.worker.responseError)

// List of errors if any.
Function get errors : Collection
	If (This:C1470._errors#Null:C1517)
		return This:C1470._errors
	End if

	var $errors : Collection:=[]
	If ((This:C1470.worker#Null:C1517) && (This:C1470.worker.errors#Null:C1517))
		var $e : Object
		For each ($e; This:C1470.worker.errors)
			$errors.push($e)
		End for each
	End if
	If (This:C1470.terminated && (This:C1470.exitCode#0))
		$errors.push(cs:C1710.FMError.new(This:C1470.exitCode; This:C1470.errorText; This:C1470.command))
	End if
	return $errors

Function throw()
	var $error : Object
	For each ($error; This:C1470.errors || [])
		throw:C1805($error)
	End for each

	// MARK:- utils

	// Parse the output as JSON, but only when it actually looks like JSON (avoids noisy parse errors).
Function _json() : Variant
	var $t : Text:=This:C1470.text
	If (Length:C16($t)=0)
		return Null:C1517
	End if
	If (($t[[1]]#"{") && ($t[[1]]#"["))
		return Null:C1517
	End if
	return Try(JSON Parse:C1218($t))

Function _failWith($errors : Collection)
	This:C1470._errors:=$errors
	This:C1470._terminated:=True:C214

Function _trim($text : Text) : Text
	var $ws : Text:=" "+Char:C90(9)+Char:C90(10)+Char:C90(13)
	var $start : Integer:=1
	var $end : Integer:=Length:C16($text)
	While (($start<=$end) && (Position:C15($text[[$start]]; $ws)>0))
		$start+=1
	End while
	While (($end>=$start) && (Position:C15($text[[$end]]; $ws)>0))
		$end-=1
	End while
	If ($end<$start)
		return ""
	End if
	return Substring:C12($text; $start; $end-$start+1)
