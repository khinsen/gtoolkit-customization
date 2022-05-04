Class {
	#name : #SQLiteDatabase,
	#superclass : #Object,
	#instVars : [
		'file',
		'connection'
	],
	#category : #'KhGToolkitCustomization-SQLite'
}

{ #category : #'instance creation' }
SQLiteDatabase class >> file: aFileReference [
	^ self new
		file: aFileReference
]

{ #category : #accessing }
SQLiteDatabase >> file [
	^ file
]

{ #category : #accessing }
SQLiteDatabase >> file: aFileReference [ 
	file := aFileReference
]

{ #category : #initializing }
SQLiteDatabase >> initialize [
	file := nil.
	connection := nil
]

{ #category : #printing }
SQLiteDatabase >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< self file fullName;
		<< $)
]

{ #category : #operating }
SQLiteDatabase >> runSQL: aString with: aBlock [
	| result |
	connection := SQLite3Connection on: self file fullName.
	connection open.
	result := nil.
	[
		result := aBlock value: (connection execute: aString).
	] onErrorDo: [ :error | connection close. error signal ].
	connection close.
	connection := nil.
	^ result
]

{ #category : #accessing }
SQLiteDatabase >> tables [
	^ self
		runSQL: '
			SELECT *
			FROM sqlite_master
			WHERE
			    type =''table'' AND 
    			name NOT LIKE ''sqlite_%'';'
		with: [ :result |
					result rows collect: [ :eachRow |
    					| properties |
    					properties :=  (eachRow columnNames collect: [ :eachCName |
    						eachCName -> (eachRow atName: eachCName) ])
    						asDictionary.
    					SQLiteTable properties: properties in: self ] ]
]
