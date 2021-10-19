Class {
	#name : #ZtGroupLibrary,
	#superclass : #ZtLibrary,
	#instVars : [
		'group'
	],
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #'instance creation' }
ZtGroupLibrary class >> group: aZtGroup [
	^ self new
		group: aZtGroup;
		yourself
]

{ #category : #accessing }
ZtGroupLibrary >> group [
	^ group
]

{ #category : #accessing }
ZtGroupLibrary >> group: aZtGroup [
	group := aZtGroup
]

{ #category : #accessing }
ZtGroupLibrary >> urlPrefix [
	^ urlPrefix ifNil: [ urlPrefix := 'groups/', group groupId asString ]
]

{ #category : #accessing }
ZtGroupLibrary >> user [
	^ self group accessingMember
]
