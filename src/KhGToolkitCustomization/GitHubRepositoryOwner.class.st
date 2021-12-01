Class {
	#name : #GitHubRepositoryOwner,
	#superclass : #GitHubEntity,
	#instVars : [
		'repositories',
		'avatarPicture',
		'apiUrl'
	],
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #accessing }
GitHubRepositoryOwner >> apiUrl [
	^ apiUrl
]

{ #category : #accessing }
GitHubRepositoryOwner >> apiUrl: anUrl [
	apiUrl := anUrl
]

{ #category : #accessing }
GitHubRepositoryOwner >> avatarPicture [
	| client |
	client := GitHubAPI new client.
	client
		url: (rawData at: 'avatar_url');
		get.
	^ ImageReadWriter formFromStream:
			client entity readStream
]

{ #category : #inspecting }
GitHubRepositoryOwner >> gtAvatarPictureFor: aView [
	<gtView>
	^ aView explicit
		title: 'Avatar';
		priority: 9;
		stencil: [ self avatarPicture asElement ]
		yourself
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
		(self paginatedRawDataFromUrl: (rawData at: 'repos_url'))
			do: [ :each |
				| repo |
				repo := GitHubRepository new rawData: each.
				repositories at: repo name put: repo ] ].
	^ repositories
]

{ #category : #initializing }
GitHubRepositoryOwner >> update [
	self rawData:
		(GitHubAPI new jsonClient
				get: self apiUrl)
]
