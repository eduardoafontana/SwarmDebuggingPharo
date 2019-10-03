Class {
	#name : #Event,
	#superclass : #Object,
	#instVars : [
		'Id',
		'EventKind',
		'Detail',
		'Namespace',
		'Type',
		'TypeFullPath',
		'Method',
		'MethodKey',
		'MethodSignature',
		'CharStart',
		'CharEnd',
		'CodeFilePath',
		'LineNumber',
		'LineOfCode',
		'Created'
	],
	#category : #'SwarmDebugging-Service-DataModel'
}

{ #category : #accessing }
Event >> charEnd: value [
	CharEnd := value
]

{ #category : #accessing }
Event >> charStart: value [
	CharStart := value
]

{ #category : #accessing }
Event >> codeFilePath: value [
	CodeFilePath := value
]

{ #category : #accessing }
Event >> created: value [

	|d s|
	d := value.
	s := d month asString, '/',
	d dayOfMonth asString, '/', 
	d year asString, ' ', 
	d hour24 asString, ':', 
	d minute asString, ':', 
	d second asString, '.',
	d nanoSecond asString.

	Created := s
]

{ #category : #accessing }
Event >> detail: value [
	Detail := value
]

{ #category : #accessing }
Event >> eventKind: value [
	EventKind := value
]

{ #category : #accessing }
Event >> id: value [
	Id := value
]

{ #category : #accessing }
Event >> lineNumber: value [
	LineNumber := value
]

{ #category : #accessing }
Event >> lineOfCode: value [
	LineOfCode := value
]

{ #category : #accessing }
Event >> method: value [
	Method := value
]

{ #category : #accessing }
Event >> methodKey: value [
	MethodKey := value
]

{ #category : #accessing }
Event >> methodSignature: value [
	MethodSignature := value
]

{ #category : #accessing }
Event >> namespace: value [
	Namespace := value
]

{ #category : #accessing }
Event >> type: value [
	Type := value
]

{ #category : #accessing }
Event >> typeFullPath: value [
	TypeFullPath := value
]
