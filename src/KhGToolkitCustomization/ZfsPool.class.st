Class {
	#name : 'ZfsPool',
	#superclass : 'ZfsEntity',
	#category : 'KhGToolkitCustomization-ZFS'
}

{ #category : 'instance creation' }
ZfsPool class >> name: aString [
	^ self new
		name: aString;
		yourself
]
