# SCPodcasts
This App will be fully functional in terms of searching for available radio Podcasts on iTunes. Play the podcasts, Mini audio bar for showing podcasts. Uses all the proper techniques to build out an Audio Player application completely nativ way.

## Core Features
- Alamofire Integration to greatly simplify network requests architecture
- AVKit Audio Player libraries for audio playback
- Offline Playback of podcasts enabled through download feature
- Control playback when App is in background
- Parsing JSON asynchronously
- Learn to use XML parsing Pods through Cocoapods integration
- User Favorites persistence with UserDefaults


### Screenshots
![PodcastRadio1](https://user-images.githubusercontent.com/1453658/65697237-8132e280-e072-11e9-9d4e-fb372ee31e7e.png)
![Podcast2](https://user-images.githubusercontent.com/1453658/65697238-8132e280-e072-11e9-8b7a-b23a77a715ab.png)
![Podcast3](https://user-images.githubusercontent.com/1453658/65697239-81cb7900-e072-11e9-9e17-1fe8ebb167f4.png)
![Fav1](https://user-images.githubusercontent.com/1453658/65869880-12f06780-e373-11e9-9d15-e844c50062cd.png)


### Development Platform
- iOS 12.2 and XCode 10.2.1
- Swift 5

### Swift architecture
- The application is build with MVVM-C (Model-View-ViewModel and Coordinator) architecture. Use of coordinator patern for navigation. Therefore viewcontrollers are free from navigation. 
- Listner 
- Binding View Movel with Views with Binders
- Universal App that support different layouts for iPhone and iPad in horizental and vertical orientation.
