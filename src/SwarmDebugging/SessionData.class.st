Class {
	#name : #SessionData,
	#superclass : #Object,
	#instVars : [
		'Id',
		'Description',
		'Started',
		'Finished',
		'DeveloperName',
		'TaskName',
		'TaskAction',
		'TaskDescription',
		'TaskCreated',
		'TaskTotalSessionTime',
		'ProjectName',
		'Breakpoints',
		'CodeFiles',
		'Events',
		'PathNodes'
	],
	#category : #'SwarmDebugging-Service-DataModel'
}

{ #category : #accessing }
SessionData >> breakpoints: value [
	Breakpoints := value
]

{ #category : #accessing }
SessionData >> codeFiles [
	^CodeFiles
]

{ #category : #accessing }
SessionData >> codeFiles: value [
	CodeFiles := value
]

{ #category : #accessing }
SessionData >> description: value [
	Description := value
]

{ #category : #accessing }
SessionData >> developerName: value [
	DeveloperName := value
]

{ #category : #accessing }
SessionData >> events [
	^Events
]

{ #category : #accessing }
SessionData >> events: value [
	Events := value
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
SessionData >> pathNodes [
	^PathNodes
]

{ #category : #accessing }
SessionData >> pathNodes: value [
	PathNodes := value
]

{ #category : #accessing }
SessionData >> projectName: value [
	ProjectName := value
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
SessionData >> taskAction: value [
	TaskAction := value
]

{ #category : #accessing }
SessionData >> taskCreated: value [
	TaskCreated := value
]

{ #category : #accessing }
SessionData >> taskDescription: value [
	TaskDescription := value
]

{ #category : #accessing }
SessionData >> taskName: value [
	TaskName := value
]

{ #category : #accessing }
SessionData >> taskTotalSessionTime: value [
	TaskTotalSessionTime := value
]
