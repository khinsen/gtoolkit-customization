Class {
	#name : #GitHubUser,
	#superclass : #GitHubRepositoryOwner,
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #'instance creation' }
GitHubUser class >> login: aString [
	^ self allInstances
		detect: [ :each | each login = aString ]
		ifNone: [
			self new
				rawData: (STON fromString:
								(ZnClient new get:
									'https://api.github.com/users/', aString)) ]
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
