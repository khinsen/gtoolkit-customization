Class {
	#name : #GitHubIssue,
	#superclass : #GitHubEntity,
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #accessing }
GitHubIssue >> comments [
	^ (self rawDataFromUrl: (rawData at: 'comments_url'))
		collect: [ :each | GitHubIssueComment new rawData: each ]
]

{ #category : #inspecting }
GitHubIssue >> gtCommentsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Comments';
		priority: 1;
		items: [ self comments ];
		column: 'Author' text: #user;
		column: 'Date' text: [ :each | each creationTime asDate asString ];
		column: 'Body' text: #body;
"			itemStencil: [ BrLabel new hMatchParent aptitude: BrGlamorousLabelAptitude ];
			itemDataBinder: [ :anItemElement :anItem | anItemElement text: anItem body ];
""		itemStencil: [ LeTextSnippet new asPreviewElement ];
		itemDataBinder: [ :anItemElement :anItem |
			anItemElement snippetViewModel snippetModel string: anItem body ];"
		yourself
]

{ #category : #printing }
GitHubIssue >> gtDisplayOn: aStream [
	aStream << self title
]

{ #category : #printing }
GitHubIssue >> printOn: aStream [
	super printOn: aStream.
	aStream << $(; << self title; << $)
]

{ #category : #accessing }
GitHubIssue >> title [
	^ rawData at: 'title'
]
