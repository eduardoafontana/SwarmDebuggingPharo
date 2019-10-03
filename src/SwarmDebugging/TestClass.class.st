Class {
	#name : #TestClass,
	#superclass : #Object,
	#instVars : [
		'InternalVar'
	],
	#category : #'SwarmDebugging-Test'
}

{ #category : #'as yet unclassified' }
TestClass >> methodDoSomeThing [
	"self halt."

	InternalVar := 1+1.

	^InternalVar	
]
