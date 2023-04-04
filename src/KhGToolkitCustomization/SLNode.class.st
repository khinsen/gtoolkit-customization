Class {
	#name : #SLNode,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'pins'
	],
	#category : #'KhGToolkitCustomization-Seamless'
}

{ #category : #'instance creation' }
SLNode class >> ofType: aString [
	self allSubclassesDo: [ :eachClass |
		eachClass type = aString ifTrue: [ ^ eachClass new ] ].
	^ self new
]

{ #category : #accessing }
SLNode class >> type [
	self subclassResponsibility
]

{ #category : #visualizing }
SLNode >> asElement [
	| text label rectangle |
	text := self pathString asRopedText.
	text foreground: Color white.
	label := BlTextElement new text: text.
	rectangle := BlElement new
		background: Color black;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		padding: (BlInsets all: 3);
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ].
	rectangle addChild: label.
	^ rectangle
]

{ #category : #accessing }
SLNode >> checksum [
	^ rawData at: 'checksum'
		ifAbsent: nil
]

{ #category : #inspecting }
SLNode >> gtDataFor: aView [
	<gtView>
	^ aView forward
		title: 'Data';
		priority: 10;
		object: [ rawData ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #inspecting }
SLNode >> gtPinsFor: aView [
	<gtView>
	self pins ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Pins';
		priority: 1;
		items: [ self pins associations ];
		column: 'Name' text: #key;
		column: 'Value' text: #value;
		send: #value;
		yourself
]

{ #category : #accessing }
SLNode >> node [
	^ self
]

{ #category : #accessing }
SLNode >> path [
	^ rawData at: 'path'
]

{ #category : #accessing }
SLNode >> pathString [
	^ '/' join: self path
]

{ #category : #accessing }
SLNode >> pinNamed: aString [
	^ self pins at: aString
]

{ #category : #accessing }
SLNode >> pins [
	pins ifNil: [
		pins :=
			((rawData at: 'pins' ifAbsent: [Dictionary new])
				associations collect: [ :each |
					each key -> (SLPin new
									rawData: each value;
									node: self;
									name: each key) ])
					asDictionary ].
	^ pins
]

{ #category : #printing }
SLNode >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< self pathString;
		<< (self checksum
				ifNil: ''
				ifNotNil: [ :c | ', ', (STONJSON toString: c) ]);
		<< ')'.
]

{ #category : #initializing }
SLNode >> rawData: aDictionary [
	rawData := aDictionary
]

{ #category : #accessing }
SLNode >> type [
	self assert: (rawData at: #type) equals: self class type.
	^ self class type
]
