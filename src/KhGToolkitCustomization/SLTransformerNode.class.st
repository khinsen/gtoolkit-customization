Class {
	#name : #SLTransformerNode,
	#superclass : #SLNode,
	#category : #'KhGToolkitCustomization-Seamless'
}

{ #category : #accessing }
SLTransformerNode class >> type [
	^ #transformer
]

{ #category : #inspecting }
SLTransformerNode >> gtPinsFor: aView [
	<gtView>
	self pins ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Pins';
		priority: 1;
		items: [ self pins associations ];
		column: 'Name' text: #key;
		column: 'Value' text: #value;
		send: #value;
		yourself
]

{ #category : #accessing }
SLTransformerNode >> itemAt: aString ifAbsent: aBlock [
	^ self pins at: aString ifAbsent: aBlock
]

{ #category : #accessing }
SLTransformerNode >> pinNamed: aString [
	^ self pins at: aString
]

{ #category : #accessing }
SLTransformerNode >> pins [
	pins ifNil: [
		pins :=
			((rawData at: 'pins' ifAbsent: [Dictionary new])
				associations collect: [ :each |
					each key -> (SLPin new
									rawData: each value;
									node: self;
									name: each key) ])
					asDictionary ].
	^ pins
]
