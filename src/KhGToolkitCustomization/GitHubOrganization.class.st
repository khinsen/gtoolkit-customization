Class {
	#name : #GitHubOrganization,
	#superclass : #GitHubRepositoryOwner,
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #accessing }
GitHubOrganization class >> name: aString [
	^ self new
		rawData: (STON fromString:
						(GitHubAPI new client get:
							'https://api.github.com/orgs/', aString))
]
