Extension { #name : #StepIntoDebugAction }

{ #category : #'*SwarmDebugging' }
StepIntoDebugAction >> executeAction [

	self session stepInto: self currentContext.
	SDLogger uniqueInstance stepIntoAction: self currentContext.	
]
