Class {
	#name : #I3,
	#superclass : #Object,
	#category : #'KhGToolkitCustomization-I3'
}

{ #category : #accessing }
I3 class >> bindingModes [
	^ (self sendMessageAndParseResult: 'get_binding_modes')
]

{ #category : #accessing }
I3 class >> config [
	^ self sendMessage: 'get_config'
]

{ #category : #accessing }
I3 class >> marks [
	^ (self sendMessageAndParseResult: 'get_marks')
]

{ #category : #accessing }
I3 class >> outputs [
	^ (self sendMessageAndParseResult: 'get_outputs')
]

{ #category : #operating }
I3 class >> sendMessage: aString [
	| proc |
	proc := GtSubprocessWithInMemoryOutput command: 'i3-msg' arguments: { '-t'. aString}.
	proc errorBlock: [ :aProc | self error: 'i3-msg failed' ].
	proc runAndWait.
	^ proc stdout
]

{ #category : #operating }
I3 class >> sendMessageAndParseResult: aString [
	^  NeoJSONReader fromString: (self sendMessage: aString)
]

{ #category : #accessing }
I3 class >> tree [
	^ I3Node fromRawData: (self sendMessageAndParseResult: 'get_tree')
]

{ #category : #accessing }
I3 class >> workspaces [
	^ (self sendMessageAndParseResult: 'get_workspaces')
]
