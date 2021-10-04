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
	#category : 'KhGToolkitCustomization-ReScience'
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
		items: [ submissions sorted: [ :a :b | a creationTime >= b creationTime ] ];
		column: 'Days in review'
			text: [ :each | each durationSinceCreation days ]
			width: 100;
		column: 'last comment'
			text: [ :each | each comments
						ifEmpty: [ '' ]
						ifNotEmpty: [ :cs | cs last durationSinceLastUpdate days ] ]
			width: 100;
		column: 'Status'
			text: [ :each | (self statusLabelsFor: each)
						ifEmpty: [ '' ]
						ifNotEmpty: [ :ls | ls last ] ]
			width: 100;
		column: 'Title' text: #title;
		yourself
]

{ #category : #accessing }
ReScienceC >> initialize [
	ghOrganization := GitHubOrganization name: 'rescience'.
	submissions := (ghOrganization repositories at: 'submissions')
					openIssues.
]

{ #category : #accessing }
ReScienceC >> statusLabelsFor: aGitHubIssue [
	^ (aGitHubIssue labels select: [ :each | each beginsWith: '0' ])
		sort: [ :a :b | a second <= b second ]	
]
