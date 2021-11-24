Class {
	#name : #ZtLibrary,
	#superclass : #Object,
	#instVars : [
		'urlPrefix',
		'storage',
		'version',
		'versionFromLastRequest',
		'topLevelItems',
		'items',
		'collections'
	],
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #accessing }
ZtLibrary >> clientForRequest: path start: firstIndex limit: anInteger [
	^ ZtApiClient new
		beOneShot;
		user: self user;
		path: self urlPrefix, path;
		queryAt: #start put: firstIndex asString;
		queryAt: #limit put: anInteger asString.
]

{ #category : #accessing }
ZtLibrary >> collections [
	^ (self multiRequest: '/collections') collect: [ :each |
			ZtCollection new
				"storage: self storage;"
				rawData: each ]
]

{ #category : #accessing }
ZtLibrary >> initialize [
	version := 0.
	collections := OrderedCollection new.
	items := OrderedCollection new.
	topLevelItems := OrderedCollection new.
]

{ #category : #accessing }
ZtLibrary >> items [
	^ (self multiRequest: '/items') collect: [ :each |
			ZtItem new
				storage: self storage;
				rawData: each ]
]

{ #category : #accessing }
ZtLibrary >> multiRequest: path [
	| items client itemCount |
	items := OrderedCollection new.
	[
		client := self clientForRequest: path start: items size limit: 100.
		items addAll: client get.
		itemCount := (client response headers at: 'Total-Results') asInteger.
		versionFromLastRequest := client response headers at: 'Last-Modified-Version' asInteger.
	items size < itemCount ] whileTrue.
	^ items
]

{ #category : #accessing }
ZtLibrary >> storage [
	^ storage
]

{ #category : #accessing }
ZtLibrary >> storage: aZtStorage [
	storage := aZtStorage
]

{ #category : #syncing }
ZtLibrary >> syncWithServer [
	| collectionVersions |
	collectionVersions := self versionsFromServerForPath: '/collections'.
	self update: collections from: collectionVersions.
	self versionsFromServerForPath: '/items/top&includeTrashed=1'.
	self versionsFromServerForPath: '/items&includeTrashed=1'.
]

{ #category : #accessing }
ZtLibrary >> topLevelItems [
	^ (self multiRequest: '/items/top') collect: [ :each |
			ZtItem new
				storage: self storage;
				rawData: each ]
]

{ #category : #syncing }
ZtLibrary >> update: entities from: versions [
	| forDeletion forUpdating |
	forDeletion := OrderedCollection new.
	forUpdating := OrderedCollection new.
	entities do: [ :each |
		versions at: each key
			ifPresent: [ :v | forUpdating add: each ]
			ifAbsent: [ forDeletion add: each ].
		versions removeKey: each key ].
	forDeletion do: [ :each | entities remove: each ].
	versions associationsDo: [ :each |
		forUpdating add: each key "should create new ZtEntity object here" ]
]

{ #category : #accessing }
ZtLibrary >> urlPrefix [
	self subclassResponsibility
]

{ #category : #accessing }
ZtLibrary >> user [
	self subclassResponsibility
]

{ #category : #syncing }
ZtLibrary >> versionsFromServerForPath: aString [
	^ ZtApiClient new
		beOneShot;
		user: self user;
		path: self urlPrefix,
			aString, ('&since=', version asString), '&format=versions';
		get
]
