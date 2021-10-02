Class {
	#name : 'ZfsPool',
	#superclass : 'ZfsEntity',
	#instVars : [
		'name'
	],
	#category : 'KhGToolkitCustomization-ZFS'
}

{ #category : 'instance creation' }
ZfsPool class >> name: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : 'accessing' }
ZfsPool >> name [
	^ name
]

{ #category : 'accessing' }
ZfsPool >> name: aString [
	name := aString
]

{ #category : 'accessing' }
ZfsPool >> printOn: aStream [
	super printOn: aStream.
	aStream << $(; << name; << $).
]
