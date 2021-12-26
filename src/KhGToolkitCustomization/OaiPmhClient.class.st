Class {
	#name : #OaiPmhClient,
	#superclass : #ZnClient,
	#category : #KhGToolkitCustomization
}

{ #category : #accessing }
OaiPmhClient >> identify [
	self queryAt: 'verb' put: 'Identify'.
	^ self get
		findElementNamed: 'Identify'
]

{ #category : #initializing }
OaiPmhClient >> initialize [
	super initialize.
	self contentReader: [ :entity |
		(XMLDOMParser parse: entity contents)
			firstElement ].
]
