Class {
	#name : #ZtItem,
	#superclass : #ZtEntity,
	#instVars : [
		'storage'
	],
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #accessing }
ZtItem >> fileDirectory [
	| directory |
	self storage ifNil: [ ^ nil ].
	directory := self storage directoryForKey: self key.
	directory exists ifFalse: [ ^ nil ].
	^ directory
]

{ #category : #inspecting }
ZtItem >> gtActionWebBrowseFor: anAction [
	<gtAction>
	|  button |
	^ self uniqueFileOrDirectory
		ifNil: [ anAction noAction ]
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
ZtItem >> storage [
	^ storage
]

{ #category : #accessing }
ZtItem >> storage: aZtStorage [
	storage := aZtStorage
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
