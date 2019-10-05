Extension { #name : #StepOverDebugAction }

{ #category : #'*SwarmDebugging' }
StepOverDebugAction >> executeAction [

	SessionService registerStepOver: self currentContext.

	self session stepOver: self currentContext.
]
