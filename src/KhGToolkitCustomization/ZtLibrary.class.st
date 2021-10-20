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

{ #category : #accessing }
ZtLibrary >> topLevelItems [
	^ (self multiRequest: '/items/top') collect: [ :each |
			ZtItem new
				storage: self storage;
				rawData: each ]
]

{ #category : #accessing }
ZtLibrary >> urlPrefix [
	self subclassResponsibility
]

{ #category : #accessing }
ZtLibrary >> user [
	self subclassResponsibility
]
