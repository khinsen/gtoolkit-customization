Class {
	#name : #GitHubOrganization,
	#superclass : #GitHubEntity,
	#instVars : [
		'repositories'
	],
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #'instance creation' }
GitHubOrganization class >> name: aString [
	^ self new
		rawData: (STON fromString:
						(ZnClient new get:
							'https://api.github.com/orgs/', aString))
]

{ #category : #initializing }
GitHubOrganization >> initializeFromRawData [
	repositories := Dictionary new.
	(self rawDataFromUrl: (rawData at: 'repos_url'))
		do: [ :each |
			| repo |
			repo := GitHubRepository new rawData: each.
			repositories at: repo name put: repo ]
]

{ #category : #accessing }
GitHubOrganization >> repositories [
	^ repositories
]
