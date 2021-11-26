Class {
	#name : #ZtUser,
	#superclass : #Object,
	#instVars : [
		'userId',
		'apiToken',
		'storage',
		'groups'
	],
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #'instance creation' }
ZtUser class >> fromStoredCredentials [
	| apiTokenFile userIdAndToken userId apiToken |
	apiTokenFile := FileLocator preferences / 'pharo' / 'zotero-access-token.txt'.
	apiTokenFile exists ifFalse: [ self error: 'API token file missing' ].
	userIdAndToken := $: split: apiTokenFile contents trim.
	userId := userIdAndToken first asInteger.
	apiToken := userIdAndToken second.
	^ self userId: userId apiToken: apiToken
]

{ #category : #'instance creation' }
ZtUser class >> userId: userId apiToken: apiToken [
	^ self new
		userId: userId;
		apiToken: apiToken;
		syncGroupsWithServer;
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
ZtUser >> groupFromServer: anInteger [
	| rawData |
	rawData := ZtApiClient new
		beOneShot;
		user: self;
		path: 'groups/', anInteger asString;
		get.
	^ ZtGroup new
		accessingMember: self;
		rawData: rawData;
		yourself.
]

{ #category : #accessing }
ZtUser >> groupVersionsFromServer [
	^ (ZtApiClient new
		beOneShot;
		user: self;
		path: 'users/', userId asString, '/groups/?format=versions';
		get)
]

{ #category : #accessing }
ZtUser >> groups [
	^ groups
]

{ #category : #accessing }
ZtUser >> groupsFromServer [
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

{ #category : #initializing }
ZtUser >> initialize [
	groups := OrderedCollection new
]

{ #category : #accessing }
ZtUser >> library [
	^ ZtUserLibrary user: self
]

{ #category : #syncing }
ZtUser >> syncGroupsWithServer [
	| versions forDeletion |
	versions := self groupVersionsFromServer.
	forDeletion := OrderedCollection new.
	groups do: [ :each |
		versions at: (each groupId asString)
			ifPresent: [ :v | each syncWithServerAtVersion: v ]
			ifAbsent: [ forDeletion add: each ].
		versions removeKey: each groupId asString ].
	forDeletion do: [ :each | groups remove: each ].
	versions associationsDo: [ :each |
		groups add: (self groupFromServer: each key asInteger) ]
]

{ #category : #accessing }
ZtUser >> userId [
	^ userId
]

{ #category : #accessing }
ZtUser >> userId: aString [
	userId := aString
]
