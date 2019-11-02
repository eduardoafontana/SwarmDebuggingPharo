Class {
	#name : #SwarmWindow,
	#superclass : #ComposablePresenter,
	#instVars : [
		'labelInstruction',
		'labelProject',
		'labelDeveloper',
		'labelTaskTitle',
		'labelTaskAction',
		'labelTaskDescription',
		'labelFoot',
		'textProject',
		'textDeveloper',
		'textTaskTitle',
		'dropTaskAction',
		'textTaskDescription',
		'buttonSave'
	],
	#category : #'SwarmDebugging-Window'
}

{ #category : #specs }
SwarmWindow class >> defaultSpec [
  ^ SpecLayout composed
      
		newColumn: [ :mainColumn | 
			mainColumn newRow: [ :row | row add: #labelInstruction ].
						
			mainColumn newRow: [ :row | row add: #labelProject; add: #labelDeveloper ].
			mainColumn newRow: [ :row | row add: #textProject; add: #textDeveloper ].
			mainColumn newRow: [ :row | row add: #labelTaskTitle; add: #labelTaskAction ].
			mainColumn newRow: [ :row | row add: #textTaskTitle; add: #dropTaskAction ].
			mainColumn newRow: [ :row | row add: #labelTaskDescription ].
			mainColumn newRow: [ :row | row add: #textTaskDescription ].	

			mainColumn newRow: [ :row | row add: #buttonSave ].
			mainColumn newRow: [ :row | row add: #labelFoot ].
		];
	yourself
]

{ #category : #'world menu' }
SwarmWindow class >> menuCommandOn: aBuilder [
<worldMenu>

(aBuilder item: #'SwarmDebugging')
    order: 0.1;
    label: 'Swarm Debugging';
    action: [ SwarmWindow new openWithSpec. ]
]

{ #category : #accessing }
SwarmWindow >> buttonSave [
	^ buttonSave
]

{ #category : #accessing }
SwarmWindow >> buttonSave: anObject [
	buttonSave := anObject
]

{ #category : #accessing }
SwarmWindow >> dropTaskAction [
	^ dropTaskAction
]

{ #category : #accessing }
SwarmWindow >> dropTaskAction: anObject [
	dropTaskAction := anObject
]

{ #category : #accessing }
SwarmWindow >> initializePresenter [ 
	textProject whenTextChanged: [ 
		(textProject text isNotEmpty &
		textDeveloper text isNotEmpty &
		textTaskTitle text isNotEmpty)
		 ifTrue: [ buttonSave enable ] ifFalse: [ buttonSave disable ]
	].

	textDeveloper whenTextChanged: [ 
		(textProject text isNotEmpty &
		textDeveloper text isNotEmpty &
		textTaskTitle text isNotEmpty)
		 ifTrue: [ buttonSave enable ] ifFalse: [ buttonSave disable ]
	].

	textTaskTitle whenTextChanged: [ 
		(textProject text isNotEmpty &
		textDeveloper text isNotEmpty &
		textTaskTitle text isNotEmpty)
		 ifTrue: [ buttonSave enable ] ifFalse: [ buttonSave disable ]
	].

	"buttonGreet action: [ 
		labelGreeting label: 'Hello, ', textName text, '!'.
		buttonGreet disable. 
	]."
]

{ #category : #accessing }
SwarmWindow >> initializeWidgets [
	self title: 'Pharo Swarm Debugging Monitor Client'.
	self instantiateModels: #(
		labelInstruction LabelPresenter
		labelProject LabelPresenter
		labelDeveloper LabelPresenter
		labelTaskTitle LabelPresenter
		labelTaskAction LabelPresenter
		labelTaskDescription LabelPresenter
		labelFoot LabelPresenter	
		textProject TextInputFieldPresenter
		textDeveloper TextInputFieldPresenter
		textTaskTitle TextInputFieldPresenter
		dropTaskAction DropListPresenter
		textTaskDescription TextInputFieldPresenter
		buttonSave ButtonPresenter
  ).

	labelInstruction label: ''.
	labelProject label: 'Project*'.
	labelDeveloper label: 'Developer Nickname*'.
	labelTaskTitle label: 'Task Title*'.
	labelTaskAction label: 'Task Action'.
	labelTaskDescription label: 'Task Description'.
	labelFoot label: ''.
	textProject autoAccept: true.
	textDeveloper autoAccept: true.
	textTaskTitle autoAccept: true.
	textTaskDescription autoAccept: true.
	buttonSave label: 'Save!'; disable.

	dropTaskAction 	addItemLabeled: 'SearchingBug' do: [ ].
	dropTaskAction 	addItemLabeled: 'ResolvingBug' do: [ ].
	dropTaskAction 	addItemLabeled: 'AnalyzingCode' do: [ ].
	dropTaskAction 	addItemLabeled: 'NewFeature' do: [ ].
	dropTaskAction 	addItemLabeled: 'Refactoring' do: [ ].
	dropTaskAction 	addItemLabeled: 'Designing' do: [ ].

]

{ #category : #accessing }
SwarmWindow >> labelDeveloper [
	^ labelDeveloper
]

{ #category : #accessing }
SwarmWindow >> labelDeveloper: anObject [
	labelDeveloper := anObject
]

{ #category : #accessing }
SwarmWindow >> labelFoot [
	^ labelFoot
]

{ #category : #accessing }
SwarmWindow >> labelFoot: anObject [
	labelFoot := anObject
]

{ #category : #accessing }
SwarmWindow >> labelInstruction [
	^ labelInstruction
]

{ #category : #accessing }
SwarmWindow >> labelInstruction: anObject [
	labelInstruction := anObject
]

{ #category : #accessing }
SwarmWindow >> labelProject [
	^ labelProject
]

{ #category : #accessing }
SwarmWindow >> labelProject: anObject [
	labelProject := anObject
]

{ #category : #accessing }
SwarmWindow >> labelTaskAction [
	^ labelTaskAction
]

{ #category : #accessing }
SwarmWindow >> labelTaskAction: anObject [
	labelTaskAction := anObject
]

{ #category : #accessing }
SwarmWindow >> labelTaskDescription [
	^ labelTaskDescription
]

{ #category : #accessing }
SwarmWindow >> labelTaskDescription: anObject [
	labelTaskDescription := anObject
]

{ #category : #accessing }
SwarmWindow >> labelTaskTitle [
	^ labelTaskTitle
]

{ #category : #accessing }
SwarmWindow >> labelTaskTitle: anObject [
	labelTaskTitle := anObject
]

{ #category : #accessing }
SwarmWindow >> textDeveloper [
	^ textDeveloper
]

{ #category : #accessing }
SwarmWindow >> textDeveloper: anObject [
	textDeveloper := anObject
]

{ #category : #accessing }
SwarmWindow >> textProject [
	^ textProject
]

{ #category : #accessing }
SwarmWindow >> textProject: anObject [
	textProject := anObject
]

{ #category : #accessing }
SwarmWindow >> textTaskDescription [
	^ textTaskDescription
]

{ #category : #accessing }
SwarmWindow >> textTaskDescription: anObject [
	textTaskDescription := anObject
]

{ #category : #accessing }
SwarmWindow >> textTaskTitle [
	^ textTaskTitle
]

{ #category : #accessing }
SwarmWindow >> textTaskTitle: anObject [
	textTaskTitle := anObject
]