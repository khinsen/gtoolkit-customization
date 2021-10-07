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
ZfsDataset >> files [
	((self properties at: #mounted) first = #yes) ifFalse: [ ^ nil ].
	^ (self properties at: #mountpoint) first asFileReference
]

{ #category : #accessing }
ZfsDataset >> pool [
	^ ZfsPool name: (#/ split: name) first
]
