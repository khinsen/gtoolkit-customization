Class {
	#name : 'GitHubRepository',
	#superclass : 'GitHubEntity',
	#instVars : [
		'name'
	],
	#category : 'KhGToolkitCustomization-GitHub'
}

{ #category : 'accessing' }
GitHubRepository >> fullName [
	^ rawData at: 'full_name'
]

{ #category : 'inspecting' }
GitHubRepository >> gtOpenIssuesFor: aView [
	<gtView>
	| issues |
	issues := self openIssues.
	issues ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Open Issues';
		priority: 3;
		items: [ issues ];
		yourself
]

{ #category : 'accessing' }
GitHubRepository >> labels [
	^ (rawData at: 'labels')
		collect: [ :each | each at: 'name' ]
]

{ #category : 'accessing' }
GitHubRepository >> name [
	^ ($/ split: self fullName) second
]

{ #category : 'accessing' }
GitHubRepository >> numberOfOpenIssues [
	^ rawData at: 'open_issues'
]

{ #category : 'accessing' }
GitHubRepository >> openIssues [
	^ (self rawDataFromUrl: (rawData at: 'issues_url'))
		collect: [ :each |
			GitHubIssue new
				repository: self;
				rawData: each ]
]

{ #category : 'printing' }
GitHubRepository >> printOn: aStream [
	super printOn: aStream.
	aStream << '('; << self fullName; << ')'.
]
