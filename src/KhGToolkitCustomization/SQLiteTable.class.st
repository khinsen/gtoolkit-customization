Class {
	#name : #SQLiteTable,
	#superclass : #Object,
	#instVars : [
		'database',
		'properties'
	],
	#category : #'KhGToolkitCustomization-SQLite'
}

{ #category : #'instance creation' }
SQLiteTable class >> properties: aDictionary in: aDatabase [
	^ self new
		database: aDatabase;
		properties: aDictionary
]

{ #category : #accessing }
SQLiteTable >> database [
	^ database
]

{ #category : #accessing }
SQLiteTable >> database: aDatabase [
	database := aDatabase
]

{ #category : #printing }
SQLiteTable >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< (self properties at: #name);
		<< $)
]

{ #category : #accessing }
SQLiteTable >> properties [
	^ properties
]

{ #category : #accessing }
SQLiteTable >> properties: aDictionary [
	properties := aDictionary
]
