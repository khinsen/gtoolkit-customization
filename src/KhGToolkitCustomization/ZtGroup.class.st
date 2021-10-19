Class {
	#name : #ZtGroup,
	#superclass : #ZtEntity,
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #accessing }
ZtGroup >> name [
	^ (rawData at: #data) at: #name
]

{ #category : #printing }
ZtGroup >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< self name;
		<< $)
]
