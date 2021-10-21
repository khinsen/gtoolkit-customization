Class {
	#name : #GitHubParser,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'ampersand',
		'alphanumeric',
		'alphanumericOrHyphen',
		'username',
		'usernameFromSea'
	],
	#category : #'KhGToolkitCustomization-GitHub'
}

{ #category : #operating }
GitHubParser class >> usernamesFromText: aString [
	^ ((self newStartingAt: #usernames)
		parse: aString)
		collect: #value
]

{ #category : #production }
GitHubParser >> alphanumeric [
	^ #letter asPParser / #digit asPParser
]

{ #category : #production }
GitHubParser >> alphanumericOrHyphen [
	^ alphanumeric / $- asPParser
]

{ #category : #production }
GitHubParser >> ampersand [
	^ $@ asPParser
]

{ #category : #production }
GitHubParser >> username [
	^ (ampersand, alphanumeric, alphanumericOrHyphen star) token
]

{ #category : #production }
GitHubParser >> usernameFromSea [
	^ username sea ==> #second
]

{ #category : #production }
GitHubParser >> usernames [
	^ usernameFromSea star
]
