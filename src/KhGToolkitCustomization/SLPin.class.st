Class {
	#name : #SLPin,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'node',
		'name'
	],
	#category : #'KhGToolkitCustomization-Seamless'
}

{ #category : #inspecting }
SLPin >> gtDataFor: aView [
	<gtView>
	^ aView forward
		title: 'Data';
		priority: 10;
		object: [ rawData ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #accessing }
SLPin >> name [
	^ name
]

{ #category : #accessing }
SLPin >> name: aString [
	name := aString 
]

{ #category : #accessing }
SLPin >> node [
	^ node
]

{ #category : #accessing }
SLPin >> node: aNode [
	node := aNode
]

{ #category : #printing }
SLPin >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< (STONJSON toString: rawData);
		<< $).
]

{ #category : #initializing }
SLPin >> rawData: aDictionary [
	rawData := aDictionary
]
