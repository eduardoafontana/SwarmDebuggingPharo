Class {
	#name : #SessionService,
	#superclass : #Object,
	#classInstVars : [
		'CurrentSession'
	],
	#category : #'SwarmDebugging-Service'
}

{ #category : #public }
SessionService class >> endCurrentSession [ 

	CurrentSession ifNil: [ ^self ].

	CurrentSession finished: DateAndTime now.

	Repository save: CurrentSession.
	
	self reset.
	
]

{ #category : #internal }
SessionService class >> getNamespace: typeWord [

	|namespaceWord stringContext| 
	
	typeWord 
		ifNil: [ stringContext := 'NamespaceNotFound' ]
		ifNotNil: [ stringContext := typeWord ].

	[ namespaceWord := (Smalltalk at: stringContext asSymbol) package name  ] 
		on: Exception
		do: [ namespaceWord := 'NamespaceNotFound' ].
	
	^namespaceWord 
]

{ #category : #processAndSend }
SessionService class >> processCodeFile: context [

	| codeFile sourceCodeStream codeFileProperty alreadyExist typeWord lineOfCode lineCounter |

	CurrentSession ifNil: [ ^self ].

	codeFileProperty := CodeFileProperty new charStart: 0; charEnd: 0; lineNumber: 0;
		lineOfCode: 'NotDefined'; codeFilePath: 'NotDefined'.

	typeWord:= context methodClass asString.

	sourceCodeStream := (String new: 1000) writeStream.
	context methodSelector asString = 'DoIt' 
		ifTrue: [ sourceCodeStream := context sourceCode asString. ]
		ifFalse: [ 
			(Smalltalk at: typeWord asSymbol) fileOutOn: sourceCodeStream. 
			"UndefinedObject on transcript is because fileOutOn: - review later."
		].

	codeFileProperty codeFilePath: (FileLocator imageDirectory / typeWord, 'st') pathString.	

	lineOfCode := (context method sourceNodeForPC: context pc).
	codeFileProperty lineOfCode: ( lineOfCode source copyFrom: lineOfCode start to: lineOfCode stop ) asString.
	
	lineCounter := 0.
	sourceCodeStream contents lines do: [ 
		:line |
			lineCounter := lineCounter + 1. 
			(line indexOfSubCollection: codeFileProperty lineOfCode) > 0 ifTrue: [ 
				codeFileProperty lineNumber: lineCounter.
			] 
		].	

	"CodeFile"
	codeFile := CodeFile new 
		id: UUID new printString;
		path: codeFileProperty codeFilePath;
		content: (ZnBase64Encoder new encode: (sourceCodeStream contents) asByteArray);
		created: DateAndTime now.
	
	alreadyExist := false.
	CurrentSession codeFiles do: [ 
		:file | file path = codeFileProperty codeFilePath ifTrue: [ 
			alreadyExist := true 
			] 
		].
	
	alreadyExist ifFalse: [ 
			CurrentSession codeFiles add: codeFile. 
			Repository save: CurrentSession.		
		 ].
	
	^codeFileProperty
	

]

{ #category : #public }
SessionService class >> processStep: context stepName: stepName [

	| event event_id pathNode namespaceWord codeFileProperty |

	CurrentSession ifNil: [ ^self ].

	event_id := UUID new printString.

	namespaceWord := self getNamespace: context methodClass asString.

	codeFileProperty := self processCodeFile: context.

	"Event"
	event := Event new
		id: event_id; 
		eventKind: 'StepOver';
		detail: 'TODO';
		namespace: namespaceWord;
		type: context methodClass asString;
		typeFullPath: 'TODO';
		method: context methodSelector asString;
		methodKey: '';
		methodSignature: '';
		charStart: codeFileProperty charStart;
		charEnd: codeFileProperty charEnd;
		codeFilePath: codeFileProperty codeFilePath;
		lineNumber: codeFileProperty lineNumber;
		lineOfCode: codeFileProperty lineOfCode;
		created: DateAndTime now.
	CurrentSession events add: event.
	
	"PathNode"
	pathNode := PathNode new 
		id: UUID new printString;
		hash: '';
		namespace: namespaceWord;
		type: context methodClass asString;
		method: context methodSelector asString;
		parent: nil;
		parent_Id: (CurrentSession pathNodes isEmpty 
			ifTrue: [ '00000000-0000-0000-0000-000000000000' ] 
			ifFalse: [ CurrentSession pathNodes last id ]);
		origin: 'StepOver';
		returnType: 'void';
		parameters: OrderedCollection new;
		event_Id: event_id;
		created: DateAndTime now.
	CurrentSession pathNodes add: pathNode.	
	
	
	Repository save: CurrentSession.
	

]

{ #category : #public }
SessionService class >> registerNewSession: context [

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

	Repository save: CurrentSession.
	
	self registerStepInto: context.
]

{ #category : #public }
SessionService class >> registerStepInto: context [

	self processStep: context stepName: 'StepInto'.
]

{ #category : #public }
SessionService class >> registerStepOver: context [

	self processStep: context stepName: 'StepOver'.
	

]

{ #category : #initialization }
SessionService class >> reset [
	<script: 'self reset'>
	CurrentSession := nil
]
