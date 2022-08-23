Extension { #name : #AbstractFileReference }

{ #category : #'*KhGToolkitCustomization' }
AbstractFileReference >> gtFitsImageFor: aView [
	<gtView>
	(self isFile and: [ self extension asLowercase = 'fts' ]) ifFalse: [ ^ aView empty ].
	^ aView explicit
		title: 'Picture';
		priority: 10;
		stencil: [ (KhFitsFile new fileReference: self) asForm asElement ]
]

{ #category : #'*KhGToolkitCustomization' }
AbstractFileReference >> khActionCopyPathFor: anAction [
	<gtAction>
	|  button |

	self exists ifFalse: [ ^ anAction noAction].
	^ anAction explicit stencil: [
		button := BrButton new.
		button
			aptitude: BrGlamorousButtonWithIconAptitude;
			action:  [ Clipboard clipboardText:  self fullName ];
			icon: BrGlamorousVectorIcons clipboard asElement;
			label: 'Copy path to clipboard' translated.
	]
]
