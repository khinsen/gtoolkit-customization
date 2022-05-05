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

{ #category : #accessing }
SQLiteTable >> gtSchemaFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema';
		priority: 1;
		object: [ self schema ];
		view: #gtStringFor:;
		yourself
]

{ #category : #accessing }
SQLiteTable >> name [
	^ self properties at: #name
]

{ #category : #accessing }
SQLiteTable >> numberOfRows [
	^ self database
		runSQL: 'SELECT COUNT(*) FROM ', self name , ';'
		with: [ :each | each next at: 1 ]
]

{ #category : #printing }
SQLiteTable >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< (self properties at: #name);
		<< ', ';
		<< self numberOfRows asString;
		<< ' rows)'
]

{ #category : #accessing }
SQLiteTable >> properties [
	^ properties
]

{ #category : #accessing }
SQLiteTable >> properties: aDictionary [
	properties := aDictionary
]

{ #category : #accessing }
SQLiteTable >> schema [
	^ self properties at: #sql
]
