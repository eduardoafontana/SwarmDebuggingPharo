Class {
	#name : #CodeFileProperty,
	#superclass : #Object,
	#instVars : [
		'CharStart',
		'CharEnd',
		'CodeFilePath',
		'LineNumber',
		'LineOfCode'
	],
	#category : #'SwarmDebugging-DataModel'
}

{ #category : #'instance creation' }
CodeFileProperty class >> getInstance [ 
	^CodeFileProperty new charStart: 0; charEnd: 0; lineNumber: 0;
		lineOfCode: 'NotDefined'; codeFilePath: 'NotDefined'.
]

{ #category : #accessing }
CodeFileProperty >> charEnd [
	^CharEnd
]

{ #category : #accessing }
CodeFileProperty >> charEnd: value [
	CharEnd := value
]

{ #category : #accessing }
CodeFileProperty >> charStart [
	^CharStart
]

{ #category : #accessing }
CodeFileProperty >> charStart: value [
	CharStart := value
]

{ #category : #accessing }
CodeFileProperty >> codeFilePath [
	^CodeFilePath
]

{ #category : #accessing }
CodeFileProperty >> codeFilePath: value [
	CodeFilePath := value
]

{ #category : #accessing }
CodeFileProperty >> lineNumber [
	^LineNumber
]

{ #category : #accessing }
CodeFileProperty >> lineNumber: value [
	LineNumber := value
]

{ #category : #accessing }
CodeFileProperty >> lineOfCode [
	^LineOfCode
]

{ #category : #accessing }
CodeFileProperty >> lineOfCode: value [
	LineOfCode := value
]
