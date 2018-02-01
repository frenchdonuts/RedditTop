# RedditTop
Simple Reddit client that shows the top 50 entries from www.reddit.com/top

The project is splitted on four separate layers: Storage Layer, Service Layer, Business Logic Layer and UI Layer.
1) **Storage Layer** - responses for retrieving/storing an application state and caching an image data. It includes an image cache and base data model structures representing Reddit API models. Image cache is very simple and uses `Dictionary<URL:UIImage>` for storing/retrieving images for particular urls. It conforms `ImageCache` protocol which allows to  use different types of caching later without changing the rest of the project. For example it could be improved to use limited size of memory, to use disk storage, to track an age of items, etc.
2) **Service Layer** - responses for communication and serialization. Communication part of this layer based on `URLSession` and `URLSessionDataTask` classes, serialization part based on `JSONEncoder` class.
3) **Business Logic Layer** - responses for a business logic, coordination between the other layers and represents a `ViewModel` part of `MVVM` design pattern. It uses `Bond` class for binding the model data with UI components and `Paginator` class for retrieving pginated data from back-end. For now `Bond` class includes very basic staff and could be extended later for supporting more `UIKit` classes and `Foundation` collections. This part of the project should be covered by `Unit Testing` using `XCTest` class which has not done due to time constrains.
4) **UI Layer** - includes all basic UI staff. It's based on `UITableViewController` for displaying Reddit top listing records and `UIViewController` for presenting image data.

