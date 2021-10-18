Class {
	#name : #ZtApiClient,
	#superclass : #ZnClient,
	#instVars : [
		'ztAccount'
	],
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #accessing }
ZtApiClient >> account: aZtAccount [
	ztAccount := aZtAccount.
	self headerAt: 'Zotero-API-Key' put: ztAccount apiToken.
]

{ #category : #accessing }
ZtApiClient >> initialize [
	super initialize.
	self
		https;
		host: 'api.zotero.org';
		headerAt: 'Zotero-API-Version' put: '3';
		queryAt: 'format' put: 'json';
		contentReader: [ :entity | NeoJSONReader fromString: entity contents ].
]
