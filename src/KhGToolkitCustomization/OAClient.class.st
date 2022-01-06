Class {
	#name : #OAClient,
	#superclass : #ZnClient,
	#category : #'KhGToolkitCustomization-OpenAlex'
}

{ #category : #accessing }
OAClient >> author: aString [
	^ OAAuthor new rawData:
		(self
			url: (self oaBaseUrl, 'authors/', aString);
			get)
]

{ #category : #accessing }
OAClient >> concept: aString [
	^ OAConcept new rawData:
		(self
			url: (self oaBaseUrl, 'concepts/', aString);
			get)
]

{ #category : #accessing }
OAClient >> doi: aString [
	^ self work: 'doi:', aString
]

{ #category : #accessing }
OAClient >> initialize [
	super initialize.
	self contentReader: [ :entity |
		NeoJSONReader fromString: entity contents ]
]

{ #category : #accessing }
OAClient >> institution: aString [
	^ OAInstitution new rawData:
		(self
			url: (self oaBaseUrl, 'institutions/', aString);
			get)
]

{ #category : #accessing }
OAClient >> issn: aString [
	^ self venue: 'issn:', aString
]

{ #category : #accessing }
OAClient >> oaBaseUrl [
	^ 'https://api.openalex.org/'
]

{ #category : #accessing }
OAClient >> openAlexId: aString [
	^ self client
		url: (self oaBaseUrl, aString);
		get
]

{ #category : #accessing }
OAClient >> orcid: aString [
	^ self author: 'orcid:', aString
]

{ #category : #accessing }
OAClient >> ror: aString [
	^ self institution: 'ror:', aString
]

{ #category : #accessing }
OAClient >> venue: aString [
	^ OAVenue new rawData:
		(self
			url: (self oaBaseUrl, 'venues/', aString);
			get)
]

{ #category : #accessing }
OAClient >> work: aString [
	^ OAWork new rawData:
		(self
			url: (self oaBaseUrl, 'works/', aString);
			get)
]
