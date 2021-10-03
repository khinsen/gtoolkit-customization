Class {
	#name : 'ZfsEntity',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'KhGToolkitCustomization-ZFS'
}

{ #category : 'accessing' }
ZfsEntity >> command: aString arguments: argArray columns: aBoolean [
	| proc lines |
	proc := GtUnixSubprocess command: aString arguments: argArray.
	proc errorBlock: [ :aProcess | self error: aString, ' failed' ].
	proc runAndWait.
	lines := (Character lf split: proc stdout)
				select: [ :each | each isEmpty not ].
	aBoolean ifFalse: [ ^ lines ].
	^ lines collect: [ :each | Character tab split: each ]
]

{ #category : 'accessing' }
ZfsEntity >> gtSnapshotsFor: aView [
	<gtView>
	^ aView list
		title: 'Snapshots';
		priority: 1;
		items: [ self snapshots ];
		itemText: [ :each | each name ];
		yourself
]

{ #category : 'accessing' }
ZfsEntity >> name [
	^ name
]

{ #category : 'accessing' }
ZfsEntity >> name: aString [
	name := aString
]

{ #category : 'accessing' }
ZfsEntity >> printOn: aStream [
	super printOn: aStream.
	aStream << $(; << name; << $).
]

{ #category : 'accessing' }
ZfsEntity >> zfs: argArray columns: aBoolean [
	^ self command: self zfsExecutable arguments: argArray columns: aBoolean
]

{ #category : 'accessing' }
ZfsEntity >> zfsExecutable [
	^ '/usr/sbin/zfs'
]

{ #category : 'accessing' }
ZfsEntity >> zpool: argArray columns: aBoolean [
	^ self command: self zpoolExecutable arguments: argArray columns: aBoolean
]

{ #category : 'accessing' }
ZfsEntity >> zpoolExecutable [
	^ '/usr/sbin/zpool'
]
