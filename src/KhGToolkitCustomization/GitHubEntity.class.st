Class {
	#name : #GitHubEntity,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'timeStamp'
	],
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #accessing }
GitHubEntity >> changeTime [
	^ (rawData at: 'updated_at') asDateAndTime
]

{ #category : #accessing }
GitHubEntity >> creationTime [
	^ (rawData at: 'created_at') asDateAndTime
]

{ #category : #accessing }
GitHubEntity >> durationSinceCreation [
	^ DateAndTime now - self creationTime
]

{ #category : #accessing }
GitHubEntity >> durationSinceLastUpdate [
	^ DateAndTime now - self changeTime
]

{ #category : #inspecting }
GitHubEntity >> gtActionWebBrowseFor: anAction [
	<gtAction>
	| url |
	url := rawData at: 'html_url' ifAbsent: [ ^ anAction noAction ].
	^ anAction explicit
		stencil: [
			BrButton new
				aptitude: BrGlamorousButtonWithIconAptitude;
				action:  [ WebBrowser openOn: url ];
				icon: BrGlamorousIcons go asElement;
				label: 'Open in Web browser' translated ]
]

{ #category : #inspecting }
GitHubEntity >> gtDataFor: aView [
	<gtView>
	^ aView forward
		title: 'Data';
		priority: 10;
		object: [ rawData ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #initializing }
GitHubEntity >> initializeFromRawData [
]

{ #category : #testing }
GitHubEntity >> isInitialized [
	^ rawData isNotNil
]

{ #category : #testing }
GitHubEntity >> isStale [
	^ (timeStamp - DateAndTime now) > 1 hour
]

{ #category : #operating }
GitHubEntity >> paginatedRawDataFromUrl: aString [
	| url curlyBrace client data links |
	url := aString copyUpTo: ${.
	data := Array new.
	[
		client := GitHubAPI new jsonClient.
		data := data, (client get: url).
		links := client response headers at: #Link ifAbsent: [ nil ].
		links ifNil: [ false ] ifNotNil: [
			(self parseLinks: links) at: #next
				ifPresent: [ :next | url := next. true ]
				ifAbsent: [ false ] ]
	] whileTrue.
	^ data
]

{ #category : #operating }
GitHubEntity >> parseLinks: aString [
	^ (($, split: aString) collect: [ :each |
		| parts url rel |
		parts := $; split: each.
		url := (parts first trimBoth findTokens: '<>') first.
		rel := (parts second trimBoth findTokens: '"') second.
		rel -> url ]) asDictionary
]

{ #category : #initializing }
GitHubEntity >> rawData: aDictionary [
	rawData := aDictionary.
	timeStamp := DateAndTime now.
	self initializeFromRawData
]

{ #category : #operating }
GitHubEntity >> rawDataFromUrl: aString [
	| url curlyBrace |
	url := aString copyUpTo: ${.
	^ GitHubAPI new jsonClient get: url.
]
