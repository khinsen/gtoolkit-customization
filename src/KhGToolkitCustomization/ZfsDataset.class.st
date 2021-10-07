Class {
	#name : #ZfsDataset,
	#superclass : #ZfsEntity,
	#category : #'KhGToolkitCustomization-ZFS'
}

{ #category : #'instance creation' }
ZfsDataset class >> name: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : #accessing }
ZfsDataset >> pool [
	^ ZfsPool name: (#/ split: name) first
]
