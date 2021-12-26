Class {
	#name : #OaiSet,
	#superclass : #Object,
	#instVars : [
		'spec',
		'name',
		'description'
	],
	#category : #'KhGToolkitCustomization-OAI'
}

{ #category : #accessing }
OaiSet >> description [
	^ description
]

{ #category : #accessing }
OaiSet >> description: anXMLElement [
	description := anXMLElement
]

{ #category : #accessing }
OaiSet >> name [
	^ name
]

{ #category : #accessing }
OaiSet >> name: aString [
	name := aString
]

{ #category : #printing }
OaiSet >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self spec printOn: aStream.
	aStream nextPutAll: ', '.
	self name ifNotNil: [ :n | n printOn: aStream ].
	aStream nextPut: $).
]

{ #category : #accessing }
OaiSet >> spec [
	^ spec
]

{ #category : #accessing }
OaiSet >> spec: aString [
	spec := aString
]
