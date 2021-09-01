Extension { #name : 'Object' }

{ #category : '*KhGToolkitCustomization' }
Object >> khExploreEqualityWith: anObject [
	| report commonSlots slots1 slots2 |
	slots1 := self class allInstVarNames sorted.
	slots2 := anObject class allInstVarNames sorted.
	commonSlots := (slots1 intersection: slots2) sorted.
	report := OrderedCollection new.
	commonSlots do: [ :each |
		report add: {
			'slot "', each, '"'.
			self instVarNamed: each.
			anObject instVarNamed: each } ].
	1 to: (self basicSize min: anObject basicSize) do: [ :each |
		report add: {
			'element ', each asString.
			self basicAt: each.
			anObject basicAt: each } ].
	^ report
]
