# Hudl Test

iOS test for Hudl.
The test is based in Youtube API. The test is organized using Cocoapods.
To install the test you will have to run 'Pod install' since the Pods file has not been commited into the repository to avoid huge data.

Once you run the app, the app asks to "HudlStudios" channel for the latests videos. Once those videos are parsed the app is presenting the results in a CollectionView. 

I used a collection view so we can have also multiple cells layout in iPad.
The app works in all iOS devices. 

You can favourite and unfavourite videos. I used Realm Database since is cleaner and nicier than CoreData. Also it was reducing the code complexity, and for this test it was unnecessary to increase complexity.

If you click the navigationBar button, the view will be reloaded with your favourited videos. 
If you click back that button, you will be again presented with the channel videos. I'm not storing them in any temporal array, since NSURLSession already caches the answer. 

I also used a 3rd party library to be able to get the original video URL so I can also play the videos. If you click on a video, you will be presented with a ModalView where it is using AVPlayer to stream the Video.

If you really want to test other video channels, you will only need to change the channel string in the HudlViewModel. Run the app again and all will run again.

The app has implemented several Throws and error handling. I dindt add any UI feedback in any of those but, all the possible issues are catched through swift error handling.

There are also few Unit test for the most important parts of the app.

  