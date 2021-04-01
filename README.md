# Timehop Mobile Code Challenge
This app shows a list of images and/or videos in a carousel format (as Instagram's Stories) following a set of guidelines

## Architecture
Before getting started on developing this app, there were 3 ways that I could've went in terms of designing the UI to flow according to instagram stories, of the 3 ways (UIKit+Programmatic Approach, UIKit+Storyboard/Xib Approach, SwiftUI), I decided to develop the app's UI using a UIKit+Programmatic Approach as it offered more control and flexibility but also a decrease in development time but also primarily because it is much easier to review in terms of PR's. SwiftUI would have the same benefit, however SwiftUI is still relatively new and has a few bugs that may have caused some issues along the way.

In terms of Architecture, I chose to use MVVM. The reason for choosing this Architecture over others is simply because it provides far better organization and code readability but also helps quite well when it comes to unit testing.

Besides MVVM, I followed S.O.L.I.D principals with priority over the single responsibility principal. I separated core functionalities into their own respective classes for easier management and testability

Alongside MVVM, I used the Combine framework quite heavily, it's really easy to use and works perfectly in every situation, especially in this app since there are a lot asynchronous events happening.

Another added use of custom Architecture is the use of ["Controlling The World"](https://www.pointfree.co/blog/posts/21-how-to-control-the-world) (A functional programming concept), essentially involves the use of a singleton (which of course are terrible to use in practice unless used in a specific design and with the guarantee of control over the singleton)

Using such method allowed me to have far greater control over dependencies and reduces the need of boiler plate code by a lot. Therefore making over engineered logic much simpler to read and understand.

It also provides great flexibility when it comes to switching the situations when needed for debugging without having to access multiple points in the codebase.

I was given the option to use 3rd party libraries as necessary but I opted not to do such thing because I prefer to build things on my own and it made the challenge a bit more challenging, it also reduced the dependency on another library, in the case of version updates, this could potentially cause future issues. Of course, granted the time constraint for this app. It would have been better to use a Cocoapod or Carthage or SPM to decrease the development time by a lot. Nonetheless, the app is working as required and by design.

## Improvements
The app as it is right now, works perfectly according to the specifications required for it. 

However, if there was more time allocated. An improvement for this app could be to improve the animations and transitions between controllers. As of right now, it's straightforward and doesn't feel as fluid as Instagram does.

The theme of the app is also quite minimal with not as much emphasis on color usage and custom designs which would have made the app have a more modern feel. 

