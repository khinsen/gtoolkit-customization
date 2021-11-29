Class {
	#name : #ZtItem,
	#superclass : #ZtEntity,
	#instVars : [
		'library'
	],
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #accessing }
ZtItem >> children [
	^ (self library childrenOfItem: self key)
		collect: #first
]

{ #category : #accessing }
ZtItem >> collectionKeys [
	^ (rawData at: #data) at: #collections ifAbsent: [ Array new ]
]

{ #category : #accessing }
ZtItem >> fileDirectory [
	| directory |
	self library storage ifNil: [ ^ nil ].
	directory := self library storage directoryForKey: self key.
	directory exists ifFalse: [ ^ nil ].
	^ directory
]

{ #category : #inspecting }
ZtItem >> gtActionWebBrowseFor: anAction [
	<gtAction>
	|  button |
	^ self uniqueFileOrDirectory
		ifNil: [ self numberOfChildren = 0
					ifTrue: [ anAction noAction ]
					ifFalse: [ self children first gtActionWebBrowseFor: anAction ] ]
		ifNotNil: [ :fileReference |
			anAction explicit stencil: [
			button := BrButton new.
			button
				aptitude: BrGlamorousButtonWithIconAptitude;
				action:  [ WebBrowser openOn: fileReference fullName ];
				icon: BrGlamorousIcons go asElement;
				label: 'Open in OS' translated ] ]
]

{ #category : #inspecting }
ZtItem >> gtAttachmentsFor: aView [
	<gtView>
	self numberOfChildren = 0 ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Attachments';
		priority: 5;
		object: [ ZtItemGroup new itemTree:
					(self library childrenOfItem: self key) ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #inspecting }
ZtItem >> gtCollectionsFor: aView [
	<gtView>
	| collectionKeys |
	collectionKeys := self collectionKeys.
	collectionKeys ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Collections';
		priority: 7;
		items: [ collectionKeys collect: [ :each |
				 	self library collectionWithKey:  each ] ];
		itemText: #name;
		yourself
]

{ #category : #inspecting }
ZtItem >> gtFilesFor: aView [
	<gtView>
	^ self fileDirectory
		ifNil: [ aView empty ]
		ifNotNil: [ :directory |
			aView forward
				title: 'Files';
				priority: 5;
				object: [ directory ];
				view: #gtTreeFor:;
				yourself ]
]

{ #category : #accessing }
ZtItem >> itemType [
	^ (rawData at: #data) at: #itemType
]

{ #category : #accessing }
ZtItem >> library [
	^ library
]

{ #category : #accessing }
ZtItem >> library: aZtLibrary [
	library := aZtLibrary
]

{ #category : #accessing }
ZtItem >> numberOfChildren [
	^ (rawData at: #meta) at: #numChildren ifAbsent: [ 0 ]
]

{ #category : #accessing }
ZtItem >> parentKey [
	^ (rawData at: #data) at: #parentItem ifAbsent: [ nil ]
]

{ #category : #accessing }
ZtItem >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< self key;
		<< ', ';
		<< self itemType;
		<< $)
]

{ #category : #accessing }
ZtItem >> title [
	^ (rawData at: #data) at: #title
]

{ #category : #accessing }
ZtItem >> uniqueFileOrDirectory [
	^ self fileDirectory
		ifNil: [ nil ]
		ifNotNil: [ :directory|
			| files |
			files := directory files reject: [ :each |
				each basename beginsWith: '.' ].
			files size = 1
				ifTrue: [ files first ]
				ifFalse: [ directory ] ]
]
