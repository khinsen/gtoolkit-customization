Class {
	#name : #GitHubRepositoryOwner,
	#superclass : #GitHubEntity,
	#instVars : [
		'repositories'
	],
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #accessing }
GitHubRepositoryOwner >> avatarPicture [
	| client |
	(client := ZnClient new)
				url: (rawData at: 'avatar_url');
				get.
	^ ImageReadWriter formFromStream:
			client entity readStream
]

{ #category : #accessing }
GitHubRepositoryOwner >> gtRepositoriesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Repositories';
		priority: 8;
		items: [ self repositories associations
					sort: [ :a :b | a key <= b key ] ];
		column: 'Name' text: #key;
		column: 'Open issues' text: [ :each | each value numberOfOpenIssues ];
		send: #value;
		yourself
]

{ #category : #accessing }
GitHubRepositoryOwner >> repositories [
	repositories ifNil: [
		repositories := Dictionary new.
		(self rawDataFromUrl: (rawData at: 'repos_url'))
			do: [ :each |
				| repo |
				repo := GitHubRepository new rawData: each.
				repositories at: repo name put: repo ] ].
	^ repositories
]
