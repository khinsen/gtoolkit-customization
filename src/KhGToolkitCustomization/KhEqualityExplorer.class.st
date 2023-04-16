Class {
	#name : #KhEqualityExplorer,
	#superclass : #Object,
	#instVars : [
		'object2',
		'object1'
	],
	#category : #'KhGToolkitCustomization-Tools'
}

{ #category : #'instance creation' }
KhEqualityExplorer class >> for: object1 and: object2 [
	^ self new
		object1: object1;
		object2: object2;
		yourself
]

{ #category : #comparing }
KhEqualityExplorer >> equalityOf: a and: b [
	a == b ifTrue: [ ^ { #same. a. b } ].
	a = b ifTrue: [ ^ { #equal. a. b } ].
	^ { #notEqual. a. b }
]

{ #category : #inspecting }
KhEqualityExplorer >> equalityReport [
	| slots1 slots2 commonSlots report |
	slots1 := object1 class allInstVarNames sorted.
	slots2 := object2 class allInstVarNames sorted.
	commonSlots := (slots1 intersection: slots2) sorted.
	report := OrderedCollection
		with: #object -> (self equalityOf: object1 and: object2)
		with: #class -> (self equalityOf: object1 class and: object2 class)
		with: #slotNames -> (self equalityOf: slots1 and: slots2).
	(object1 class isVariable and: [ object2 class isVariable ])
		ifTrue: [ report add: #basicSize -> (self equalityOf: object1 basicSize and: object2 basicSize) ].
	(object1 khExploreEqualityWith: object2) do: [ :each |
		report add: each first -> (self equalityOf: each second and: each third) ].
	 ^ report
]

{ #category : #inspecting }
KhEqualityExplorer >> gtReportFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Report';
		priority: 0;
		items: [ self equalityReport ];
		column: 'Item' text: [ :each | each key ];
		column: 'Status' text: [ :each | each value first ];
		column: 'Value1' text: [ :each | each value second printString ];
		column: 'Value2' text: [ :each |
			each value first = #notEqual
				ifTrue: [ each value third printString ]
				ifFalse: [ '' ] ];
		send: [ :each | self class for: each value second and: each value third ];
		yourself.
]

{ #category : #accessing }
KhEqualityExplorer >> object1: anObject [
	object1 := anObject
]

{ #category : #accessing }
KhEqualityExplorer >> object2: anObject [
	object2 := anObject
]
