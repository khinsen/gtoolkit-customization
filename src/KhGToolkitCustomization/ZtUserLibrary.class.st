Class {
	#name : #ZtUserLibrary,
	#superclass : #ZtLibrary,
	#instVars : [
		'user'
	],
	#category : #'KhGToolkitCustomization-Zotero'
}

{ #category : #'instance creation' }
ZtUserLibrary class >> user: aZtUser [
	^ self new
		user: aZtUser;
		yourself
]

{ #category : #accessing }
ZtUserLibrary >> urlPrefix [
	^ urlPrefix ifNil: [ urlPrefix := 'users/', user userId asString ]
]

{ #category : #accessing }
ZtUserLibrary >> user [
	^ user
]

{ #category : #accessing }
ZtUserLibrary >> user: aZtUser [
	user := aZtUser
]
