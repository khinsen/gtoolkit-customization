Class {
	#name : 'ZfsPool',
	#superclass : 'ZfsEntity',
	#category : 'KhGToolkitCustomization-ZFS'
}

{ #category : 'instance creation' }
ZfsPool class >> name: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : 'accessing' }
ZfsPool >> datasets [
	^ (self zfs: { 'list'. '-Hpr'. '-o'. 'name'. self name } columns: false)
		select: [ :each | each includes: $/ ]
		thenCollect: [ :each | ZfsDataset name: each ]
]

{ #category : 'inspecting' }
ZfsPool >> gtDatasetsFor: aView [
	<gtView>
	^ aView list
		title: 'Datasets';
		priority: 1;
		items: [ self datasets ];
		itemText: [ :each | each name ];
		yourself
]

{ #category : 'accessing' }
ZfsPool >> gtSnapshotsFor: aView [
	<gtView>
	^ aView list
		title: 'Snapshots';
		priority: 2;
		items: [ self snapshots ];
		itemText: [ :each | each name ];
		yourself
]

{ #category : 'accessing' }
ZfsPool >> snapshots [
	^ (self zfs: { 'list'. '-Hpr'. '-o'. 'name'. '-t'. 'snapshot'. self name } columns: false)
		collect: [ :each | ZfsSnapshot name: each ]
]
