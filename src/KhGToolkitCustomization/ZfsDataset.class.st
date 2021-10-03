Class {
	#name : 'ZfsDataset',
	#superclass : 'ZfsEntity',
	#category : 'KhGToolkitCustomization-ZFS'
}

{ #category : 'instance creation' }
ZfsDataset class >> name: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : 'accessing' }
ZfsDataset >> gtSnapshotsFor: aView [
	<gtView>
	^ aView list
		title: 'Snapshots';
		priority: 1;
		items: [ self snapshots ];
		itemText: [ :each | each name ];
		yourself
]

{ #category : 'accessing' }
ZfsDataset >> pool [
	^ ZfsPool name: (#/ split: name) first
]

{ #category : 'accessing' }
ZfsDataset >> snapshots [
	^ (self zfs: { 'list'. '-Hpr'. '-o'. 'name'. '-t'. 'snapshot'. self name } columns: false)
		collect: [ :each | ZfsSnapshot name: each ]
]
