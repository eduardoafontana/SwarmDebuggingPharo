Class {
	#name : #SessionService,
	#superclass : #Object,
	#classInstVars : [
		'CurrentSession'
	],
	#category : #SwarmDebugging
}

{ #category : #public }
SessionService class >> endCurrentSession [ 

	CurrentSession ifNil: [ ^self ].

	CurrentSession finished: DateAndTime now.

	Repository save: CurrentSession.
	
	self reset.
	
]

{ #category : #internal }
SessionService class >> getMethod: context [

	|phrase words methodWord stringContext| 
	
	context 
		ifNil: [ stringContext := 'NoContextSent>>NoContextSent' ]
		ifNotNil: [ stringContext := context asString ].

	((stringContext indexOfAnyOf: '>>') = 0) ifTrue: [ stringContext := 'NoSeparatorFounded>>NoSeparatorFounded' ].

	phrase := stringContext asString.
	words := phrase splitOn: '>>'.
	methodWord := words last.
	
	^methodWord 
]

{ #category : #internal }
SessionService class >> getNamespace: context [

	|phrase words word namespaceWord stringContext| 
	
	context 
		ifNil: [ stringContext := 'NoContextSent>>NoContextSent' ]
		ifNotNil: [ stringContext := context asString ].

	((stringContext indexOfAnyOf: '>>') = 0) ifTrue: [ stringContext := 'NoSeparatorFounded>>NoSeparatorFounded' ].

	phrase := stringContext asString.
	words := phrase splitOn: '>>'.
	word := words first.

	[ namespaceWord := (Smalltalk at: word asSymbol) package name  ] 
		on: Exception
		do: [ namespaceWord := 'NamespaceNotFound' ].
	
	^namespaceWord 
]

{ #category : #internal }
SessionService class >> getType: context [

	|phrase words typeWord stringContext| 
	
	context 
		ifNil: [ stringContext := 'NoContextSent>>NoContextSent' ]
		ifNotNil: [ stringContext := context asString ].

	((stringContext indexOfAnyOf: '>>') = 0) ifTrue: [ stringContext := 'NoSeparatorFounded>>NoSeparatorFounded' ].

	phrase := stringContext asString.
	words := phrase splitOn: '>>'.
	typeWord := words first.
	
	^typeWord 
]

{ #category : #public }
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

{ #category : #public }
SessionService class >> registerStepInto: context [

	| event event_id pathNode codeFile namespaceWord typeWord methodWord|

	CurrentSession ifNil: [ ^self ].
	
	CurrentSession stepMock: context. "Remove later."
	
	namespaceWord := self getNamespace: context.
	typeWord := self getType: context.
	methodWord := self getMethod: context.	

	event_id := UUID new printString.	
	event := Event new
		id: event_id; 
		eventKind: 'StepInto';
		detail: 'TODO';
		namespace: namespaceWord;
		type: typeWord;
		typeFullPath: 'TODO';
		method: methodWord;
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
		namespace: namespaceWord;
		type: typeWord;
		method: methodWord;
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
		path: 'C:\Users\EduardoAFontana\source\repos\ConsoleApp1\ConsoleApp1\Program.cs';
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
