Class {
	#name : #ZtCollection,
	#superclass : #ZtEntity,
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #accessing }
ZtCollection >> name [
	^ (rawData at: #data) at: #name
]

{ #category : #accessing }
ZtCollection >> numberOfChildren [
	^ self numberOfCollections
]

{ #category : #accessing }
ZtCollection >> numberOfCollections [
	^ (rawData at: #meta) at: #numCollections
]

{ #category : #accessing }
ZtCollection >> numberOfItems [
	^ (rawData at: #meta) at: #numItems
]

{ #category : #accessing }
ZtCollection >> parentKey [
	^ (rawData at: #data) at: #parentCollection
		ifPresent: [ :p | p = false ifTrue: [ nil ] ifFalse: [ p ] ]
		ifAbsent: [ nil ]
]

{ #category : #printing }
ZtCollection >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< self name;
		<< $)
]
