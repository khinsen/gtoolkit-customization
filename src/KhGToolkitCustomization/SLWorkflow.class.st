Class {
	#name : #SLWorkflow,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'nodes',
		'connections'
	],
	#category : #'KhGToolkitCustomization-Seamless'
}

{ #category : #accessing }
SLWorkflow class >> fromFile: aFileReference [
	^ self new
		rawData: (NeoJSONReader on:
			(aFileReference readStream)) next;
			yourself
]

{ #category : #visualizing }
SLWorkflow >> asMondrian [
	| view |
	view := GtMondrian new.
	view nodes
		stencil: [ :node | node node asElement ];
		with: self nodes.
	view edges
		shape: [ :x |
			BlLineElement new
				border: (BlBorder
							paint: (Color blue alpha: 0.5)
							width: 1) ];
		connect: connections
			from: [ :each | each key node ]
			to: [ :each | each value node ].
	view layout circle.
	^ view
]

{ #category : #inspecting }
SLWorkflow >> gtConnectionsFor: aView [
	<gtView>
	^ aView list
		title: 'Connections';
		priority: 2;
		items: [ connections ];
		itemText: [ :each |
			each key asString, ' -> ', each value asString ];
		yourself
]

{ #category : #inspecting }
SLWorkflow >> gtDataFor: aView [
	<gtView>
	^ aView forward
		title: 'Data';
		priority: 10;
		object: [ rawData ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #inspecting }
SLWorkflow >> gtNodesFor: aView [
	<gtView>
	^ aView list
		title: 'Nodes';
		priority: 1;
		items: [ self nodes values ];
		yourself
]

{ #category : #initializing }
SLWorkflow >> initializeFromRawData [
	nodes := ((rawData at: 'nodes')
				collect: [ :each |
							| node |
							node := SLNode ofType: (each at: #type).
							node rawData: each.
							node path -> node ])
				asDictionary.
	connections := (rawData at: 'connections')
					collect: [ :each |
						self assert: (each at: 'type') equals: 'connection'.
						(self nodeAt: (each at: 'source'))
							-> (self nodeAt: (each at: 'target'))].
]

{ #category : #accessing }
SLWorkflow >> nodeAt: aPath [
	| path subpath node |
	aPath isString
		ifTrue: [ path := ('/' split: aPath) asArray ]
		ifFalse: [ path := aPath ].
	subpath := OrderedCollection new.
	node := nil.
	[
		nodes at: path
			ifPresent: [ :n | node := n ]
			ifAbsent: [
				path ifNotEmpty: [
					subpath add: path last.
					path := path allButLast ] ].
		node isNil and: [ path isEmpty not ]
	] whileTrue.
	subpath ifEmpty: [ ^ node ].
	^ (SLPathFromNode new
		node: node;
		path: subpath reverse asArray)
		resolve.
]

{ #category : #accessing }
SLWorkflow >> nodes [
	^ nodes
]

{ #category : #initializing }
SLWorkflow >> rawData: aDictionary [
	rawData := aDictionary.
	self initializeFromRawData
]
