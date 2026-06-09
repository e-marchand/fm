// Result of `fm schema object`. Parses the generated JSON schema.

Class extends FMResult

// The generated JSON schema as an object (Null if it could not be parsed).
Function get schema : Object
	var $parsed : Variant:=This:C1470._json()
	If (Value type:C1509($parsed)=Is object:K8:27)
		return $parsed
	End if
	return Null:C1517
