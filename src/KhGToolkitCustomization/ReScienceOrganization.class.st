Class {
	#name : #ReScienceOrganization,
	#superclass : #GitHubOrganization,
	#instVars : [
		'repositories'
	],
	#category : #'KhGToolkitCustomization-ReScience'
}

{ #category : #'instance creation' }
ReScienceOrganization class >> isResponsibleFor: aString [
	^ aString asLowercase = 'rescience'
]

{ #category : #accessing }
ReScienceOrganization >> initializeFromRawData [
	super initializeFromRawData.
]

{ #category : #accessing }
ReScienceOrganization >> repositories [
	^ repositories
]
