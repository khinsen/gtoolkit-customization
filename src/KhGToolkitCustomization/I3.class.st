Class {
	#name : #I3,
	#superclass : #Object,
	#category : #'KhGToolkitCustomization-I3'
}

{ #category : #operating }
I3 class >> sendMessage: aString [
	| proc |
	proc := GtSubprocessWithInMemoryOutput command: 'i3-msg' arguments: { '-t'. aString}.
	proc errorBlock: [ :aProc | self error: 'i3-msg failed' ].
	proc runAndWait.
	^ NeoJSONReader fromString: proc stdout
]

{ #category : #accessing }
I3 class >> tree [
	^ I3Node fromRawData: (self sendMessage: 'get_tree')
]
