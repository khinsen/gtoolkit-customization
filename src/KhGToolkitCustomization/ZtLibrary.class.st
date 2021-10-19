Class {
	#name : #ZtLibrary,
	#superclass : #Object,
	#instVars : [
		'urlPrefix',
		'storage'
	],
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #accessing }
ZtLibrary >> collections [
	| client itemCount someItems linkHeader |
	client :=
		ZtApiClient new
			beOneShot;
			user: self user;
			path: self urlPrefix, '/collections'.
	someItems := client get collect: [ :each |
					ZtCollection new
						"storage: self storage;"
						rawData: each ].
	itemCount := (client response headers at: 'Total-Results') asInteger.
	linkHeader := client response headers at: 'Link'.
	^ { itemCount. someItems. linkHeader }
]

{ #category : #accessing }
ZtLibrary >> items [
	| client itemCount someItems linkHeader |
	client :=
		ZtApiClient new
			beOneShot;
			user: self user;
			path: self urlPrefix, '/items'.
	someItems := client get collect: [ :each |
					ZtItem new
						storage: self storage;
						rawData: each ].
	itemCount := (client response headers at: 'Total-Results') asInteger.
	linkHeader := client response headers at: 'Link'.
	^ { itemCount. someItems. linkHeader }
]

{ #category : #accessing }
ZtLibrary >> storage [
	^ storage
]

{ #category : #accessing }
ZtLibrary >> storage: aZtStorage [
	storage := aZtStorage
]

{ #category : #accessing }
ZtLibrary >> topLevelItems [
	| client itemCount someItems linkHeader |
	client :=
		ZtApiClient new
			beOneShot;
			user: self user;
			path: self urlPrefix, '/items/top'.
	someItems := client get collect: [ :each |
					ZtItem new
						storage: self storage;
						rawData: each ].
	itemCount := (client response headers at: 'Total-Results') asInteger.
	linkHeader := client response headers at: 'Link'.
	^ { itemCount. someItems. linkHeader }
]

{ #category : #accessing }
ZtLibrary >> urlPrefix [
	self subclassResponsibility
]

{ #category : #accessing }
ZtLibrary >> user [
	self subclassResponsibility
]
