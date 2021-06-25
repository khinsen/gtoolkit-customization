Class {
	#name : #GitHubRepository,
	#superclass : #GitHubEntity,
	#instVars : [
		'name'
	],
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #accessing }
GitHubRepository >> fullName [
	^ rawData at: 'full_name'
]

{ #category : #accessing }
GitHubRepository >> name [
	^ ($/ split: self fullName) second
]

{ #category : #printing }
GitHubRepository >> printOn: aStream [
	super printOn: aStream.
	aStream << '('; << self fullName; << ')'.
]
