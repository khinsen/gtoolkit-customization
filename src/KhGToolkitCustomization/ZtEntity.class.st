Class {
	#name : #ZtEntity,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'timeStamp'
	],
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #accessing }
ZtEntity >> gtJsonDataFor: aView [
	<gtView>
	^ aView forward
		title: 'JSON Data';
		priority: 10;
		object: [ rawData ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #initializing }
ZtEntity >> initializeFromRawData [
]

{ #category : #accessing }
ZtEntity >> key [
	^ rawData at: #key
]

{ #category : #initializing }
ZtEntity >> rawData: aDictionary [
	rawData := aDictionary.
	timeStamp := DateAndTime now.
	self initializeFromRawData
]
