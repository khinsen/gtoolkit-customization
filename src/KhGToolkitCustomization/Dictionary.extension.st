Extension { #name : 'Dictionary' }

{ #category : '*KhGToolkitCustomization' }
Dictionary >> khExploreEqualityWith: anObject [
	| report commonKeys |
	anObject isDictionary ifFalse: [ ^ super khExploreEqualityWith: anObject ].
	commonKeys := self keys intersection: anObject keys.
	report := OrderedCollection new.
	report add: { #keys. self keys. anObject keys }.
	commonKeys do: [ :each |
		report add: {
			'key "', each printString, '"'.
			self at: each.
			anObject at: each } ].
	^ report
]
