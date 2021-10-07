Class {
	#name : #ZfsSnapshot,
	#superclass : #ZfsEntity,
	#category : #'KhGToolkitCustomization-ZFS'
}

{ #category : #accessing }
ZfsSnapshot class >> name: aString [
	^ self new
		name: aString;
		yourself 
]

{ #category : #accessing }
ZfsSnapshot >> datasetOrPool [
	| datasetOrPoolName |
	datasetOrPoolName := ($@ split: name) first.
	(datasetOrPoolName includes: $/)
		ifTrue: [ ^ ZfsDataset name: datasetOrPoolName ]
		ifFalse: [ ^ ZfsPool name: datasetOrPoolName ]
]

{ #category : #accessing }
ZfsSnapshot >> snapname [
	^ ($@ split: name) second
]

{ #category : #accessing }
ZfsSnapshot >> snapshots [
	^ #()
]
