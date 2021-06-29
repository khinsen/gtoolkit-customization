Class {
	#name : #KhHomeSection,
	#superclass : #GtHomeSection,
	#category : #'KhGToolkitCustomization-Home'
}

{ #category : #'api - instantiation' }
KhHomeSection >> create [
	| sectionContainer cardsContainer |
	sectionContainer := self newSectionContainer.
	sectionContainer addChild: (self newSectionTitle: 'KH').
	cardsContainer := self newCardsContainer.
	cardsContainer addChild: (self
		newToolCardWithTitle: 'ReScience'
		icon: (ReScienceC new ghOrganization avatarPicture
				asGrayScale scaledToSize: (64 @ 64)) asElement
		action: [ :card |
			self showSpaceWithTitle: 'ReScience C'
						with:	(GtInspector createOn: ReScienceC new)
						from: card ]
		description: 'ReScience C dashboard').
	sectionContainer addChild: cardsContainer.
	^ sectionContainer
]
