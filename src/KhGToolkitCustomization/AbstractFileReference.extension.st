Extension { #name : #AbstractFileReference }

{ #category : #'*KhGToolkitCustomization' }
AbstractFileReference >> gtSqlTablesFor: aView [
	<gtView>
	(self isFile
		and: [ self extension = 'db'
				and: [ (self readStreamDo: [ :s | s next: 16 ])
						= ('SQLite format 3',
							Character null asString) ] ])
		ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'SQLite tables';
		priority: 10;
		object: [ SQLiteDatabase file: self ];
		view: #gtTablesFor:;
		yourself
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
