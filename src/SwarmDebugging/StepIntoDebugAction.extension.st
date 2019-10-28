Extension { #name : #StepIntoDebugAction }

{ #category : #'*SwarmDebugging' }
StepIntoDebugAction >> executeAction [

	"SessionService registerStepInto: self currentContext."
	
	self session stepInto: self currentContext.
]
