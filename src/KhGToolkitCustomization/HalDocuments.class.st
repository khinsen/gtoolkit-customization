Class {
	#name : #HalDocuments,
	#superclass : #Object,
	#instVars : [
		'documents'
	],
	#category : #'KhGToolkitCustomization-HAL'
}

{ #category : #'instance creation' }
HalDocuments class >> forHalId: aString [
	^ self new forHalId: aString
]

{ #category : #'instance creation' }
HalDocuments >> forHalId: aString [
	| searchResult data docs |
	searchResult :=
		ZnClient new
			url: ('https://api.archives-ouvertes.fr/search/?q=authIdHal_s:', aString,
				'&fl=docid&fl=doiId_s&fl=uri_s&fl=authFullName_s',
				'&fl=title_s&fl=journalTitle_s&fl=page_s&fl=producedDate_s',
				'&rows=10000');
			contentReader: [ :entity | NeoJSONReader fromString: entity contents ];
			get.
	data := searchResult at: #response.
	documents := (data at: #docs) collect: [ :each |
		HalDocument new
			rawData: each ].
	self assert: (data at: #numFound) equals: documents size.
	documents sort: [ :a :b | a year >= b year ].
]

{ #category : #inspecting }
HalDocuments >> gtListFor: aView [
	<gtView>
	documents isNil ifTrue: [ ^ aView empty ].
	^ aView columnedList
		title: 'Documents';
		priority: 0;
		items: [ documents ];
		column: #Year text: #year width: 50;
		column: #Title text: #title;
		yourself
]

{ #category : #inspecting }
HalDocuments >> gtSpotterForTitlesFor: aStep [
	<gtSearch>
	^ aStep listProcessor
		priority: 1;
		title: 'Titles';
		allCandidates: [ documents ];
		filter: GtFilterSubstring;
		candidatesLimit: 10;
		itemName: #title
]
