Class {
	#name : #CodeFile,
	#superclass : #Object,
	#instVars : [
		'Id',
		'Path',
		'Content',
		'Created'
	],
	#category : #'SwarmDebugging-Service-DataModel'
}

{ #category : #accessing }
CodeFile >> content: value [
	Content := value
]

{ #category : #accessing }
CodeFile >> created: value [

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
CodeFile >> id: value [
	Id := value
]

{ #category : #accessing }
CodeFile >> path [
	^Path
]

{ #category : #accessing }
CodeFile >> path: value [
	Path := value
]
