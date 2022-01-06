Class {
	#name : #OpenAlex,
	#superclass : #Object,
	#category : #'KhGToolkitCustomization-OpenAlex'
}

{ #category : #accessing }
OpenAlex >> baseUrl [
	^ 'https://api.openalex.org/'
]

{ #category : #accessing }
OpenAlex >> client [
	^ ZnClient new
		contentReader: [ :entity |
			NeoJSONReader fromString: entity contents ].
]

{ #category : #accessing }
OpenAlex >> orcid: aString [
	^ self client
		url: (self baseUrl, 'authors/https://orcid.org/', aString);
		get
]
