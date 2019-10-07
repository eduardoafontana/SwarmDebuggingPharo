Class {
	#name : #ContextProperty,
	#superclass : #Object,
	#instVars : [
		'MethodName',
		'ClassName',
		'PackageName',
		'SourceCode',
		'LineOfCode',
		'LineNumber',
		'CharStart',
		'CharEnd',
		'StepName',
		'FilePath'
	],
	#category : #'SwarmDebugging-DataModel'
}

{ #category : #'instance creation' }
ContextProperty class >> getInstance [ 
	^ContextProperty new 
	methodName: 'NotDefined';
	className: 'NotDefined';
	packageName: 'NotDefined';
	sourceCode: 'NotDefined';
	lineOfCode: 'NotDefined';
	lineNumber: 0;
	charStart: 0;
	charEnd: 0.
]

{ #category : #'as yet unclassified' }
ContextProperty >> charEnd [
	^CharEnd
]

{ #category : #'as yet unclassified' }
ContextProperty >> charEnd: value [
	CharEnd := value
]

{ #category : #'as yet unclassified' }
ContextProperty >> charStart [
	^CharStart
]

{ #category : #'as yet unclassified' }
ContextProperty >> charStart: value [
	CharStart := value
]

{ #category : #'as yet unclassified' }
ContextProperty >> className [
	^ClassName
]

{ #category : #'as yet unclassified' }
ContextProperty >> className: value [
	ClassName := value
]

{ #category : #'as yet unclassified' }
ContextProperty >> filePath [
	^FilePath
]

{ #category : #'as yet unclassified' }
ContextProperty >> filePath: value [
	FilePath := value
]

{ #category : #'as yet unclassified' }
ContextProperty >> lineNumber [
	^LineNumber
]

{ #category : #'as yet unclassified' }
ContextProperty >> lineNumber: value [
	LineNumber := value
]

{ #category : #'as yet unclassified' }
ContextProperty >> lineOfCode [
	^LineOfCode
]

{ #category : #'as yet unclassified' }
ContextProperty >> lineOfCode: value [
	LineOfCode := value
]

{ #category : #'as yet unclassified' }
ContextProperty >> methodName [
	^MethodName
]

{ #category : #'as yet unclassified' }
ContextProperty >> methodName: value [
	MethodName := value
]

{ #category : #'as yet unclassified' }
ContextProperty >> packageName [
	^PackageName
]

{ #category : #'as yet unclassified' }
ContextProperty >> packageName: value [
	PackageName := value
]

{ #category : #'as yet unclassified' }
ContextProperty >> sourceCode [
	^SourceCode
]

{ #category : #'as yet unclassified' }
ContextProperty >> sourceCode: value [
	SourceCode := value
]

{ #category : #'as yet unclassified' }
ContextProperty >> stepName [
	^StepName
]

{ #category : #'as yet unclassified' }
ContextProperty >> stepName: value [
	StepName := value
]
