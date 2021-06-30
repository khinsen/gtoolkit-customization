Class {
	#name : #GitHubUser,
	#superclass : #GitHubRepositoryOwner,
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #'instance creation' }
GitHubUser class >> login: aString [
	^ self allInstances
		detect: [ :each | each login = aString and: [ each isStale not ] ]
		ifNone: [
			self new
				apiUrl: 'https://api.github.com/users/', aString;
				update ]
]

{ #category : #accessing }
GitHubUser >> gtDisplayOn: aStream [
	aStream << self login
]

{ #category : #accessing }
GitHubUser >> login [
	^ rawData at: 'login'
]

{ #category : #printing }
GitHubUser >> printOn: aStream [
	super printOn: aStream.
	aStream << $(; << self login ; << $)
]
