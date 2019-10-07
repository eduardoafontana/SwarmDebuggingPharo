Class {
	#name : #BreakpointData,
	#superclass : #Object,
	#instVars : [
		'Id',
		'BreakpointKind',
		'Namespace',
		'Type',
		'CodeFilePath',
		'LineNumber',
		'LineOfCode',
		'Origin',
		'Created'
	],
	#category : #'SwarmDebugging-Service-DataModel'
}

{ #category : #accessing }
BreakpointData >> breakpointKind: value [
	BreakpointKind := value
]

{ #category : #accessing }
BreakpointData >> codeFilePath: value [
	CodeFilePath := value
]

{ #category : #accessing }
BreakpointData >> created: value [
	Created := value
]

{ #category : #accessing }
BreakpointData >> id [
	^Id
]

{ #category : #accessing }
BreakpointData >> id: value [
	Id := value
]

{ #category : #accessing }
BreakpointData >> lineNumber: value [
	LineNumber := value
]

{ #category : #accessing }
BreakpointData >> lineOfCode: value [
	LineOfCode := value
]

{ #category : #accessing }
BreakpointData >> namespace: value [
	Namespace := value
]

{ #category : #accessing }
BreakpointData >> origin: value [
	Origin := value
]

{ #category : #accessing }
BreakpointData >> type: value [
	Type := value
]
