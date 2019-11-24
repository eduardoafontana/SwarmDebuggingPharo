Class {
	#name : #BaselineOfSwarmDebugging,
	#superclass : #BaselineOf,
	#category : #BaselineOfSwarmDebugging
}

{ #category : #baselines }
BaselineOfSwarmDebugging >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			spec
				package: 'SwarmDebugging';
				package: 'SwarmDebugging-Test' with: [ spec requires: #('SwarmDebugging') ].
			spec
    			baseline: 'NeoJSON'
    			with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].	 
		].
]

{ #category : #baselines }
BaselineOfSwarmDebugging >> projectClass [
	^ MetacelloCypressBaselineProject
]
