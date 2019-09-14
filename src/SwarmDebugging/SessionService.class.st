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

	CurrentSession finished: DateAndTime now.

	Repository save: CurrentSession.
	
	self reset.
	
]

{ #category : #'as yet unclassified' }
SessionService class >> registerNewSession [ 

	CurrentSession ifNotNil: [ ^self ].

	CurrentSession := 
		SessionData new 
			id: UUID new printString; 
			description: 'Pharo4';			
			started: DateAndTime now;
			developerName: 'Eduardo A. Fontana';
			taskName: 'Test from Pharo 2';
			taskAction: 'SearchingBug';
			taskDescription: nil;
			taskCreated: nil;
			taskTotalSessionTime: '00:00:00.0000000';
			projectName: 'Swarm on Pharo';
			breakpoints: nil;
			codeFiles: nil;
			events: nil;
			pathNodes: nil.

	Repository save: CurrentSession
]

{ #category : #'as yet unclassified' }
SessionService class >> registerStepInto: context [

	CurrentSession ifNil: [ ^self ].

	CurrentSession stepMock: context.

	Repository save: CurrentSession.
	

]

{ #category : #initialization }
SessionService class >> reset [
	<script: 'self reset'>
	CurrentSession := nil
]
