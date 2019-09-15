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
			codeFiles: OrderedCollection new;
			events: OrderedCollection new;
			pathNodes: OrderedCollection new.

	Repository save: CurrentSession
]

{ #category : #'as yet unclassified' }
SessionService class >> registerStepInto: context [

	| event event_id pathNode codeFile |

	CurrentSession ifNil: [ ^self ].

	CurrentSession stepMock: context.

	event_id := UUID new printString.	
	event := Event new
		id: event_id; 
		eventKind: '';
		detail: '';
		namespace: '';
		type: '';
		typeFullPath: '';
		method: '';
		methodKey: '';
		methodSignature: '';
		charStart: nil;
		charEnd: nil;
		codeFilePath: '';
		lineNumber: nil;
		lineOfCode: '';		
		created: DateAndTime now.
	CurrentSession events add: event.
	
	pathNode := PathNode new 
		id: UUID new printString;
		hash: '';
		namespace: '';
		type: '';
		method: '';
		parent: nil;
		parent_Id: '00000000-0000-0000-0000-000000000000';
		origin: 'StepInto';
		returnType: '';
		parameters: OrderedCollection new;
		event_Id: event_id;
		created: DateAndTime now.
	CurrentSession pathNodes add: pathNode.	
	
	codeFile := CodeFile new 
		id: UUID new printString;
		path: '';
		content: '';	
		created: DateAndTime now.
	CurrentSession codeFiles add: codeFile.

	Repository save: CurrentSession.
	

]

{ #category : #initialization }
SessionService class >> reset [
	<script: 'self reset'>
	CurrentSession := nil
]
