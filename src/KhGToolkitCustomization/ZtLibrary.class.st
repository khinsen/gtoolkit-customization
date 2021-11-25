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

{ #category : #persistence }
ZtLibrary >> cacheFile [
	^ self user cacheDirectory / ('library-', version asString, '.ston')
]

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

{ #category : #initializing }
ZtLibrary >> downloadFromServer [
	| collectionRawData itemRawData completeRawData |
	collectionRawData := self multiRequest: '/collections'.
	itemRawData := self multiRequest: '/items'.
	completeRawData := Dictionary
						with: #collections -> collectionRawData
						with:#items -> itemRawData.
	self initializeFromRawData: completeRawData.
	version := versionFromLastRequest.
	self saveRawData: completeRawData
]

{ #category : #accessing }
ZtLibrary >> initialize [
	version := 0.
	collections := Dictionary new.
	items := Dictionary new
]

{ #category : #initializing }
ZtLibrary >> initializeFromRawData: aDictionary [ 
	collections := (aDictionary at: #collections) collect: [ :each |
			(each at: #key)
				-> (ZtCollection new
						"storage: self storage;"
						rawData: each) ].
	items := (aDictionary at: #items) collect: [ :each |
			(each at: #key)
			-> (ZtItem new
					storage: self storage;
					rawData: each) ].
]

{ #category : #accessing }
ZtLibrary >> items [
	^ (self multiRequest: '/items') collect: [ :each |
			ZtItem new
				storage: self storage;
				rawData: each ]
]

{ #category : #accessing }
ZtLibrary >> loadFromCache [
	| cache data |
	cache := self mostRecentCacheFile.
	cache second ifNil: [ ^ false ].
	data := cache second readStreamDo: [ :s | STON fromStream: s ].
	self initializeFromRawData: data.
	version := cache first.
	^ true
]

{ #category : #persistence }
ZtLibrary >> mostRecentCacheFile [
	| cacheFiles maxVersion maxVersionFile |
	cacheFiles := self user cacheDirectory children select: [ :each |
		(each basename beginsWith: 'library-')
		and: [ each basename endsWith: '.ston' ] ].
	maxVersion := 0.
	maxVersionFile := nil.
	cacheFiles do: [ :each |
		| cacheVersion |
		cacheVersion := ((each basename copyAfter: $-) copyUpTo: $.) asInteger.
		cacheVersion > maxVersion ifTrue: [
			maxVersion := cacheVersion.
			maxVersionFile := each ] ].
	^ { maxVersion. maxVersionFile }
]

{ #category : #accessing }
ZtLibrary >> multiRequest: path [
	| dataItems client itemCount |
	dataItems := OrderedCollection new.
	[
		client := self clientForRequest: path start: dataItems size limit: 100.
		dataItems addAll: client get.
		itemCount := (client response headers at: 'Total-Results') asInteger.
		versionFromLastRequest :=
			(client response headers at: 'Last-Modified-Version')
				asInteger.
	dataItems size < itemCount ] whileTrue.
	^ dataItems
]

{ #category : #persistence }
ZtLibrary >> saveRawData: completeRawData [ 
	self cacheFile writeStreamDo: [ :s |
		STON put: completeRawData onStream: s ]
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
	| currentVersions keysToUpdate updates |
	currentVersions := self versionsFromServerForPath: '/collections'.
	keysToUpdate := self update: collections from: currentVersions.
	updates := self multiRequest: ('/collections?collectionKey=', ',' join: keysToUpdate).
	updates do: [ :each |
		| key entity |
		key := each at: #key.
		entity := (collections at: key ifAbsent: ZtCollection new ).
		entity rawData: each ].

	currentVersions := self versionsFromServerForPath: '/items&includeTrashed=1'.
	keysToUpdate := self update: items from: currentVersions.
	updates := self multiRequest: ('/items?itemKey=', ',' join: keysToUpdate).
	updates do: [ :each |
		| key entity |
		key := each at: #key.
		entity := (items at: key ifAbsent: ZtItem new ).
		entity rawData: each ].
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
	| keysToUpdate |
	keysToUpdate := OrderedCollection new.
	versions keysAndValuesDo: [ :key :newVersion |
		entities at: key
			ifPresent: [ :entity |
				entity version = newVersion
					ifFalse: [ keysToUpdate add: key ] ]
			ifAbsent: [ keysToUpdate add: key ] ].
	^ keysToUpdate
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
