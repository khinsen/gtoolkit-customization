Class {
	#name : 'ZFS',
	#superclass : 'Object',
	#category : 'KhGToolkitCustomization-ZFS'
}

{ #category : 'accessing' }
ZFS class >> datasets [
	^ (ZfsEntity new zfs: #( 'list' '-Hpr' '-o' 'name' ) columns: false)
		select: [ :each | each includes: $/ ]
		thenCollect: [ :each | ZfsDataset name: each ]
]

{ #category : 'accessing' }
ZFS class >> pools [
	^ (ZfsEntity new zpool: #( 'list' '-Hp' '-o' 'name' ) columns: false)
		collect: [ :each | ZfsPool name: each ]
]
