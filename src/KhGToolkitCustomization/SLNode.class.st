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

{ #category : #accessing }
SLNode >> itemAt: aString ifAbsent: aBlock [
	aBlock value
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
