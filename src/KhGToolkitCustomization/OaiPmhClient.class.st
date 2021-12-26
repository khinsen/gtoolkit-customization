Class {
	#name : #OaiPmhClient,
	#superclass : #ZnClient,
	#category : #'KhGToolkitCustomization-OAI'
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

{ #category : #accessing }
OaiPmhClient >> listMetadataFormats [
	self queryAt: 'verb' put: 'ListMetadataFormats'.
	^ self get
		findElementNamed: 'ListMetadataFormats'
]

{ #category : #accessing }
OaiPmhClient >> listSets [
	| listSets resumptionToken |
	self queryAt: 'verb' put: 'ListSets'.
	listSets := self get findElementNamed: 'ListSets'.
	resumptionToken := listSets findElementNamed: 'resumptionToken'.
	resumptionToken ifNotNil: [ self error: 'Resumption tokens not yet implemented'].
	^ (listSets elementsCollect: [ :each |
			OaiSet new
				spec: (each findElementNamed: 'setSpec') stringValue;
				name: (each findElementNamed: 'setName') stringValue;
				description: (each findElementNamed: 'setDescription') ])
		asArray
]
