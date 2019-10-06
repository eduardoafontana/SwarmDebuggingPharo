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

	codeFileProperty := CodeFileProperty getInstance.

	typeWord:= context methodClass asString.
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
		eventKind: stepName;
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
		origin: stepName;
		returnType: 'void';
		parameters: OrderedCollection new;
		event_Id: event_id;
		created: DateAndTime now.
	CurrentSession pathNodes add: pathNode.	
	
	
	Repository save: CurrentSession.
	

]

{ #category : #public }
SessionService class >> registerBreakpoint: nodeContext [

	| parentLocal parentLocalLineOfCode |

	Transcript cr.
	parentLocal := nil.
	parentLocalLineOfCode := nil.

	nodeContext isNil 
		ifTrue: [ Transcript cr; show: 'NCénulo' ]
		ifFalse: [ 
			Transcript cr; show: 'NP: ', nodeContext class asString.
			
			(nodeContext value class asString = 'RBMessageNode') ifTrue: [
				parentLocalLineOfCode := nodeContext value.
			].
			
			nodeContext parent isNil 
				ifTrue: [ Transcript show: 'NCPénulo' ]
				ifFalse: [ Transcript cr; show: 'NCP: ', nodeContext parent class asString.
					
					(nodeContext parent value class asString = 'RBMessageNode') ifTrue: [
						parentLocalLineOfCode := nodeContext parent value.
					].
					
					nodeContext parent parent isNil 
						ifTrue: [ Transcript show: 'NCPPénulo' ]
						ifFalse: [ Transcript cr; show: 'NCPP: ', nodeContext parent parent class asString.
														
							parentLocal := nodeContext parent parent.
							
							nodeContext parent parent parent isNil 
								ifTrue: [ Transcript show: 'NCPPPénulo' ]
								ifFalse: [ 
									Transcript cr; show: 'NCPPP: ', nodeContext parent parent parent class asString.
									parentLocal := nodeContext parent parent parent.
									].									
							].					 
					].		
			].
			
	parentLocal isNil ifFalse: [ 
			Transcript cr; 
				show: 'PL: ', parentLocal source asString; cr; 
				show: parentLocal selector asString; cr; 
				show: parentLocal compilationContext getClass
				"show: (parentLocal source copyFrom: parentLocal start parentLocal: self stop)"
		 ].
	
	parentLocalLineOfCode isNil ifFalse: [ 			
			Transcript cr; show: 'LineOfCode: ', (parentLocalLineOfCode source copyFrom: parentLocalLineOfCode start to: parentLocalLineOfCode stop) asString
		 ].

"self source copyFrom: self start to: self stop"
	"Transcript cr; show: nodeContext parent parent parent source."
"	Transcript cr; show: nodeContext parent parent parent source.
	Transcript cr; show: nodeContext parent parent parent class. RBMethodNode
	Transcript cr; show: nodeContext parent parent parent selector.
	Transcript cr; show: nodeContext parent parent parent compilationContext getClass."
	
	
	
	"parentContext := BreakpointProperty processNodeGetParentContext: nodeContext."
	
	"teste := parentContext source asString."
	
	"Transcript cr; show: 'source: ', parentContext source asString.
	Transcript cr; show: 'selector: ', parentContext selector asString.
	Transcript cr; show: 'compilationContext getClass: ', parentContext compilationContext getClass asString."
	
" Transcript cr; show: 'nodeContext methodClass: ', nodeContext methodClass asString."
"Transcript cr; show: 'executou: ', self executou asString."
	"self executou isNil ifTrue: [ self executou: 'false'. self haltOnce. ]."
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
