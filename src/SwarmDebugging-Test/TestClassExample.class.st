Class {
	#name : #TestClassExample,
	#superclass : #Object,
	#category : #'SwarmDebugging-Test'
}

{ #category : #'as yet unclassified' }
TestClassExample >> methodDoSomeThing [ 

| variable test |

test := 1.

variable := 1 + test.

^variable.
]
