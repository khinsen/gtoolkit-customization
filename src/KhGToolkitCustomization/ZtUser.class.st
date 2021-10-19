Class {
	#name : #ZtUser,
	#superclass : #Object,
	#instVars : [
		'userId',
		'apiToken',
		'storage'
	],
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #'instance creation' }
ZtUser class >> fromStoredCredentials [
	| apiTokenFile userIdAndToken userId apiToken |
	apiTokenFile := FileLocator preferences / 'pharo' / 'zotero-access-token.txt'.
	apiTokenFile exists ifFalse: [ self error: 'API token file missing' ].
	userIdAndToken := $: split: apiTokenFile contents trim.
	userId := userIdAndToken first.
	apiToken := userIdAndToken second.
	^ self userId: userId apiToken: apiToken
]

{ #category : #'instance creation' }
ZtUser class >> userId: userId apiToken: apiToken [
	^ self new
		userId: userId;
		apiToken: apiToken;
		yourself
]

{ #category : #accessing }
ZtUser >> apiToken [
	^ apiToken
]

{ #category : #accessing }
ZtUser >> apiToken: aString [
	apiToken := aString
]

{ #category : #accessing }
ZtUser >> groups [
	^ (ZtApiClient new
		beOneShot;
		user: self;
		path: 'users/', userId, '/groups';
		get) collect: [ :each |
			ZtGroup new
				accessingMember: self;
				rawData: each;
				yourself ].
]

{ #category : #accessing }
ZtUser >> library [
	^ ZtUserLibrary user: self
]

{ #category : #accessing }
ZtUser >> userId [
	^ userId
]

{ #category : #accessing }
ZtUser >> userId: aString [
	userId := aString
]
