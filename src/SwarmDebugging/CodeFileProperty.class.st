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
