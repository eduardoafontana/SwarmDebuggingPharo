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

{ #category : #'as yet unclassified' }
SDLogger >> reachBreakpoint: aContext [
	'Reached breakpoint A' logCr.
	aContext logCr.
]

{ #category : #'as yet unclassified' }
SDLogger >> stepIntoAction: aContext [
	
	'Step Into A' logCr.
	aContext logCr.
]

{ #category : #'as yet unclassified' }
SDLogger >> stepOverAction: aContext [
	
	'Step Over A' logCr.
	aContext logCr.	
]
