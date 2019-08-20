Class {
	#name : #SDLogger,
	#superclass : #Object,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #SwarmDebugging
}

{ #category : #accessing }
SDLogger class >> uniqueInstance [
	uniqueInstance ifNil: [ uniqueInstance := SDLogger new ].
	^ uniqueInstance
]
