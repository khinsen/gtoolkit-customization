Class {
	#name : #I3Node,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'children'
	],
	#category : #'KhGToolkitCustomization-I3'
}

{ #category : #'instance creation' }
I3Node class >> fromRawData: jsonData [
	| type |
	type := jsonData at: #type.
	jsonData removeKey: #type.
	self subclasses do: [ :each |
		each type = type ifTrue: [ ^ each new rawData: jsonData ] ].
	self error: 'Unknown node type ', type
]

{ #category : #comparing }
I3Node >> = anotherNode [
	^ (self class = anotherNode class)
		and: [ self id = anotherNode id ]
]

{ #category : #accessing }
I3Node >> children [
	^ children
]

{ #category : #inspecting }
I3Node >> gtChildrenFor: aView [
	<gtView>
	self children ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Children';
		priority: 5;
		object: [ self children ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #inspecting }
I3Node >> gtRawDataFor: aView [
	<gtView>
	^ aView forward
		title: 'JSON data';
		priority: 9;
		object: [ rawData ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #comparing }
I3Node >> hash [
	^ self id hash
]

{ #category : #accessing }
I3Node >> id [
	^ rawData at: #id
]

{ #category : #printing }
I3Node >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< (rawData at: #name);
		<< $)
]

{ #category : #accessing }
I3Node >> rawData: jsonData [
	rawData := jsonData.
	children := ((rawData at: #nodes) collect: [ :each |
					I3Node fromRawData:  each ])
]
