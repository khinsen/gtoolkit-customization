Class {
	#name : #ReScienceC,
	#superclass : #Object,
	#instVars : [
		'ghOrganization',
		'submissions'
	],
	#classInstVars : [
		'ghOrganization'
	],
	#category : #'KhGToolkitCustomization-ReScience'
}

{ #category : #accessing }
ReScienceC >> ghOrganization [
	^ ghOrganization
]

{ #category : #accessing }
ReScienceC >> gtInReviewFor: aView [
	<gtView>
	submissions ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'In Review';
		priority: 3;
		items: [ submissions sorted: [ :a :b | a changeTime >= b changeTime ] ];
		column: 'Days in review'
			text: [ :each | each durationSinceCreation days ];
		column: 'since last update'
			text: [ :each | each durationSinceLastUpdate days ];
		column: 'Status' text: [ :each | each statusLabels last ];
		column: 'Title' text: #title;
		send: #ghIssue;
		yourself
]

{ #category : #accessing }
ReScienceC >> initialize [
	ghOrganization := GitHubOrganization name: 'rescience'.
	submissions := (ghOrganization repositories at: 'submissions')
					openIssues
					collect: [ :each | ReScienceSubmission new ghIssue: each ].
]
