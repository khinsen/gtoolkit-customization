Class {
	#name : 'KhHomeSection',
	#superclass : 'GtHomeSection',
	#category : 'KhGToolkitCustomization-Home'
}

{ #category : 'api - instantiation' }
KhHomeSection >> create [
	| sectionContainer cardsContainer |
	sectionContainer := self newSectionContainer.
	sectionContainer addChild: (self newSectionTitle: 'KH').
	cardsContainer := self newCardsContainer.
	cardsContainer addChild: self reScienceCard.
	cardsContainer addChild: self guixCard.
	sectionContainer addChild: cardsContainer.
	^ sectionContainer
]

{ #category : 'api - instantiation' }
KhHomeSection >> guixCard [
	^ self
		  newToolCardWithTitle: 'Guix Packages'
		  icon: ((ZnEasy getPng: 'https://guix.gnu.org/static/base/img/Guix.png')
		  		 asGrayScale scaledToSize: 64 @ 64) asElement
		  action: [ :card | 
			  self
				  showSpaceWithTitle: 'Guix packages'
				  with: (GtInspector createOn: GxChannels current packageCatalog)
				  from: card ]
		  description: 'Guix package catalog'
]

{ #category : 'api - instantiation' }
KhHomeSection >> reScienceCard [
	^ self
		  newToolCardWithTitle: 'ReScience'
		  icon: (ReScienceC new ghOrganization avatarPicture asGrayScale 
				   scaledToSize: 64 @ 64) asElement
		  action: [ :card | 
			  self
				  showSpaceWithTitle: 'ReScience C'
				  with: (GtInspector createOn: ReScienceC new)
				  from: card ]
		  description: 'ReScience C dashboard'
]
