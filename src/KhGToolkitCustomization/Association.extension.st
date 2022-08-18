Extension { #name : #Association }

{ #category : #'*KhGToolkitCustomization' }
Association >> gtAssociationKeyViewLiveFor: aView [
	<gtView>
	^ aView forward
		title: 'Key';
		priority: 2;
		object: [ self key ];
		view: #gtLiveFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect value' 
			action: [ :aButton :aTab | 
				aButton phlow spawnObject: self value ]
]
