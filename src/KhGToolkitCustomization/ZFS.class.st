Class {
	#name : 'ZFS',
	#superclass : 'ZfsEntity',
	#category : 'KhGToolkitCustomization-ZFS'
}

{ #category : 'accessing' }
ZFS class >> datasets [
	^ (self new zfs: #( 'list' '-Hpr' '-o' 'name' ) columns: false)
		select: [ :each | each includes: $/ ]
		thenCollect: [ :each | ZfsDataset name: each ]
]

{ #category : 'accessing' }
ZFS class >> pools [
	^ (self new zpool: #( 'list' '-Hp' '-o' 'name' ) columns: false)
		collect: [ :each | ZfsPool name: each ]
]
