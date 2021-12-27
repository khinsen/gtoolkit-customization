Class {
	#name : #HalDocument,
	#superclass : #Object,
	#instVars : [
		'rawData'
	],
	#category : #'KhGToolkitCustomization-HAL'
}

{ #category : #accessing }
HalDocument >> date [
	| dateString parts |
	dateString := rawData at: #producedDate_s.
	parts := ($- split: dateString).
	parts size = 1 ifTrue: [ ^ Year year: parts first asNumber ].
	parts size = 2 ifTrue: [ ^ Month month: parts second asNumber year:parts first asNumber ].
	^ Date fromString: dateString
]

{ #category : #inspecting }
HalDocument >> gtActionWebBrowseFor: anAction [
	<gtAction>
	|  button url |
	url := self rawData at: #'uri_s'
		ifAbsent: [ ^ anAction noAction ].
	^ anAction explicit stencil: [
		button := BrButton new.
		button
			aptitude: BrGlamorousButtonWithIconAptitude;
			action:  [ WebBrowser openOn:url ];
			icon: BrGlamorousIcons go asElement;
			label: 'Open in browser' translated ].
]

{ #category : #inspecting }
HalDocument >> gtJsonDataFor: aView [
	<gtView>
	^ aView forward
		title: 'JSON Data';
		priority: 10;
		object: [ rawData ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #accessing }
HalDocument >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self title printOn: aStream.
	aStream nextPut: $).
]

{ #category : #accessing }
HalDocument >> rawData [
	^ rawData
]

{ #category : #accessing }
HalDocument >> rawData: aDictionary [
	rawData := aDictionary
]

{ #category : #accessing }
HalDocument >> title [
	^ (self rawData at: #'title_s') first
]

{ #category : #accessing }
HalDocument >> year [
	^ self date year
]
