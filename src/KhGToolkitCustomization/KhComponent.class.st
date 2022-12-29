Class {
	#name : #KhComponent,
	#superclass : #Object,
	#instVars : [
		'packages',
		'name',
		'subcomponents',
		'methodClassification',
		'externalMethodsWithSenders',
		'classes'
	],
	#category : #'KhGToolkitCustomization-ClassClusters'
}

{ #category : #adding }
KhComponent >> add: aClassOrCluster [
	aClassOrCluster isBehavior
		ifTrue: [ self add: (KhSingleClassComponent new
								add: aClassOrCluster) ]
		ifFalse: [
			self assert: (aClassOrCluster isKindOf: KhComponent).
			subcomponents add: aClassOrCluster.
			classes addAll: aClassOrCluster classes.
			packages addAll: aClassOrCluster packages ]
]

{ #category : #adding }
KhComponent >> addWithSubclasses: aClass [
	aClass withAllSubclassesDo: [ :each | self add: each ]
]

{ #category : #accessing }
KhComponent >> children [
	^ self subcomponents asArray
]

{ #category : #accessing }
KhComponent >> classes [
	^ classes
]

{ #category : #operating }
KhComponent >> classifyMethods [
	^ self classifyMethodsIn: (self packages flatCollect: #definedClasses) asSet
]

{ #category : #operating }
KhComponent >> classifyMethodsIn: aSetOfClasses [
	| subcomponentMethodsWithSenders |

	self subcomponents do: [ :each | each classifyMethodsIn: aSetOfClasses ].
	subcomponentMethodsWithSenders := IdentityDictionary new.
	self subcomponents do: [ :each |
		subcomponentMethodsWithSenders addAll: each externalMethodsWithSenders ].

	externalMethodsWithSenders := IdentityDictionary new.
	methodClassification := subcomponentMethodsWithSenders keys groupedBy: [ :eachMethod |
		(subcomponentMethodsWithSenders at: eachMethod)
			ifEmpty: [ #unused ] "shouldn't happen..."
			ifNotEmpty: [ :senders |
				(senders difference: self classes)
					ifEmpty: [ #internal ]
					ifNotEmpty: [
						externalMethodsWithSenders at: eachMethod put: senders.
						#external ] ] ]
]

{ #category : #operating }
KhComponent >> externalMethods [
	methodClassification ifNil: [ self classifyMethods ].
	^ (methodClassification at: #external ifAbsent: [ #() ])
		sorted: [ :a :b | a methodClass name <= b methodClass name ]
]

{ #category : #accessing }
KhComponent >> externalMethodsWithSenders [
	externalMethodsWithSenders ifNil: [ self classifyMethods ].
	^ externalMethodsWithSenders
]

{ #category : #inspecting }
KhComponent >> gtClassesFor: aView [
	<gtView>
	^ aView list
		title: 'Classes';
		priority: 7;
		items: [ self classes asArray ];
		yourself
]

{ #category : #inspecting }
KhComponent >> gtExternalMethodsFor: aView [
	<gtView>
	^ aView list
		title: 'External methods';
		priority: 1;
		items: [ self externalMethods ];
		yourself
]

{ #category : #inspecting }
KhComponent >> gtInternalMethodsFor: aView [
	<gtView>
	^ aView list
		title: 'Internal methods';
		priority: 2;
		items: [ self internalMethods ];
		yourself
]

{ #category : #inspecting }
KhComponent >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Tree' translated;
		priority: 0;
		items: [ { self } ];
		column: 'Cluster' text: #name;
		column: 'External methods' text: [ :each |
			each externalMethodsWithSenders size ];
		children: #children;
		yourself
]

{ #category : #inspecting }
KhComponent >> gtUnusedMethodsFor: aView [
	<gtView>
	^ aView list
		title: 'Unused methods';
		priority: 3;
		items: [ self unusedMethods ];
		yourself
]

{ #category : #initializing }
KhComponent >> initialize [
	subcomponents := Set new.
	classes := Set new.
	packages := Set new.
]

{ #category : #operating }
KhComponent >> internalMethods [
	methodClassification ifNil: [ self classifyMethods ].
	^ (methodClassification at: #internal ifAbsent: [ #() ])
		sorted: [ :a :b | a methodClass name <= b methodClass name ]
]

{ #category : #accessing }
KhComponent >> name [
	^ name
]

{ #category : #accessing }
KhComponent >> name: anObject [
	name := anObject
]

{ #category : #accessing }
KhComponent >> packages [
	^ packages
]

{ #category : #accessing }
KhComponent >> subcomponents [
	^ subcomponents
]

{ #category : #operating }
KhComponent >> unusedMethods [
	methodClassification ifNil: [ self classifyMethods ].
	^ (methodClassification at: #unused ifAbsent: [ #() ])
		sorted: [ :a :b | a methodClass name <= b methodClass name ]
]
