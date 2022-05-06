Extension { #name : #AbstractFileReference }

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
