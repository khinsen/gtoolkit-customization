Class {
	#name : #SLPathFromNode,
	#superclass : #Object,
	#instVars : [
		'node',
		'path'
	],
	#category : #'KhGToolkitCustomization-Seamless'
}

{ #category : #accessing }
SLPathFromNode >> node [
	^ node
]

{ #category : #accessing }
SLPathFromNode >> node: anObject [
	node := anObject
]

{ #category : #accessing }
SLPathFromNode >> path [
	^ path
]

{ #category : #accessing }
SLPathFromNode >> path: anObject [
	path := anObject
]

{ #category : #printing }
SLPathFromNode >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< ('/' join: path);
		<< ', ';
		<< node asString;
		<< $)
]

{ #category : #accessing }
SLPathFromNode >> resolve [
	| oneStep |
	oneStep := self node itemAt: path first
		ifAbsent: [ ^ self ].
	^ path size > 1 ifTrue: [
		(SLPathFromNode new
			node: oneStep;
			path: path allButFirst)
			resolve ]
		ifFalse: [ oneStep ]
]
