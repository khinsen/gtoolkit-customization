Class {
	#name : #BaselineOfKhGToolkitCustomization,
	#superclass : #BaselineOf,
	#category : #BaselineOfKhGToolkitCustomization
}

{ #category : #accessing }
BaselineOfKhGToolkitCustomization >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			package: #'KhGToolkitCustomization' ].
]
