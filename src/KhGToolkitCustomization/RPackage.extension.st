Extension { #name : #RPackage }

{ #category : #'*KhGToolkitCustomization' }
RPackage >> gtCommentFor: aView [
	<gtView>
	self packageManifestOrNil ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Comment';
		priority: 0.5;
		object: [ self packageManifest ];
		view: #gtCoderLepiterCommentsFor:;
		yourself
]
