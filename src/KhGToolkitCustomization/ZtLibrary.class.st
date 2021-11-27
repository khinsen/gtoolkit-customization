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
		'collections',
		'collectionTree',
		'itemTree'
	],
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #organizing }
ZtLibrary >> buildItemTree [
	| itemTreeIndex |
	itemTreeIndex := Dictionary new.
	items keysDo: [ :key |
		itemTreeIndex at: key put: { key. OrderedCollection new } ].
	itemTree := OrderedCollection new.
	items keysAndValuesDo: [ :key :item |
		| treeNode |
		treeNode := itemTreeIndex at: key.
		item parentKey
			ifNil: [ itemTree add: treeNode ]
			ifNotNil: [ :p | (itemTreeIndex at: p) second add: treeNode ] ].
	itemTree do: [ :each | self replaceKeysIn: each ].
]

{ #category : #accessing }
ZtLibrary >> cacheDirectory [
	self subclassResponsibility
]

{ #category : #persistence }
ZtLibrary >> cacheFile [
	^ self cacheDirectory / ('library-', version asString, '.ston')
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
	self saveToCache.
]

{ #category : #inspecting }
ZtLibrary >> gtItemsFor: aView [
	<gtView>
	items ifEmpty: [ ^ aView empty ].
	^ aView columnedTree
		title: 'Items';
		priority: 0;
		items: [ itemTree ];
		column: #Item text: [ :each | each first printString ];
		children: #second;
		yourself
]

{ #category : #accessing }
ZtLibrary >> initialize [
	version := 0.
	collections := Dictionary new.
	items := Dictionary new
]

{ #category : #initializing }
ZtLibrary >> initializeFromRawData: aDictionary [ 
	collections := ((aDictionary at: #collections) collect: [ :each |
			(each at: #key)
				-> (ZtCollection new
						"storage: self storage;"
						rawData: each) ]) asDictionary.
	items := ((aDictionary at: #items) collect: [ :each |
			(each at: #key)
			-> (ZtItem new
					storage: self storage;
					rawData: each) ]) asDictionary.
]

{ #category : #accessing }
ZtLibrary >> items [
	^ (self multiRequest: '/items') collect: [ :each |
			ZtItem new
				storage: self storage;
				rawData: each ]
]

{ #category : #initializing }
ZtLibrary >> loadData [
	self loadFromCache
		ifTrue: [ self syncWithServer ]
		ifFalse: [ self downloadFromServer].
	self buildItemTree
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
	cacheFiles := self cacheDirectory children select: [ :each |
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
		Transcript nextPutAll: 'multiRequest: '; nextPutAll: path; cr.
		client := self clientForRequest: path start: dataItems size limit: 100.
		dataItems addAll: client get.
		itemCount := (client response headers at: 'Total-Results') asInteger.
		Transcript nextPutAll: 'itemCount: '; nextPutAll: itemCount asString; cr.
		Transcript nextPutAll: 'dataItems size: '; nextPutAll: (dataItems size) asString; cr.
		versionFromLastRequest :=
			(client response headers at: 'Last-Modified-Version')
				asInteger.
	dataItems size < itemCount ] whileTrue.
	^ dataItems
]

{ #category : #organizing }
ZtLibrary >> replaceKeysIn: aTreeNode [
	| item |
	item := items at: aTreeNode first.
	aTreeNode at: 1 put: item.
	self
		assert: item numberOfChildren
		equals: aTreeNode second size.
	aTreeNode second do: [ :each | self replaceKeysIn: each ]
]

{ #category : #persistence }
ZtLibrary >> saveToCache [ 
	| data |
	data := Dictionary
			with: #collections -> (collections values collect: #rawData)
			with: #items -> (items values collect: #rawData).
	self cacheFile writeStreamDo: [ :s |
		STON put: data onStream: s ]
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
	Transcript cr; nextPutAll: 'Collections'; cr.
	currentVersions := self versionsFromServerForPath: '/collections?'.
	Transcript nextPutAll: currentVersions asString; cr.
	keysToUpdate := self update: collections from: currentVersions.
	Transcript nextPutAll: 'Keys: '; nextPutAll: keysToUpdate asString; cr.
	keysToUpdate ifNotEmpty: [
		updates := self multiRequest: ('/collections?collectionKey=',( ',' join: keysToUpdate)).
		updates do: [ :each |
			| key entity |
			key := each at: #key.
			Transcript nextPutAll: 'Updating: '; nextPutAll: key asString; cr.
			entity := (collections at: key ifAbsent: ZtCollection new ).
			entity rawData: each ] ].

	Transcript cr; nextPutAll: 'Items'; cr.
	currentVersions := self versionsFromServerForPath: '/items?includeTrashed=1&'.
	Transcript nextPutAll: currentVersions asString; cr.
	keysToUpdate := self update: items from: currentVersions.
	Transcript nextPutAll: 'Keys: '; nextPutAll: keysToUpdate asString; cr.
	keysToUpdate ifNotEmpty: [
		| requestPath |
		requestPath := '/items?itemKey=', (',' join: keysToUpdate).
		updates := self multiRequest: requestPath.
		updates do: [ :each |
			| key entity |
			key := each at: #key.
			Transcript nextPutAll: 'Updating: '; nextPutAll: key asString; cr.
			entity := (items at: key ifAbsent: ZtItem new ).
			entity rawData: each ] ].

	versionFromLastRequest > version ifTrue: [
		version := versionFromLastRequest.
		self saveToCache ]
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
	| client versions |
	client :=  ZtApiClient new
		beOneShot;
		user: self user;
		path: self urlPrefix,
			aString, ('since=', version asString), '&format=versions'.
	versions := client get.
	versionFromLastRequest :=
			(client response headers at: 'Last-Modified-Version')
				asInteger.
	^ versions
]
