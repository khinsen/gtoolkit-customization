Extension { #name : #ZnUrl }

{ #category : #'*KhGToolkitCustomization' }
ZnUrl >> khActionWebBrowseFor: anAction [
	<gtAction>
	^ anAction explicit stencil: [
		BrButton new
			aptitude: BrGlamorousButtonWithIconAptitude;
			action:  [ WebBrowser openOn: self ];
			icon: BrGlamorousIcons go asElement;
			label: 'Open in OS' translated ]
]
