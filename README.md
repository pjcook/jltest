# John Lewis Test

## Assumptions
• No tracking requirements
• No localisation requirements
• Writing in Swift 4 instead of 3 because it's the most current active version of Swift that Apple are pushing developers to use
• Don't have a detailed style guide so going with the standard system fonts and styles and keeping the look basic
• Only going with Unit Tests, not UI Tests also

## Additions if more time
• The isValidResponse method in the APIService can be extended as much as you like to return more granular error reasons. For the case of this test I kept it very basic and simply either there was a valid 200 response otherwise all else failed generically.
