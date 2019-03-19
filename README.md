# John Lewis Test

## Assumptions
• No tracking requirements
• No localisation requirements
• Writing in Swift 4 instead of 3 because it's the most current active version of Swift that Apple are pushing developers to use
• Don't have a detailed style guide so going with the standard system fonts and styles and keeping the look basic
• Only going with Unit Tests, not UI Tests

## Additions if more time
• The isValidResponse method in the APIService can be extended as much as you like to return more granular error reasons. For the case of this test I kept it very basic and simply either there was a valid 200 response otherwise all else failed generically.

## Notes
• Potentially I would split out the image downloading into a separate service specific to image loading, but to simplify the demo app development I just added an additional method to the ApiService class. The reason to separate image loading would be to allow image loading optimisation without affecting other data calls. On other projects we have also used 3rd party libraries like SDWebImage specifically for image downloading and caching.
• The HTML strings still require work
• Styling, building a consistent colour set, fonts all need work
