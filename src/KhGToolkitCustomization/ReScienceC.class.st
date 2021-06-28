Class {
	#name : #ReScienceC,
	#superclass : #Object,
	#instVars : [
		'ghOrganization'
	],
	#classInstVars : [
		'ghOrganization'
	],
	#category : #'KhGToolkitCustomization-ReScience'
}

{ #category : #accessing }
ReScienceC >> ghOrganization [
	^ ghOrganization ifNil: [ ghOrganization := GitHubOrganization name: 'rescience' ]
]

{ #category : #accessing }
ReScienceC >> gtInReviewFor: aView [
	<gtView>
	| issues |
	issues := (self ghOrganization repositories at: 'submissions')
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
