Class {
	#name : #SessionData,
	#superclass : #Object,
	#instVars : [
		'Id',
		'Description',
		'Started',
		'Finished'
	],
	#category : #SwarmDebugging
}

{ #category : #accessing }
SessionData >> description: value [
	Description := value
]

{ #category : #accessing }
SessionData >> finished: value [

	|d s|
	d := value.
	s := d month asString, '/', 
	d dayOfMonth asString, '/', 
	d year asString, ' ', 
	d hour24 asString, ':', 
	d minute asString, ':', 
	d second asString, '.',
	d nanoSecond asString.

	Finished := s.
]

{ #category : #accessing }
SessionData >> id: value [
	Id := value
]

{ #category : #accessing }
SessionData >> started: value [

	|d s|
	d := value.
	s := d month asString, '/',
	d dayOfMonth asString, '/', 
	d year asString, ' ', 
	d hour24 asString, ':', 
	d minute asString, ':', 
	d second asString, '.',
	d nanoSecond asString.

	Started := s.
]

{ #category : #accessing }
SessionData >> stepMock: value [

	Description := Description, ' StepMock: ', value asString 
]
