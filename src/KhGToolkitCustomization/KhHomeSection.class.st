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
	cardsContainer addChild: self reScienceCard.
	cardsContainer addChild: self guixCard.
	cardsContainer addChild: self zfsCard.
	cardsContainer addChild: self zoteroCard.
	sectionContainer addChild: cardsContainer.
	^ sectionContainer
]

{ #category : #'api - instantiation' }
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

{ #category : #'api - instantiation' }
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

{ #category : #'api - instantiation' }
KhHomeSection >> zfsCard [
	^ self
		  newToolCardWithTitle: 'ZFS Pools'
		  icon: ((ZnEasy getPng: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/OpenZFS_logo.svg/358px-OpenZFS_logo.svg.png')
		  		 asGrayScale scaledToSize: 64 @ 64) asElement
		  action: [ :card | 
			  self
				  showSpaceWithTitle: 'ZFS Pools'
				  with: (GtInspector createOn: Zfs pools)
				  from: card ]
		  description: 'ZFS Pools'
]

{ #category : #'api - instantiation' }
KhHomeSection >> zoteroCard [
	^ self
		  newToolCardWithTitle: 'Zotero'
		  icon: ((ZnEasy getPng: 'https://www.zotero.org/support/_media/logo/zotero_128x128x32.png')
		  		 asGrayScaleWithAlpha scaledToSize: 64 @ 64) asElement
		  action: [ :card | 
			  self
				  showSpaceWithTitle: 'Zotero'
				  with: (GtInspector createOn: (ZtUser username: 'khinsen'))
				  from: card ]
		  description: 'Zotero'
]
