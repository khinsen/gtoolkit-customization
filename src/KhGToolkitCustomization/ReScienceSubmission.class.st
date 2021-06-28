Class {
	#name : #ReScienceSubmission,
	#superclass : #Object,
	#instVars : [
		'ghIssue'
	],
	#category : #'KhGToolkitCustomization-ReScience'
}

{ #category : #accessing }
ReScienceSubmission >> doesNotUnderstand: aMessage [
	^ aMessage sendTo: ghIssue
]

{ #category : #accessing }
ReScienceSubmission >> ghIssue [
	^ ghIssue
]

{ #category : #accessing }
ReScienceSubmission >> ghIssue: aGhIssue [
	ghIssue := aGhIssue
]

{ #category : #accessing }
ReScienceSubmission >> statusLabels [
	^ (ghIssue labels select: [ :each | each beginsWith: '0' ])
		sort: [ :a :b | a second <= b second ]	
]
