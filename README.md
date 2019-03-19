# John Lewis Test

## Assumptions
• No tracking requirements
• No localisation requirements
• Writing in Swift 4 instead of 3 because it's the most current active version of Swift that Apple are pushing developers to use
• Don't have a detailed style guide so going with the standard system fonts and styles and keeping the look basic
• Only going with Unit Tests, not UI Tests

## Notes
I have tried to write the technical test using TDD where possible. Whilst this was easier at the start when contructing the more code only parts of the project e.g. the ApiService, it proved more challenging once I started contructing the UI. Also the project went from 100% coverage to much less once I started adding different UI components and screens. 

The test coverage is not perfect, but I tried to cover as much as possible in a reasonable time, as well as trying to get the UI to a reasonable and functional point also. I used code separation as much as possible moving code out into ViewModel and ViewData classes where appropriate so that those could be tested more easily. I have not managed to write tests to cover 100% of that code though, however given more time it should have been possible.

As time was drawing out, I have made some compromises in the 2 view controllers. I would prefer to pair program those classes further to discuss and come up with additional ways to clean up the code and reduce coupling and complexity. The ProductListViewController could have been enhanced with a custom collectionview flow layout class, but I didn't have time.

The refreshCellSize() and calculateCellWidth() functions in the ProductListViewController view controller are the main culprits that I would like to refactor and remove.

The details screen has been broken down into multiple subviews in order to provide better code reuse, allow the possibility for individual views to be reused else where, and to allow aspects of that complex UI to be refactored and replaced with alternative solutions more easily.

The gallery component works, but is not something that I would be happy leaving as a final solution. There are definite improvements that could be added like preloading images next to the current image, image caching and better easing when the details screen loads.

I have added a basic label to the UI to show the status of loading and also tied this to the network indicator. I would ideally build another reusable view for that as well as enhance it with the ability to cancel the loading task and provide feedback if a loading task fails.

I would choose to split out the image downloading functionality into a separate service specifically for image loading as this is usually a primary app function, and numerous improvements and enhancements and types of caching can be applied to assist with performance. On previous projects I've used 3rd party libraries also like SDWebImage.

The isValidResponse method in the APIService can be extended as much as you like to return more granular error reasons. I've kept the initial implementation simple so as to not make too many assumptions about requirements around error handling.

I would have liked to have presented some feedback to the user of network failures, but I have not implemented that functionality. It should be a fairly simple addition to the current work however.
