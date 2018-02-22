# RedditTop (Demo Project)
Simple Reddit client that shows the top 50 entries from www.reddit.com/top

![feed](https://github.com/ninjaproger/RedditTop/blob/master/screen1.png)![image](https://github.com/ninjaproger/RedditTop/blob/master/screen2.png)


**Requirements:**
Create a simple Reddit client that shows the top 50 entries fromwww.reddit.com/top .
- Assume the latest platform and use Swift
- Use UITableView / UICollectionView to arrange the data.
- Please refrain from using AFNetworking, instead use NSURLSession
- Support Landscape
- Use Storyboards
The app should be able to show data from each entry such as:
- Title (at its full length, so take this into account when sizing your cells)
- Author
- entry date, following a format like “x hours ago”
- A thumbnail for those who have a picture
- Number of comments
In addition, for those having a picture (besides the thumbnail) , please allow the user to tap on the thumbnail to be sent to the full sized picture. You don’t have to implement the IMGUR API, so just opening the URL would be OK.
Also include:
- Pagination support
- Saving pictures in the picture gallery
- App state preservation/restoration
- Support iPhone 6/ 6+ screen size

**Note**:
*Please refrain from using external libraries*

**How it's done**:
The project is splitted on four separate layers: Storage Layer, Service Layer, Business Logic Layer and UI Layer.
1) **Storage Layer** - responses for retrieving/storing the application state and caching an image data. It includes an image cache and base data model structures representing Reddit API models. Image cache is very simple it works like `LRU` policy, inherits from `Cache`  and uses `LinkedList` for storing/retrieving images for particular urls. It allows using different types of caching later without changing the rest of the project. For example it could be improved to use a disk storage, to track an age of items, etc.
2) **Service Layer** - responses for communication and serialization. The communication part of this layer based on `URLSession`, `URLSessionDownloadTask` and `URLSessionDataTask` classes, the serialization part based on `JSONDecoder` class.
3) **Business Logic Layer** - responses for a business logic, coordination between the other layers and represents a `ViewModel` part of `MVVM` design pattern. It uses `Bond` class for binding the model data with UI components and `Paginator` class for retrieving paginated data from the back-end. For now `Bond` class includes a very basic staff and could be extended later for supporting more `UIKit` classes and `Foundation` collections. This part of the project should be covered by `Unit Testing` using `XCTest` class which has not done due to time constrains, although `Paginator` class is partially covered by unit tests.
4) **UI Layer** - includes all basic UI staff. It's based on `UITableViewController` for displaying Reddit top listing records and `UIViewController` for presentation of image data.

**TODO**:
- Make `Bond` support collections and `UIKit` classes
- Add custom transition animations for showing full sized images
- Cover `RedditTopViewModel` with unit tests.
