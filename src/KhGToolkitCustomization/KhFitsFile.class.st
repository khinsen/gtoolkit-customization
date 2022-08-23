Class {
	#name : #KhFitsFile,
	#superclass : #Object,
	#instVars : [
		'fileReference',
		'form'
	],
	#category : #'KhGToolkitCustomization-Tools'
}

{ #category : #accessing }
KhFitsFile >> asFileReference [
	^ fileReference
]

{ #category : #accessing }
KhFitsFile >> asForm [
	form ifNil: [
		form := ImageReadWriter formFromStream: self asPngFileReference binaryReadStream ].
	^ form
]

{ #category : #accessing }
KhFitsFile >> asPngFileReference [
	| pngFile process |
	pngFile := GxTempFile new
				extension: 'png'.
	process :=	(GxPythonEnvironment forChannels: GxChannels current)
					addPackageOutput: 'python-fitsio';
					addPackageOutput: 'python-matplotlib';
					runScript: '
import sys
import fitsio
import matplotlib.pyplot as plt

assert(len(sys.argv) == 3)
fits_image_file = fitsio.FITS(sys.argv[1])
fits_image_file.update_hdu_list()
images = [hdu for hdu in fits_image_file.hdu_list
          if hdu.has_data() and hdu.get_info()[''hdutype''] == fitsio.IMAGE_HDU]
assert(len(images) == 1)
image = images[0].read()
plt.clf()
plt.imshow(image, cmap=''gray'', origin=''lower'')
plt.colorbar()
plt.savefig(sys.argv[2], format = ''png'')
'
					arguments: { fileReference fullName. pngFile asString }.
	^ pngFile asFileReference
]

{ #category : #accessing }
KhFitsFile >> fileReference: aFileReference [
	fileReference := aFileReference
]
