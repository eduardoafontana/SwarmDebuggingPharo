Extension { #name : #Object }

{ #category : #'*SwarmDebugging' }
Object >> halt [
	"This is the typical message to use for inserting breakpoints during debugging."
	<debuggerCompleteToSender>
	"TODO: SDLogger uniqueInstance reachBreakpoint: thisContext."	
	Halt now
]
