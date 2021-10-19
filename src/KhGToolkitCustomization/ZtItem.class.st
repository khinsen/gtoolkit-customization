Class {
	#name : #ZtItem,
	#superclass : #ZtEntity,
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #accessing }
ZtItem >> itemType [
	^ (rawData at: #data) at: #itemType
]

{ #category : #accessing }
ZtItem >> key [
	^ rawData at: #key
]

{ #category : #accessing }
ZtItem >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< self key;
		<< ', ';
		<< self itemType;
		<< $)
]
