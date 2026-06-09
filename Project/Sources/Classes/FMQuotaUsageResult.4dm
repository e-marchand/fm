// Result of `fm quota-usage`. Returns parsed JSON when available, otherwise the raw text.

Class extends FMResult

// Quota usage as an object: parsed JSON if possible, else {text: <raw output>}.
Function get usage : Object
	var $parsed : Variant:=This:C1470._json()
	If (Value type:C1509($parsed)=Is object:K8:27)
		return $parsed
	End if
	return {text: This:C1470.text}
