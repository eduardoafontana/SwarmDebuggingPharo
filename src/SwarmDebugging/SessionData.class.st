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

{ #category : #initialization }
SessionData >> setDescription: value [
	Description := value
]

{ #category : #initialization }
SessionData >> setFinished: value [

	|d s|
	d := value.
	s := d dayOfMonth asString, '/', 
	d month asString, '/', 
	d year asString, ' ', 
	d hour24 asString, ':', 
	d minute asString, ':', 
	d second asString, '.',
	d nanoSecond asString.

	Finished := s.
]

{ #category : #initialization }
SessionData >> setId: value [
	Id := value
]

{ #category : #initialization }
SessionData >> setStarted: value [

	|d s|
	d := value.
	s := d dayOfMonth asString, '/', 
	d month asString, '/', 
	d year asString, ' ', 
	d hour24 asString, ':', 
	d minute asString, ':', 
	d second asString, '.',
	d nanoSecond asString.

	Started := s.
]

{ #category : #initialization }
SessionData >> setStepMock: value [

	Description := Description, ' StepMock: ', value asString 
]
