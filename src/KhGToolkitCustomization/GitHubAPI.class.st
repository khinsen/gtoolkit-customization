Class {
	#name : 'GitHubAPI',
	#superclass : 'Object',
	#instVars : [
		'login',
		'apiToken'
	],
	#category : 'KhGToolkitCustomization-GitHub'
}

{ #category : 'accessing' }
GitHubAPI >> client [
	| client |
	client := ZnClient new.
	apiToken ifNotNil: [ client username: login password: apiToken ].
	^ client
]

{ #category : 'initializing' }
GitHubAPI >> initialize [
	self loadApiToken
]

{ #category : 'initializing' }
GitHubAPI >> loadApiToken [
	| apiTokenFile |
	apiTokenFile := FileLocator preferences / 'pharo' / 'github-access-token.txt'.
	apiTokenFile exists ifTrue: [
		| loginAndToken |
		loginAndToken := $: split: apiTokenFile contents trim.
		login := loginAndToken first.
		apiToken := loginAndToken second ]
]
