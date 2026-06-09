// Options object passed to 4D.SystemWorker.new() for asynchronous / streaming `fm` calls.
// The worker reads the config properties (dataType, timeout) and calls the callback methods
// (bound to this instance), which dispatch to the user callbacks held in _parameters.
// Mirrors _OpenAIAsyncOptions.

// MARK:- worker config (read by 4D.SystemWorker)
property dataType : Text:="text"
// NB: `timeout` is only kept when > 0 — a present `timeout:0` tells the worker to kill the
// process after 0 seconds, so it must be absent from the options for an unbounded call.
property timeout : Integer

// MARK:- internal
property _parameters : cs:C1710.FMParameters
property _resultClass : 4D:C1709.Class
property _result : cs:C1710.FMResult

Class constructor($parameters : cs:C1710.FMParameters; $resultClass : 4D:C1709.Class; $result : cs:C1710.FMResult)
	This:C1470._parameters:=$parameters
	This:C1470._resultClass:=$resultClass
	This:C1470._result:=$result
	This:C1470.dataType:="text"
	If ($parameters.timeout>0)
		This:C1470.timeout:=$parameters.timeout
	Else
		OB REMOVE:C1226(This:C1470; "timeout")
	End if

	// MARK:- system worker callbacks
Function onData($worker : 4D:C1709.SystemWorker; $info : Object)
	If ((This:C1470._parameters.onData=Null:C1517) && (This:C1470._parameters.formula=Null:C1517))
		return
	End if

	var $chunk : cs:C1710.FMResult:=This:C1470._resultClass.new()
	$chunk.worker:=$worker
	$chunk._chunk:=String:C10($info.data)

	If (This:C1470._parameters.onData#Null:C1517)
		This:C1470._parameters.onData.call(This:C1470._parameters._formulaThis; $chunk)
	End if
	If (This:C1470._parameters.formula#Null:C1517)
		This:C1470._parameters.formula.call(This:C1470._parameters._formulaThis; $chunk)
	End if

Function onResponse($worker : 4D:C1709.SystemWorker; $info : Object)
	// final response is dispatched from onTerminate

Function onError($worker : 4D:C1709.SystemWorker; $info : Object)
	// execution errors are exposed via worker.errors and dispatched from onTerminate

Function onDataError($worker : 4D:C1709.SystemWorker; $info : Object)
	// stderr is available via worker.responseError

Function onTerminate($worker : 4D:C1709.SystemWorker; $info : Object)
	This:C1470._result.worker:=$worker
	This:C1470._result._terminated:=True:C214

	If (This:C1470._result.success)
		If ((This:C1470._parameters.onResponse#Null:C1517) && (OB Instance of:C1731(This:C1470._parameters.onResponse; 4D:C1709.Function)))
			This:C1470._parameters.onResponse.call(This:C1470._parameters._formulaThis; This:C1470._result)
		End if
	Else
		If ((This:C1470._parameters.onError#Null:C1517) && (OB Instance of:C1731(This:C1470._parameters.onError; 4D:C1709.Function)))
			This:C1470._parameters.onError.call(This:C1470._parameters._formulaThis; This:C1470._result)
		End if
	End if

	If ((This:C1470._parameters.onTerminate#Null:C1517) && (OB Instance of:C1731(This:C1470._parameters.onTerminate; 4D:C1709.Function)))
		This:C1470._parameters.onTerminate.call(This:C1470._parameters._formulaThis; This:C1470._result)
	End if
	If ((This:C1470._parameters.formula#Null:C1517) && (OB Instance of:C1731(This:C1470._parameters.formula; 4D:C1709.Function)))
		This:C1470._parameters.formula.call(This:C1470._parameters._formulaThis; This:C1470._result)
	End if
