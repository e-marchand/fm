// Parameters for `fm schema object`.
// Describe a root object type and its properties; FM.schema() returns the generated JSON schema.

// Name of the root object type (required).
property name : Text:=""

// Property declarations. Each item: {name: Text; type: Text; array: Boolean; optional: Boolean; description: Text}
// Supported types: "string", "integer", "double", "boolean".
property properties : Collection:=[]

Class extends FMParameters

Class constructor($object : Object)
	Super:C1705($object)

	// Do not inherit base args() (no --model for schema). Build from scratch.
Function args() : Collection
	var $args : Collection:=[]

	If (Length:C16(This:C1470.name)>0)
		$args.push("--name")
		$args.push(This:C1470._quote(This:C1470.name))
	End if

	var $property : Object
	For each ($property; This:C1470.properties || [])
		var $flag : Text:=This:C1470._typeFlag(String:C10($property.type))
		If (Length:C16($flag)=0)
			continue  // unknown type, skip
		End if
		$args.push($flag)
		$args.push(This:C1470._quote(String:C10($property.name)))
		// modifiers apply to the preceding property
		If (Bool:C1537($property.array))
			$args.push("--array")
		End if
		If (Bool:C1537($property.optional))
			$args.push("--optional")
		End if
		If (Length:C16(String:C10($property.description))>0)
			$args.push("--description")
			$args.push(This:C1470._quote($property.description))
		End if
	End for each

	return $args

Function _typeFlag($type : Text) : Text
	Case of
		: (($type="string") || ($type="text"))
			return "--string"
		: (($type="integer") || ($type="int"))
			return "--integer"
		: (($type="double") || ($type="real") || ($type="float") || ($type="number"))
			return "--double"
		: (($type="boolean") || ($type="bool"))
			return "--boolean"
		Else
			return ""
	End case
