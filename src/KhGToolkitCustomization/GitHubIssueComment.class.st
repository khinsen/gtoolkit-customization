Class {
	#name : #GitHubIssueComment,
	#superclass : #GitHubEntity,
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #accessing }
GitHubIssueComment >> asElement [
	^ (LeTextSnippet new string: self body)
		asPreviewElement
]

{ #category : #accessing }
GitHubIssueComment >> body [
	^ rawData at: 'body'
]

{ #category : #accessing }
GitHubIssueComment >> gtCommentFor: aView [
	<gtView>
	^ aView forward
		title: 'Comment';
		priority: 1;
		object: [ Dictionary
					with: #user -> self user
					with: #date -> self creationTime asDate
					with: #body ->self body ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #printing }
GitHubIssueComment >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< self user;
		<< ', ';
		<< self creationTime asString;
		<< $)
]

{ #category : #accessing }
GitHubIssueComment >> user [
	^ (rawData at: 'user') at: 'login'
]
