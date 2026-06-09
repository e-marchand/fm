//%attributes = {}
// Exercises the FM singleton (Apple Foundation Models CLI wrapper).
// Skips silently when not on macOS or when `fm` is not installed.

If (Is Windows:C1573)
	return   // fm is macOS-only
End if 
If (Not:C34(cs:C1710.FM.me.installed()))
	return   // fm not installed, skip
End if 

// MARK:- respond (synchronous)
var $text : Text:=cs:C1710.FM.me.respond("Say hi in exactly one word")
ASSERT:C1129(Length:C16($text)>0; "respond must return text")

// respond with an options object (instructions + greedy)
$text:=cs:C1710.FM.me.respond("What is 2+2? Answer with just the number."; {instructions: "Answer with only digits."; greedy: True:C214})
ASSERT:C1129(Length:C16($text)>0; "respond with options must return text")

// MARK:- token-count
var $n : Integer:=cs:C1710.FM.me.tokenCount("Hello world")
ASSERT:C1129($n>0; "tokenCount must return a positive integer")

// token-count with extra text segments
var $n2 : Integer:=cs:C1710.FM.me.tokenCount("Hello"; {text: ["world"; "again"]})
ASSERT:C1129($n2>0; "tokenCount with text segments must return a positive integer")

// MARK:- available
var $av : cs:C1710.FMAvailableResult:=cs:C1710.FM.me.available("system")
ASSERT:C1129($av.available; "system model should be available")
ASSERT:C1129($av.success; "available(system) should succeed")

// available with an invalid model should report an error
var $bad : cs:C1710.FMAvailableResult:=cs:C1710.FM.me.available("bogus-model")
ASSERT:C1129(Not:C34($bad.success); "available(bogus) should not succeed")
ASSERT:C1129($bad.errors.length>0; "available(bogus) should expose errors")

// MARK:- quota-usage
var $quota : cs:C1710.FMQuotaUsageResult:=cs:C1710.FM.me.quotaUsage("pcc")
ASSERT:C1129($quota.terminated; "quotaUsage should terminate")
ASSERT:C1129($quota.usage#Null:C1517; "quotaUsage should return a usage object")

// MARK:- schema (with modifiers)
var $schema : Object:=cs:C1710.FM.me.schema({name: "Person"; properties: [\
{name: "name"; type: "string"; description: "Full name"}; \
{name: "age"; type: "integer"}; \
{name: "tags"; type: "string"; array: True:C214}; \
{name: "nickname"; type: "string"; optional: True:C214}\
]})
If (Asserted:C1132($schema#Null:C1517; "schema must be parsed"))
	ASSERT:C1129($schema.properties.name#Null:C1517; "schema must contain a name property")
	ASSERT:C1129($schema.properties.age.type="integer"; "age property must be integer")
	ASSERT:C1129($schema.properties.tags.type="array"; "tags property must be an array")
	ASSERT:C1129($schema.required.indexOf("nickname")=-1; "optional property must not be required")
End if 

// MARK:- error handling (throw)
var $threw : Boolean:=False:C215
Try
	$text:=cs:C1710.FM.me.respond("hi"; {model: "bogus-model"; throw: True:C214})
Catch
	$threw:=True:C214
End try
ASSERT:C1129($threw; "respond with invalid model + throw must throw")

// MARK:- respond streaming (asynchronous)
// Passing onData makes respond() return immediately with a running worker; worker.wait()
// pumps the streaming callbacks until completion.
Use (Storage:C1525)
	Storage:C1525.fmChunks:=New shared collection:C1527()
	Storage:C1525.fmEvents:=New shared object:C1526()
End use 

var $stream : cs:C1710.FMRespondResult:=cs:C1710.FM.me.respond("List the numbers one to five."; {\
onData: Formula:C1597(_fmStreamCollect($1)); \
onResponse: Formula:C1597(_fmEvent("response")); \
onTerminate: Formula:C1597(_fmEvent("terminate"))})
$stream.worker.wait()

var $chunks : Collection:=Storage:C1525.fmChunks
If (Asserted:C1132(($chunks#Null:C1517) && ($chunks.length>0); "streaming should deliver chunks"))
	ASSERT:C1129(Length:C16($chunks.join(""))>0; "streamed text should not be empty")
End if 
ASSERT:C1129(Num:C11(Storage:C1525.fmEvents.response)=1; "onResponse should fire once on success")
ASSERT:C1129(Num:C11(Storage:C1525.fmEvents.terminate)=1; "onTerminate should fire once")
ASSERT:C1129($stream.success; "streamed result should be successful")
ASSERT:C1129(Length:C16($stream.text)>0; "final result text should not be empty")

// MARK:- serve (start then stop)
var $server : cs:C1710.FMResult:=cs:C1710.FM.me.serve({})
If (Asserted:C1132($server.worker#Null:C1517; "serve should return a running worker"))
	$server.worker.terminate()
End if 
