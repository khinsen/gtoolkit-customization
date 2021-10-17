"
See the [API documentation](https://www.zotero.org/support/dev/web_api/v3/start)

"
Class {
	#name : #ZtAPI,
	#superclass : #Object,
	#instVars : [
		'apiToken',
		'login'
	],
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #accessing }
ZtAPI >> client [
	| client |
	client := ZnClient new
				beOneShot;
				https;
				host: 'api.zotero.org';
				headerAt: 'Zotero-API-Version' put: '3';
				queryAt: 'format' put: 'json'.
	apiToken ifNotNil: [ client headerAt: 'Zotero-API-Key' put: apiToken ].
	^ client
]

{ #category : #accessing }
ZtAPI >> initialize [
	self loadApiToken
]

{ #category : #initializing }
ZtAPI >> loadApiToken [
	| apiTokenFile |
	apiTokenFile := FileLocator preferences / 'pharo' / 'zotero-access-token.txt'.
	apiTokenFile exists ifTrue: [
		| loginAndToken |
		loginAndToken := $: split: apiTokenFile contents trim.
		login := loginAndToken first.
		apiToken := loginAndToken second ]
]

{ #category : #accessing }
ZtAPI >> userItems [
	| client |
	client :=  self client
		path: 'users/', login, '/items'.
	client get.
	^ NeoJSONReader fromString: client contents
]
