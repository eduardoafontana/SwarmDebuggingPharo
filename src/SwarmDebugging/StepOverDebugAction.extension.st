Extension { #name : #StepOverDebugAction }

{ #category : #'*SwarmDebugging' }
StepOverDebugAction >> executeAction [

	self session stepOver: self currentContext.
	"TODO: SDLogger uniqueInstance stepOverAction: self currentContext."
]
