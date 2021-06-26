Class {
	#name : #GitHubEntity,
	#superclass : #Object,
	#instVars : [
		'rawData'
	],
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #initializing }
GitHubEntity >> initializeFromRawData [
]

{ #category : #initializing }
GitHubEntity >> rawData: aDictionary [
	rawData := aDictionary.
	self initializeFromRawData
]

{ #category : #operating }
GitHubEntity >> rawDataFromUrl: aString [
	| url curlyBrace |
	url := aString copyUpTo: ${.
	^ STON fromString:
		(ZnClient new get: url)
]
