Class {
	#name : #GitHubIssueComment,
	#superclass : #GitHubEntity,
	#instVars : [
		'user'
	],
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
	^ aView explicit
		title: 'Comment body';
		priority: 1;
		stencil: [
			(LeTextSnippet new string: self body)
				asPreviewElement];
		yourself
]

{ #category : #accessing }
GitHubIssueComment >> gtMentionsFor: aView [
	<gtView>
	^ aView list
		title: 'Mentions';
		priority: 2;
		items: [ self mentions ];
		yourself
]

{ #category : #accessing }
GitHubIssueComment >> mentions [
	^ GitHubParser usernamesFromText: self body
]

{ #category : #printing }
GitHubIssueComment >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< self user login;
		<< ', ';
		<< self creationTime asDate asString;
		<< $)
]

{ #category : #accessing }
GitHubIssueComment >> user [
	^ user ifNil: [
		user := GitHubUser
			login: ((rawData at: 'user') at: 'login') ]
]
