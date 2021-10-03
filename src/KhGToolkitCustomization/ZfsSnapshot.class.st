Class {
	#name : 'ZfsSnapshot',
	#superclass : 'ZfsEntity',
	#category : 'KhGToolkitCustomization-ZFS'
}

{ #category : 'accessing' }
ZfsSnapshot class >> name: aString [
	^ self new
		name: aString;
		yourself 
]
