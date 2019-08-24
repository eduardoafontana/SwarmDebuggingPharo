Class {
	#name : #SessionService,
	#superclass : #Object,
	#classInstVars : [
		'CurrentSession'
	],
	#category : #SwarmDebugging
}

{ #category : #'as yet unclassified' }
SessionService class >> registerNewSession [ 
	CurrentSession := 
		SessionData new 
			setId: UUID new printString; 
			setDescription: DateAndTime now asString.

	Repository save: CurrentSession
]
