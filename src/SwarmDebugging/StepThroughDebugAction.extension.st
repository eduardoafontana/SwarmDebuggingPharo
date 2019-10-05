Extension { #name : #StepThroughDebugAction }

{ #category : #'*SwarmDebugging' }
StepThroughDebugAction >> executeAction [

	SessionService registerStepOver: self currentContext.

	self session stepThrough: self currentContext
]
