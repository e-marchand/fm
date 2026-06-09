//%attributes = {"invisible":true}
// Streaming callback used by test_fm: collects each chunk's text into Storage.fmChunks.
#DECLARE($result : cs:C1710.FMResult)

If (Not:C34($result.terminated))
	Use (Storage:C1525.fmChunks)
		Storage:C1525.fmChunks.push($result.text)
	End use
End if
