Class {
	#name : #ReScienceOrganization,
	#superclass : #GitHubOrganization,
	#instVars : [
		'repositories'
	],
	#category : #'KhGToolkitCustomization-ReScience'
}

{ #category : #accessing }
ReScienceOrganization >> initialize [
	self rawData:
		(STON fromString:
			(ZnClient new get:
				'https://api.github.com/orgs/rescience'))
]

{ #category : #accessing }
ReScienceOrganization >> rawData: aDictionary [
	rawData := aDictionary.
	repositories := Dictionary new.
	(STON fromString:
		(ZnClient new get: (rawData at: 'repos_url')))
		do: [ :each |
			| repo |
			repo := ReScienceRepository new rawData: each.
			repositories at: repo name put: repo ]
]

{ #category : #accessing }
ReScienceOrganization >> repositories [
	^ repositories
]
