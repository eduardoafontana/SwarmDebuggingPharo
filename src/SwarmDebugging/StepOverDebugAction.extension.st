Extension { #name : #StepOverDebugAction }

{ #category : #'*SwarmDebugging' }
StepOverDebugAction >> executeAction [

	self session stepOver: self currentContext.
	SDLogger uniqueInstance stepOverAction: self currentContext.	
]
