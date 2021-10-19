Class {
	#name : #ZtCollection,
	#superclass : #ZtEntity,
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #accessing }
ZtCollection >> name [
	^ (rawData at: #data) at: #name
]

{ #category : #printing }
ZtCollection >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< self name;
		<< $)
]
