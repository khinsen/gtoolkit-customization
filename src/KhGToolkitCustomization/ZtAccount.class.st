Class {
	#name : #ZtAccount,
	#superclass : #Object,
	#instVars : [
		'userId',
		'apiToken'
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
ZtAccount >> groups [
	^ ZtApiClient new
		beOneShot;
		account: self;
		path: 'users/', userId, '/groups';
		get.
]

{ #category : #accessing }
ZtAccount >> items [
	| client itemCount someItems linkHeader |
	client :=
		ZtApiClient new
			beOneShot;
			account: self;
			path: 'users/', userId, '/items'.
	someItems := client get.
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
