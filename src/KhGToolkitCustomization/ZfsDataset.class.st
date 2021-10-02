Class {
	#name : 'ZfsDataset',
	#superclass : 'ZfsEntity',
	#instVars : [
		'name'
	],
	#category : 'KhGToolkitCustomization-ZFS'
}

{ #category : 'instance creation' }
ZfsDataset class >> name: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : 'accessing' }
ZfsDataset >> name [
	^ name
]

{ #category : 'accessing' }
ZfsDataset >> name: aString [
	name := aString
]

{ #category : 'accessing' }
ZfsDataset >> pool [
	^ ZfsPool name: (#/ split: name) first
]

{ #category : 'accessing' }
ZfsDataset >> printOn: aStream [
	super printOn: aStream.
	aStream << $(; << name; << $).
]
