Class {
	#name : #GitHubIssue,
	#superclass : #GitHubEntity,
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #accessing }
GitHubIssue >> changeTime [
	^ (rawData at: 'updated_at') asDateAndTime
]

{ #category : #accessing }
GitHubIssue >> creationTime [
	^ (rawData at: 'created_at') asDateAndTime
]

{ #category : #accessing }
GitHubIssue >> durationSinceCreation [
	^ DateAndTime now - self creationTime
]

{ #category : #accessing }
GitHubIssue >> durationSinceLastUpdate [
	^ DateAndTime now - self changeTime
]

{ #category : #printing }
GitHubIssue >> gtDisplayOn: aStream [
	aStream << self title
]

{ #category : #printing }
GitHubIssue >> printOn: aStream [
	super printOn: aStream.
	aStream << $(; << self title; << $)
]

{ #category : #accessing }
GitHubIssue >> title [
	^ rawData at: 'title'
]
