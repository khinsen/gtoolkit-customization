Extension { #name : #SequenceableCollection }

{ #category : #'*KhGToolkitCustomization' }
SequenceableCollection >> khExploreEqualityWith: anObject [
	| report |
	anObject isSequenceable ifFalse: [ ^ super khExploreEqualityWith: anObject ].
	report := OrderedCollection new.
	report add: { #size. self size. anObject size }.
	1 to: (self size min: anObject size) do: [ :each |
		report add: {
			'element ', each asString.
			self at: each.
			anObject at: each } ].
	^ report
]
