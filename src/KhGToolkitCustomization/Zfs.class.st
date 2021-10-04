Class {
	#name : 'Zfs',
	#superclass : 'Object',
	#category : 'KhGToolkitCustomization-ZFS'
}

{ #category : 'accessing' }
Zfs class >> datasets [
	^ (ZfsEntity new zfs: #( 'list' '-Hpr' '-o' 'name' ) columns: false)
		select: [ :each | each includes: $/ ]
		thenCollect: [ :each | ZfsDataset name: each ]
]

{ #category : 'accessing' }
Zfs class >> pools [
	^ (ZfsEntity new zpool: #( 'list' '-Hp' '-o' 'name' ) columns: false)
		collect: [ :each | ZfsPool name: each ]
]
