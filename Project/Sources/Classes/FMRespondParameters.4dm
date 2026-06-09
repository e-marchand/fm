// Parameters for `fm respond`.
// The prompt itself is passed on stdin by FM.respond(), not as an argument.

// Instructions for the model to follow (system prompt).
property instructions : Text:=""

// Path to a JSON schema file constraining the output (guided generation).
property schemaFile : Text:=""

// Additional text segments to include in the prompt (repeatable).
property text : Collection

// Image file paths to include in the prompt (repeatable).
property image : Collection

// Path to a saved transcript to seed the conversation.
property loadTranscript : Text:=""

// Name under which to save the transcript after responding.
property saveTranscript : Text:=""

// Stream the output as it is generated. Set automatically when async callbacks are provided.
property stream : Boolean:=False:C215

// Use greedy sampling (deterministic).
property greedy : Boolean:=False:C215

// Print verbose output.
property verbose : Boolean:=False:C215

// System model use case: "general" (default) or "content-tagging".
property useCase : Text:=""

// System model guardrail level: "default" or "permissive-content-transformations".
property guardrails : Text:=""

Class extends FMParameters

Class constructor($object : Object)
	Super:C1705($object)

Function args() : Collection
	var $args : Collection:=Super:C1706.args()

	If (Length:C16(This:C1470.instructions)>0)
		$args.push("--instructions")
		$args.push(This:C1470._quote(This:C1470.instructions))
	End if
	If (Length:C16(This:C1470.schemaFile)>0)
		$args.push("--schema")
		$args.push(This:C1470._quote(This:C1470.schemaFile))
	End if
	var $segment : Text
	For each ($segment; This:C1470.text || [])
		$args.push("--text")
		$args.push(This:C1470._quote($segment))
	End for each
	var $path : Text
	For each ($path; This:C1470.image || [])
		$args.push("--image")
		$args.push(This:C1470._quote($path))
	End for each
	If (Length:C16(This:C1470.loadTranscript)>0)
		$args.push("--load-transcript")
		$args.push(This:C1470._quote(This:C1470.loadTranscript))
	End if
	If (Length:C16(This:C1470.saveTranscript)>0)
		$args.push("--save-transcript")
		$args.push(This:C1470._quote(This:C1470.saveTranscript))
	End if
	If (Length:C16(This:C1470.useCase)>0)
		$args.push("--use-case")
		$args.push(This:C1470._quote(This:C1470.useCase))
	End if
	If (Length:C16(This:C1470.guardrails)>0)
		$args.push("--guardrails")
		$args.push(This:C1470._quote(This:C1470.guardrails))
	End if
	If (This:C1470.greedy)
		$args.push("--greedy")
	End if
	If (This:C1470.verbose)
		$args.push("--verbose")
	End if
	// Streaming on/off (off by default for clean synchronous capture)
	$args.push((This:C1470.stream) ? "--stream" : "--no-stream")

	return $args
