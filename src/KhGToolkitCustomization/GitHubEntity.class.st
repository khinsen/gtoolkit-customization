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
GitHubEntity >> isStale [
	^ (timeStamp - DateAndTime now) > 1 hour
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
	^ STON fromString:
		(GitHubAPI new client get: url)
]
