Class {
	#name : #SwhAPI,
	#superclass : #Object,
	#category : #'KhGToolkitCustomization-SoftwareHeritage'
}

{ #category : #accessing }
SwhAPI class >> baseUrl [
	^ 'https://archive.softwareheritage.org' asUrl
]

{ #category : #accessing }
SwhAPI >> client [
	^ ZnClient new
]

{ #category : #accessing }
SwhAPI >> jsonClient [
	| client |
	client := self client.
	client contentReader: [ :entity | NeoJSONReader fromString: entity contents ].
	^ client
]

{ #category : #accessing }
SwhAPI >> raw: aSWHID [
	^ self client
		url: (SwhAPI baseUrl / '/api/1/raw' / aSWHID);
		get.
]

{ #category : #accessing }
SwhAPI >> resolve: aSWHID [
	^ self jsonClient
		url: (SwhAPI baseUrl / '/api/1/resolve' / aSWHID);
		get.
]
