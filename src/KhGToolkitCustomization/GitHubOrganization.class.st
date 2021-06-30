Class {
	#name : #GitHubOrganization,
	#superclass : #GitHubRepositoryOwner,
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #accessing }
GitHubOrganization class >> name: aString [
	^ self allInstances
		detect: [ :each | each name = aString and: [ each isStale not ] ]
		ifNone: [
			self new
				apiUrl: 'https://api.github.com/orgs/', aString;
				update ]
]

{ #category : #accessing }
GitHubOrganization >> name [
	^ rawData at: 'login'
]
