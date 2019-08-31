Class {
	#name : #SessionService,
	#superclass : #Object,
	#classInstVars : [
		'CurrentSession'
	],
	#category : #SwarmDebugging
}

{ #category : #'as yet unclassified' }
SessionService class >> endCurrentSession [ 

	CurrentSession ifNil: [ ^self ].

	CurrentSession setFinished: DateAndTime now asString.

	Repository save: CurrentSession.
	
	self reset.
	
]

{ #category : #'as yet unclassified' }
SessionService class >> registerNewSession [ 

	CurrentSession ifNotNil: [ ^self ].

	CurrentSession := 
		SessionData new 
			setId: UUID new printString; 
			setDescription: 'Pharo3';			
			setStarted: DateAndTime now asString.

	Repository save: CurrentSession
]

{ #category : #initialization }
SessionService class >> reset [
	<script: 'self reset'>
	CurrentSession := nil
]
