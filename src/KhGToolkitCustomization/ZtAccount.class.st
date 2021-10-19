Class {
	#name : #ZtAccount,
	#superclass : #Object,
	#instVars : [
		'userId',
		'apiToken',
		'storage'
	],
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #'instance creation' }
ZtAccount class >> fromStoredCredentials [
	| apiTokenFile userIdAndToken userId apiToken |
	apiTokenFile := FileLocator preferences / 'pharo' / 'zotero-access-token.txt'.
	apiTokenFile exists ifFalse: [ self error: 'API token file missing' ].
	userIdAndToken := $: split: apiTokenFile contents trim.
	userId := userIdAndToken first.
	apiToken := userIdAndToken second.
	^ self userId: userId apiToken: apiToken
]

{ #category : #'instance creation' }
ZtAccount class >> userId: userId apiToken: apiToken [
	^ self new
		userId: userId;
		apiToken: apiToken;
		yourself
]

{ #category : #accessing }
ZtAccount >> apiToken [
	^ apiToken
]

{ #category : #accessing }
ZtAccount >> apiToken: aString [
	apiToken := aString
]

{ #category : #accessing }
ZtAccount >> collections [
	| client itemCount someItems linkHeader |
	client :=
		ZtApiClient new
			beOneShot;
			account: self;
			path: 'users/', userId, '/collections'.
	someItems := client get collect: [ :each |
					ZtCollection new
						"storage: self storage;"
						rawData: each ].
	itemCount := (client response headers at: 'Total-Results') asInteger.
	linkHeader := client response headers at: 'Link'.
	^ { itemCount. someItems. linkHeader }
]

{ #category : #accessing }
ZtAccount >> groups [
	^ (ZtApiClient new
		beOneShot;
		account: self;
		path: 'users/', userId, '/groups';
		get) collect: [ :each |
			ZtGroup new rawData: each ].
]

{ #category : #accessing }
ZtAccount >> items [
	| client itemCount someItems linkHeader |
	client :=
		ZtApiClient new
			beOneShot;
			account: self;
			path: 'users/', userId, '/items'.
	someItems := client get collect: [ :each |
					ZtItem new
						storage: self storage;
						rawData: each ].
	itemCount := (client response headers at: 'Total-Results') asInteger.
	linkHeader := client response headers at: 'Link'.
	^ { itemCount. someItems. linkHeader }
]

{ #category : #accessing }
ZtAccount >> storage [
	^ storage
]

{ #category : #accessing }
ZtAccount >> storage: aZtStorage [
	storage := aZtStorage
]

{ #category : #accessing }
ZtAccount >> topLevelItems [
	| client itemCount someItems linkHeader |
	client :=
		ZtApiClient new
			beOneShot;
			account: self;
			path: 'users/', userId, '/items/top'.
	someItems := client get collect: [ :each |
					ZtItem new
						storage: self storage;
						rawData: each ].
	itemCount := (client response headers at: 'Total-Results') asInteger.
	linkHeader := client response headers at: 'Link'.
	^ { itemCount. someItems. linkHeader }
]

{ #category : #accessing }
ZtAccount >> userId [
	^ userId
]

{ #category : #accessing }
ZtAccount >> userId: aString [
	userId := aString
]
