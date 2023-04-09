Class {
	#name : #ZfsPool,
	#superclass : #ZfsEntity,
	#category : #'KhGToolkitCustomization-ZFS'
}

{ #category : #'instance creation' }
ZfsPool class >> name: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : #accessing }
ZfsPool >> datasets [
	^ (self zfs: { 'list'. '-Hpr'. '-o'. 'name'. self name } columns: false)
		select: [ :each | each includes: $/ ]
		thenCollect: [ :each | ZfsDataset name: each ]
]

{ #category : #inspecting }
ZfsPool >> gtDatasetsFor: aView [
	<gtView>
	^ aView list
		title: 'Datasets';
		priority: 3;
		items: [ self datasets ];
		itemText: [ :each | each name ];
		yourself
]
