Class {
	#name : #OAEntity,
	#superclass : #Object,
	#instVars : [
		'rawData'
	],
	#category : #'KhGToolkitCustomization-OpenAlex'
}

{ #category : #inspecting }
OAEntity >> gtIdsFor: aView [
	<gtView>
	^ aView forward
		title: 'IDs';
		priority: 7;
		object: [ self ids ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #inspecting }
OAEntity >> gtJsonDataFor: aView [
	<gtView>
	^ aView forward
		title: 'JSON Data';
		priority: 10;
		object: [ rawData ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #inspecting }
OAEntity >> ids [
	^ rawData at: 'ids'
]

{ #category : #accessing }
OAEntity >> openAlexId [
	^ (#/ split: (rawData at: #id)) last
]

{ #category : #printing }
OAEntity >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: self openAlexId.
	aStream nextPutAll: ', '.
	aStream nextPutAll: (rawData at: 'display_name').
	aStream nextPut: $)
]

{ #category : #accessing }
OAEntity >> rawData [
	^ rawData
]

{ #category : #accessing }
OAEntity >> rawData: aDictionary [
	rawData := aDictionary
]
