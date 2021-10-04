Class {
	#name : #ZfsEntity,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'KhGToolkitCustomization-ZFS'
}

{ #category : #accessing }
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

{ #category : #inspecting }
ZfsEntity >> gtPropertiesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Properties';
		priority: 5;
		items: [ self properties associations
					sorted: [ :a :b | a key <= b key ] ];
		column: 'Name' text: #key;
		column: 'Value' text: [ :each | each value first ];
		column: 'Source' text: [ :each | each value second ];
		send: [ :each | each value first ];
		yourself
]

{ #category : #accessing }
ZfsEntity >> name [
	^ name
]

{ #category : #accessing }
ZfsEntity >> name: aString [
	name := aString
]

{ #category : #accessing }
ZfsEntity >> printOn: aStream [
	super printOn: aStream.
	aStream << $(; << name; << $).
]

{ #category : #accessing }
ZfsEntity >> properties [
	| columns |
	columns := self zfs: { 'get'. '-Hp'. 'all'. self name } columns: true.
	^ (columns collect: [ :each |
		each second -> { each third. each fourth } ])
		asDictionary
]

{ #category : #accessing }
ZfsEntity >> zfs: argArray columns: aBoolean [
	^ self command: self zfsExecutable arguments: argArray columns: aBoolean
]

{ #category : #accessing }
ZfsEntity >> zfsExecutable [
	^ '/usr/sbin/zfs'
]

{ #category : #accessing }
ZfsEntity >> zpool: argArray columns: aBoolean [
	^ self command: self zpoolExecutable arguments: argArray columns: aBoolean
]

{ #category : #accessing }
ZfsEntity >> zpoolExecutable [
	^ '/usr/sbin/zpool'
]
