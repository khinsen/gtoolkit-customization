Class {
	#name : #GitHubOrganization,
	#superclass : #GitHubEntity,
	#instVars : [
		'repositories'
	],
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #'instance creation' }
GitHubOrganization class >> isResponsibleFor: aString [
	self subclassResponsibility
]

{ #category : #'instance creation' }
GitHubOrganization class >> name: aString [
	^ (self subclassForName: aString) new
		rawData: (STON fromString:
						(ZnClient new get:
							'https://api.github.com/orgs/', aString))
]

{ #category : #'instance creation' }
GitHubOrganization class >> subclassForName: aString [
	self allSubclassesDo: [ :each |
		(each isResponsibleFor: aString)
			ifTrue: [ ^ each ] ].
	^ self
]

{ #category : #initializing }
GitHubOrganization >> initializeFromRawData [
	repositories := Dictionary new.
	(STON fromString:
		(ZnClient new get: (rawData at: 'repos_url')))
		do: [ :each |
			| repo |
			repo := GitHubRepository new rawData: each.
			repositories at: repo name put: repo ]
]
