// Parameters for `fm serve` (Chat Completions API server).
// Use TCP (host/port) or a Unix domain socket (socket).

// Host address to bind to (TCP mode).
property host : Text:=""

// Port to listen on, 1-65535 (TCP mode).
property port : Integer:=0

// Unix domain socket path (socket mode).
property socket : Text:=""

Class extends FMParameters

Class constructor($object : Object)
	Super:C1705($object)

	// No --model for serve. Build from scratch.
Function args() : Collection
	var $args : Collection:=[]

	If (Length:C16(This:C1470.host)>0)
		$args.push("--host")
		$args.push(This:C1470._quote(This:C1470.host))
	End if
	If (This:C1470.port>0)
		$args.push("--port")
		$args.push(String:C10(This:C1470.port))
	End if
	If (Length:C16(This:C1470.socket)>0)
		$args.push("--socket")
		$args.push(This:C1470._quote(This:C1470.socket))
	End if

	return $args
