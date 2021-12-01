Class {
	#name : #GitHubAPI,
	#superclass : #Object,
	#instVars : [
		'login',
		'apiToken'
	],
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #accessing }
GitHubAPI >> client [
	| client |
	client :=
		ZnClient new
			headerAt: 'Accept' put: 'application/vnd.github.v3+json'.
	apiToken ifNotNil:
		[ client username: login password: apiToken ].
	^ client
]

{ #category : #initializing }
GitHubAPI >> initialize [
	self loadApiToken
]

{ #category : #accessing }
GitHubAPI >> jsonClient [
	| client |
	client := self client.
	client contentReader: [ :entity | NeoJSONReader fromString: entity contents ].
	^ client
]

{ #category : #initializing }
GitHubAPI >> loadApiToken [
	| apiTokenFile |
	apiTokenFile := FileLocator preferences / 'pharo' / 'github-access-token.txt'.
	apiTokenFile exists ifTrue: [
		| loginAndToken |
		loginAndToken := $: split: apiTokenFile contents trim.
		login := loginAndToken first.
		apiToken := loginAndToken second ]
]
