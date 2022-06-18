Extension { #name : #BlText }

{ #category : #'*KhGToolkitCustomization' }
BlText >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Items';
		priority: 0;
		items: [ 1 to: self size ];
		column: 'Character' text: [ :each |
			self at:  each ];
		column: 'Attributes' text: [ :each |
			', ' join: 
				((self attributesAt: each) collect: #printString) ];
		send: [ :each |
			self attributesAt: each ];
		yourself
]
