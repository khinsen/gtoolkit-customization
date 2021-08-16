Class {
	#name : 'GitHubIssue',
	#superclass : 'GitHubEntity',
	#instVars : [
		'repository'
	],
	#category : 'KhGToolkitCustomization-GitHub'
}

{ #category : 'accessing' }
GitHubIssue >> comments [
	^ (self rawDataFromUrl: (rawData at: 'comments_url'))
		collect: [ :each | GitHubIssueComment new rawData: each ]
]

{ #category : 'inspecting' }
GitHubIssue >> gtCommentsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Comments';
		priority: 1;
		items: [ self comments ];
		column: 'User'
			text: #user
			width: 100;
		column: 'Date'
			text: [ :each | each creationTime asDate asString ]
			width: 100;
		column: 'Body' text: #body;
		yourself
]

{ #category : 'accessing' }
GitHubIssue >> gtLabelsFor: aView [
	<gtView>
	^ aView list
		title: 'Labels';
		priority: 2;
		items: [ self labels sort ];
		yourself
]

{ #category : 'accessing' }
GitHubIssue >> labels [
	^ (rawData at: 'labels')
		collect: [ :each | each at: 'name' ]
]

{ #category : 'accessing' }
GitHubIssue >> number [
	^ rawData at: 'number'
]

{ #category : 'printing' }
GitHubIssue >> printOn: aStream [
	super printOn: aStream.
	aStream << $(; << self repository fullName; << $#; << self number asString; << $)
]

{ #category : 'accessing' }
GitHubIssue >> repository [
	^ repository
]

{ #category : 'accessing' }
GitHubIssue >> repository: aGhRepository [
	repository := aGhRepository
]

{ #category : 'accessing' }
GitHubIssue >> title [
	^ rawData at: 'title'
]
