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
