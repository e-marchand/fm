// Parameters for `fm token-count`.
// The prompt itself is passed on stdin by FM.tokenCount(), not as an argument.
// --quiet is always added so the output is a bare integer.

// Instructions to include in the count.
property instructions : Text:=""

// Additional text segments to include (repeatable).
property text : Collection

// Image file paths to include (repeatable).
property image : Collection

// Path to a saved transcript to seed the count.
property loadTranscript : Text:=""

Class extends FMParameters

Class constructor($object : Object)
	Super:C1705($object)

Function args() : Collection
	var $args : Collection:=Super:C1706.args()

	If (Length:C16(This:C1470.instructions)>0)
		$args.push("--instructions")
		$args.push(This:C1470._quote(This:C1470.instructions))
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
	$args.push("--quiet")

	return $args
