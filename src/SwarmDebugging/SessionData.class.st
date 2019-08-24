Class {
	#name : #SessionData,
	#superclass : #Object,
	#instVars : [
		'Id',
		'Description'
	],
	#category : #SwarmDebugging
}

{ #category : #initialization }
SessionData >> setDescription: value [
	Description := value
]

{ #category : #initialization }
SessionData >> setId: value [
	Id := value
]
