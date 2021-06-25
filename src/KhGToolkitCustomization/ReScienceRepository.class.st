Class {
	#name : #ReScienceRepository,
	#superclass : #GitHubRepository,
	#instVars : [
		'url',
		'name'
	],
	#category : #'KhGToolkitCustomization-ReScience'
}

{ #category : #accessing }
ReScienceRepository >> initializeFromURL: aString [
	self rawData:
		(STON fromString:
			(ZnClient new get: aString ))
]

{ #category : #accessing }
ReScienceRepository >> name [
	^ name
]

{ #category : #printing }
ReScienceRepository >> printOn: aStream [
	super printOn: aStream.
	aStream << '('; << name; << ')'.
]

{ #category : #initializing }
ReScienceRepository >> rawData: aDictionary [
	rawData := aDictionary.
	url := aDictionary at: 'html_url'.
	name := ($/ split: (aDictionary at: 'full_name')) second.
]
