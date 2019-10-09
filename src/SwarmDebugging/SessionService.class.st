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
SessionService class >> processCodeFile: contextProperty [

	| codeFile codeFilePath alreadyExist |

	CurrentSession ifNil: [ ^self ].

	codeFilePath := (FileLocator imageDirectory / contextProperty className, 'st') pathString.	

	"CodeFile"
	codeFile := CodeFile new 
		id: UUID new printString;
		path: codeFilePath;
		content: (ZnBase64Encoder new encode: (contextProperty sourceCode) asByteArray);
		created: DateAndTime now.
	
	alreadyExist := false.
	CurrentSession codeFiles do: [ 
		:file | file path = codeFilePath ifTrue: [ 
			alreadyExist := true 
			] 
		].
	
	alreadyExist ifFalse: [ 
			CurrentSession codeFiles add: codeFile. 
			Repository save: CurrentSession.		
		 ].
	
	^codeFilePath
	

]

{ #category : #public }
SessionService class >> processEvent: contextProperty [

	| event event_id |

	CurrentSession ifNil: [ ^self ].

	event_id := UUID new printString.

	"Event"
	event := Event new
		id: event_id; 
		eventKind: contextProperty stepName;
		detail: 'TODO';
		namespace: contextProperty packageName;
		type: contextProperty className;
		typeFullPath: 'TODO';
		method: contextProperty methodName;
		methodKey: '';
		methodSignature: '';
		charStart: contextProperty charStart;
		charEnd: contextProperty charEnd;
		codeFilePath: contextProperty filePath;
		lineNumber: contextProperty lineNumber;
		lineOfCode: contextProperty lineOfCode;
		created: DateAndTime now.
	CurrentSession events add: event.
	
	Repository save: CurrentSession.
	
	^event_id.
	

]

{ #category : #public }
SessionService class >> processStep: context stepName: stepName [

	| event_id pathNode contextProperty |

	CurrentSession ifNil: [ ^self ].

	contextProperty	:= self processStepContext: context.

	contextProperty filePath: (self processCodeFile: contextProperty).
	
	contextProperty stepName: stepName.

	event_id := self processEvent: contextProperty.
	
	"PathNode"
	pathNode := PathNode new 
		id: UUID new printString;
		hash: '';
		namespace: contextProperty packageName;
		type: contextProperty className;
		method: contextProperty methodName;
		parent: nil;
		parent_Id: (CurrentSession pathNodes isEmpty 
			ifTrue: [ '00000000-0000-0000-0000-000000000000' ] 
			ifFalse: [ CurrentSession pathNodes last id ]);
		origin: stepName;
		returnType: 'void';
		parameters: OrderedCollection new;
		event_Id: event_id;
		created: DateAndTime now.
	CurrentSession pathNodes add: pathNode.	
	
	
	Repository save: CurrentSession.
	

]

{ #category : #public }
SessionService class >> processStepContext: context [

	| typeWord sourceCodeStream lineOfCode lineCounter lineNumber |
	
	typeWord := context methodClass asString.
	((typeWord indexOfSubCollection: ' class') asNumber > 1) ifTrue: [
			typeWord := typeWord copyFrom: 1 to: (typeWord indexOfSubCollection: ' class') - 1
		].
	
	sourceCodeStream := (String new: 1000) writeStream.
	context methodSelector asString = 'DoIt' 
		ifTrue: [ sourceCodeStream := context sourceCode asString. ]
		ifFalse: [ 
			(Smalltalk at: typeWord asSymbol) fileOutOn: sourceCodeStream. 
			"UndefinedObject on transcript is because fileOutOn: - review later."
		].

	lineOfCode := (context method sourceNodeForPC: context pc).
	lineOfCode := ( lineOfCode source copyFrom: lineOfCode start to: lineOfCode stop ) asString.
	
	lineNumber := 0.
	lineCounter := 0.
	sourceCodeStream contents lines do: [ 
		:line |
			lineCounter := lineCounter + 1. 
			(line indexOfSubCollection: lineOfCode) > 0 ifTrue: [ 
				lineNumber := lineCounter.
			] 
		].	

	^ContextProperty getInstance
		methodName: context methodSelector asString;
		className: typeWord;
		packageName: (self getNamespace: typeWord);
		sourceCode: sourceCodeStream contents;
		lineOfCode: lineOfCode;
		lineNumber: lineNumber;
		charStart: 0;
		charEnd: 0.
		
	
]

{ #category : #public }
SessionService class >> registerBreakpoint: nodeContext [

	| contextProperty contextLocal contextLocalParent lineCounter sourceCodeStream breakpointData alreadyExist |

	CurrentSession ifNil: [ ^self ].

	nodeContext isNil ifTrue: [ ^self ].

	contextProperty := ContextProperty getInstance.
	contextLocal := nil.
	contextLocalParent := nil.

	nodeContext class asString = 'RBInstanceVariableNode' ifTrue: [ 
			contextLocal := nodeContext parent value.
			contextLocalParent := nodeContext parent parent parent.
		 ]
	ifFalse: [ nodeContext class asString = 'RBAssignmentNode' ifTrue: [
			contextLocal := nodeContext value.
			contextLocalParent := nodeContext parent parent.
		]
	ifFalse: [
			^self.
		]].

	(contextLocalParent isNil | contextLocal isNil) ifTrue: [ 
			^self.
		 ].

	contextProperty sourceCode: contextLocalParent source asString.
	contextProperty methodName: contextLocalParent selector asString.
	contextProperty className: contextLocalParent compilationContext getClass asString.

	contextProperty lineOfCode: (contextLocal source copyFrom: contextLocal start to: contextLocal stop) asString.

	sourceCodeStream := (String new: 1000) writeStream.
	contextProperty methodName = 'DoIt' 
		ifTrue: [ sourceCodeStream := contextProperty sourceCode. ]
		ifFalse: [ 
			(Smalltalk at: (contextProperty className) asSymbol) fileOutOn: sourceCodeStream. 
			"UndefinedObject on transcript is because fileOutOn: - review later."
		].

	contextProperty sourceCode: sourceCodeStream contents.

	lineCounter := 0.
	contextProperty sourceCode lines do: [ 
		:line |
			lineCounter := lineCounter + 1. 
			(line indexOfSubCollection: contextProperty lineOfCode) > 0 ifTrue: [ 
				contextProperty lineNumber: lineCounter.
			] 
		].
		
	contextProperty packageName: (self getNamespace: contextProperty className).
	contextProperty filePath: (self processCodeFile: contextProperty).
	contextProperty stepName: 'BreakpointAdd'.
	contextProperty charStart: 0.
	contextProperty charEnd: 0.
		
	"Breakpoint"
	breakpointData := BreakpointData new 
		id: UUID new printString;
		breakpointKind: contextProperty stepName;
		namespace: contextProperty packageName;
		type: contextProperty className;
		codeFilePath: contextProperty filePath;
		lineNumber: contextProperty lineNumber;
		lineOfCode: contextProperty lineOfCode;
		origin: 'AddedDuringDebug';
		created: DateAndTime now.
	
	alreadyExist := false.
	CurrentSession breakpoints do: [
		:breakpointItem | breakpointItem codeFilePath = breakpointData codeFilePath ifTrue: [ 
			alreadyExist := true 
			] 
		].
	
	alreadyExist ifFalse: [ 
			self processEvent: contextProperty.
			
			CurrentSession breakpoints add: breakpointData. 
			
			Repository save: CurrentSession.
		 ].

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
			breakpoints: OrderedCollection new;
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
