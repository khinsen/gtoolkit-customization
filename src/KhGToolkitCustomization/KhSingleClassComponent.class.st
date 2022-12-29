Class {
	#name : #KhSingleClassComponent,
	#superclass : #KhComponent,
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
	| class |
	class := self subcomponents anyOne.
	externalMethodsWithSenders := IdentityDictionary new.
	methodClassification := class methods groupedBy: [ :eachMethod |
		(self sendersOf: eachMethod selector in: aSetOfClasses)
			ifEmpty: [ #unused ]
			ifNotEmpty: [ :senders |
				(senders = (Set with: class))
					ifTrue: [ #internal ]
					ifFalse: [
						externalMethodsWithSenders at: eachMethod put: senders.
						#external ] ] ]
]

{ #category : #operating }
KhSingleClassComponent >> sendersOf: selector in: aSetOfClasses [
	^ (aSetOfClasses flatCollect: [ :aClass |
		aClass methods select: [ :method |
			(method sendNodes collect: #selector)
				includes: selector ] ]) asSet
					collect: #methodClass.
]
