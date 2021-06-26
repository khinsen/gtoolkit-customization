Class {
	#name : #ReScienceOrganization,
	#superclass : #GitHubOrganization,
	#instVars : [
		'repositories'
	],
	#category : #'KhGToolkitCustomization-ReScience'
}

{ #category : #'instance creation' }
ReScienceOrganization class >> isResponsibleFor: aString [
	^ aString asLowercase = 'rescience'
]

{ #category : #accessing }
ReScienceOrganization >> gtInReviewFor: aView [
	<gtView>
	| issues |
	issues := (repositories at: 'submissions')
		openIssues
		sorted: [ :a :b | a changeTime >= b changeTime ].
	issues ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'In Review';
		priority: 3;
		items: [ issues ];
		column: 'Days in review'
			text: [ :each | each durationSinceCreation days ];
		column: 'since last update'
			text: [ :each | each durationSinceLastUpdate days ];
		column: 'Title' text: #title;
		yourself
]

{ #category : #accessing }
ReScienceOrganization >> initializeFromRawData [
	super initializeFromRawData.
]

{ #category : #accessing }
ReScienceOrganization >> repositories [
	^ repositories
]
