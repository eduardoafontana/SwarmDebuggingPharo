Class {
	#name : #PathNode,
	#superclass : #Object,
	#instVars : [
		'Id',
		'Hash',
		'Namespace',
		'Type',
		'Method',
		'Parent',
		'Parent_Id',
		'Origin',
		'ReturnType',
		'Parameters',
		'Created',
		'Event_Id'
	],
	#category : #SwarmDebugging
}

{ #category : #accessing }
PathNode >> created: value [

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
PathNode >> event_Id: value [
	Event_Id := value
]

{ #category : #accessing }
PathNode >> hash: value [
	Hash := value
]

{ #category : #accessing }
PathNode >> id [
	^Id
]

{ #category : #accessing }
PathNode >> id: value [
	Id := value
]

{ #category : #accessing }
PathNode >> method: value [
	Method := value
]

{ #category : #accessing }
PathNode >> namespace: value [
	Namespace := value
]

{ #category : #accessing }
PathNode >> origin: value [
	Origin := value
]

{ #category : #accessing }
PathNode >> parameters: value [
	Parameters := value
]

{ #category : #accessing }
PathNode >> parent: value [
	Parent := value
]

{ #category : #accessing }
PathNode >> parent_Id: value [
	Parent_Id := value
]

{ #category : #accessing }
PathNode >> returnType: value [
	ReturnType := value
]

{ #category : #accessing }
PathNode >> type: value [
	Type := value
]
