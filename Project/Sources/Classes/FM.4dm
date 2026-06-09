// FM - singleton wrapper around the macOS `fm` command-line tool (Apple Foundation Models).
//
// Access through cs.FM.me:
//   var $text : Text:=cs.FM.me.respond("What is Swift?")
//   var $n : Integer:=cs.FM.me.tokenCount("Hello world")
//   var $schema : Object:=cs.FM.me.schema({name: "Person"; properties: [{name: "name"; type: "string"}; {name: "age"; type: "integer"}]})
//
// Streaming: pass onData/onTerminate in the options object and call from a CALL WORKER context.

// Path or name of the `fm` executable (resolved through PATH if not absolute).
property executable : Text

// Default model when none is specified: "system" (on-device) or "pcc".
property defaultModel : Text

singleton Class constructor
	This:C1470.executable:="fm"
	This:C1470.defaultModel:="system"

	// MARK:- commands

	// Generate a response to a prompt.
	// Synchronous: returns the generated Text.
	// Asynchronous (when options carry onData/onTerminate/...): returns a cs.FMRespondResult immediately.
Function respond($prompt : Text; $parameters : Object) : Variant
	var $p : cs:C1710.FMRespondParameters
	If (OB Instance of:C1731($parameters; cs:C1710.FMRespondParameters))
		$p:=$parameters
	Else
		$p:=cs:C1710.FMRespondParameters.new($parameters)
	End if
	If (Length:C16(String:C10($p.model))=0)
		$p.model:=This:C1470.defaultModel
	End if

	var $async : Boolean:=$p._isAsync()
	If ($async)
		$p.stream:=True:C214
	End if

	var $result : cs:C1710.FMResult:=This:C1470._run("respond"; $p; cs:C1710.FMRespondResult; $prompt; Not:C34($async))
	If ($async)
		return $result
	End if
	return $result.text

	// Count the tokens in a prompt (on-device system model only).
Function tokenCount($prompt : Text; $parameters : Object) : Integer
	var $p : cs:C1710.FMTokenCountParameters
	If (OB Instance of:C1731($parameters; cs:C1710.FMTokenCountParameters))
		$p:=$parameters
	Else
		$p:=cs:C1710.FMTokenCountParameters.new($parameters)
	End if
	var $result : cs:C1710.FMResult:=This:C1470._run("token-count"; $p; cs:C1710.FMTokenCountResult; $prompt; True:C214)
	return Num:C11($result.text)

	// Generate a JSON generation schema for an object type. Returns the parsed schema (or Null).
Function schema($parameters : Object) : Object
	var $p : cs:C1710.FMSchemaParameters
	If (OB Instance of:C1731($parameters; cs:C1710.FMSchemaParameters))
		$p:=$parameters
	Else
		$p:=cs:C1710.FMSchemaParameters.new($parameters)
	End if
	var $result : cs:C1710.FMSchemaResult:=This:C1470._run("schema object"; $p; cs:C1710.FMSchemaResult; Null:C1517; True:C214)
	return $result.schema

	// Check model availability (system, pcc, or all if $model is empty).
Function available($model : Text) : cs:C1710.FMAvailableResult
	var $p : cs:C1710.FMParameters:=cs:C1710.FMParameters.new(Null:C1517)
	If (Length:C16(String:C10($model))>0)
		$p.model:=$model
	End if
	return This:C1470._run("available"; $p; cs:C1710.FMAvailableResult; Null:C1517; True:C214)

	// Check model quota usage (system, pcc, or all if $model is empty).
Function quotaUsage($model : Text) : cs:C1710.FMQuotaUsageResult
	var $p : cs:C1710.FMParameters:=cs:C1710.FMParameters.new(Null:C1517)
	If (Length:C16(String:C10($model))>0)
		$p.model:=$model
	End if
	return This:C1470._run("quota-usage"; $p; cs:C1710.FMQuotaUsageResult; Null:C1517; True:C214)

	// Start a Chat Completions API server. Long-running: returns immediately.
	// Stop it with: $result.worker.terminate()
Function serve($parameters : Object) : cs:C1710.FMResult
	var $p : cs:C1710.FMServeParameters
	If (OB Instance of:C1731($parameters; cs:C1710.FMServeParameters))
		$p:=$parameters
	Else
		$p:=cs:C1710.FMServeParameters.new($parameters)
	End if
	return This:C1470._run("serve"; $p; cs:C1710.FMResult; Null:C1517; False:C215)

	// True if the `fm` executable can be run on this machine.
Function installed() : Boolean
	If (Is Windows:C1573)  // fm is macOS-only
		return False:C215
	End if
	var $worker : 4D:C1709.SystemWorker
	Try
		$worker:=4D:C1709.SystemWorker.new(This:C1470.executable+" --help"; {timeout: 10})
	Catch
		return False:C215
	End try
	If ($worker=Null:C1517)
		return False:C215
	End if
	$worker.wait(10)
	return Bool:C1537($worker.terminated) && (($worker.errors=Null:C1517) || ($worker.errors.length=0))

	// MARK:- core

	// Run an `fm` subcommand. Builds the command line, optionally feeds $stdin, and either
	// waits synchronously ($wait) or wires async callbacks via cs._FMAsyncOptions.
Function _run($subcommand : Text; $parameters : cs:C1710.FMParameters; $resultClass : 4D:C1709.Class; $stdin : Variant; $wait : Boolean) : cs:C1710.FMResult
	var $result : cs:C1710.FMResult:=$resultClass.new()

	var $command : Text:=This:C1470.executable+" "+$subcommand
	var $args : Collection:=$parameters.args()
	If ($args.length>0)
		$command:=$command+" "+$args.join(" ")
	End if
	$result.command:=$command

	var $async : Boolean:=$parameters._isAsync()
	var $worker : 4D:C1709.SystemWorker
	Try
		If ($async)
			$worker:=4D:C1709.SystemWorker.new($command; cs:C1710._FMAsyncOptions.new($parameters; $resultClass; $result))
		Else
			var $options : Object:={dataType: "text"}
			If ($parameters.timeout>0)
				$options.timeout:=$parameters.timeout
			End if
			$worker:=4D:C1709.SystemWorker.new($command; $options)
		End if
	Catch
		$worker:=Null:C1517
	End try

	If ($worker=Null:C1517)
		$result._failWith([cs:C1710.FMError.new(-1; "Unable to start: "+$command; $command)])
		return $result
	End if

	$result.worker:=$worker

	If ($stdin#Null:C1517)
		$worker.postMessage(String:C10($stdin))
	End if
	$worker.closeInput()

	If ($wait)
		If ($parameters.timeout>0)
			$worker.wait($parameters.timeout)
		Else
			$worker.wait()
		End if
		If (Bool:C1537($parameters.throw))
			$result.throw()
		End if
	End if

	return $result
