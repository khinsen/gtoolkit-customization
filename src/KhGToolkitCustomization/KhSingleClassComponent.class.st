Class {
	#name : #KhSingleClassComponent,
	#superclass : #KhComponent,
	#instVars : [
		'ignoredMethods'
	],
	#category : #'KhGToolkitCustomization-ClassClusters'
}

{ #category : #adding }
KhSingleClassComponent >> add: aClass [
	self assert: aClass isBehavior.
	self assert: subcomponents isEmpty.
	subcomponents add: aClass.
	classes add: aClass.
	packages add: aClass package.
	self name: aClass name.
]

{ #category : #accessing }
KhSingleClassComponent >> children [
	^ #()
]

{ #category : #operating }
KhSingleClassComponent >> classifyMethods [
	^ self classifyMethodsIn: self packages anyOne definedClasses
]

{ #category : #operating }
KhSingleClassComponent >> classifyMethodsIn: aSetOfClasses [
	| class methods |
	class := self subcomponents anyOne.
	externalMethodsWithSenders := IdentityDictionary new.
	methods := class methods reject: [ :each |
		ignoredMethods includes: each selector ].
	methodClassification := methods groupedBy: [ :eachMethod |
		(self sendersOf: eachMethod selector in: aSetOfClasses)
			ifEmpty: [ #unused ]
			ifNotEmpty: [ :senders |
				(senders = (Set with: class))
					ifTrue: [ #internal ]
					ifFalse: [
						externalMethodsWithSenders at: eachMethod put: senders.
						#external ] ] ]
]

{ #category : #adding }
KhSingleClassComponent >> ignoreTraits: aSequence [
	aSequence do: [ :each |
		ignoredMethods addAll: (each methods collect: #selector) ]
]

{ #category : #initializing }
KhSingleClassComponent >> initialize [
	super initialize.
	ignoredMethods := Set new.
]

{ #category : #operating }
KhSingleClassComponent >> sendersOf: selector in: aSetOfClasses [
	^ (aSetOfClasses flatCollect: [ :aClass |
		aClass methods select: [ :method |
			(method sendNodes collect: #selector)
				includes: selector ] ]) asSet
					collect: #methodClass.
]
