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

{ #category : #processAndSend }
SessionService class >> processCodeFile: context [

	| codeFile sourceCodeStream targetFileAsString alreadyExist typeWord |

	CurrentSession ifNil: [ ^self ].

	typeWord:= context methodClass asString.

	sourceCodeStream := (String new: 1000) writeStream.
	context methodSelector asString = 'DoIt' 
		ifTrue: [ sourceCodeStream := context sourceCode asString. ]
		ifFalse: [ 
			(Smalltalk at: typeWord asSymbol) fileOutOn: sourceCodeStream. 
			"UndefinedObject on transcript is because fileOutOn: - review later."
		].

	targetFileAsString := (FileLocator imageDirectory / typeWord, 'st') pathString.	

	"CodeFile"
	codeFile := CodeFile new 
		id: UUID new printString;
		path: targetFileAsString;
		content: (ZnBase64Encoder new encode: (sourceCodeStream contents) asByteArray);
		created: DateAndTime now.
	
	alreadyExist := false.
	CurrentSession codeFiles do: [ 
		:file | file path = targetFileAsString ifTrue: [ 
			alreadyExist := true 
			] 
		].
	
	alreadyExist ifFalse: [ 
			CurrentSession codeFiles add: codeFile. 
			Repository save: CurrentSession.		
		 ].
	
	^targetFileAsString
	

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

	| event event_id pathNode namespaceWord typeWord methodWord filePath lineOfCode |

	CurrentSession ifNil: [ ^self ].
	
	"Falta vincular a linha de codigo sobre o arquivo. Para isto, iremos criar um algoritmo de busca que pega a partir do metodo e bate o codigo.
	Refatorar abaixo removendo o getType e GetMethod"
	
	CurrentSession stepMock: context. "Remove later."

	event_id := UUID new printString.

	namespaceWord := self getNamespace: context.
	typeWord := self getType: context.
	methodWord := self getMethod: context.

	filePath := self processCodeFile: context.

	lineOfCode := (context method sourceNodeForPC: context pc).
	lineOfCode := lineOfCode source copyFrom: lineOfCode start to: lineOfCode stop.
	"Transcript cr; show: 'lineOfCode ', lineOfCode asString; cr."

	"Event"
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
		codeFilePath: filePath;
		lineNumber: nil;
		lineOfCode: '';		
		created: DateAndTime now.
	CurrentSession events add: event.
	
	"PathNode"
	pathNode := PathNode new 
		id: UUID new printString;
		hash: '';
		namespace: namespaceWord;
		type: typeWord;
		method: methodWord;
		parent: nil;
		parent_Id: (CurrentSession pathNodes isEmpty 
			ifTrue: [ '00000000-0000-0000-0000-000000000000' ] 
			ifFalse: [ CurrentSession pathNodes last id ]);
		origin: 'StepInto';
		returnType: 'void';
		parameters: OrderedCollection new;
		event_Id: event_id;
		created: DateAndTime now.
	CurrentSession pathNodes add: pathNode.	
	
	
	Repository save: CurrentSession.
	

]

{ #category : #initialization }
SessionService class >> reset [
	<script: 'self reset'>
	CurrentSession := nil
]
