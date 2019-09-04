``gallery``: Gallery viewer and multiple image selection
========================================================

The ``forge.gallery`` namespace allows you to display a Gallery viewer that can select multiple images or videos.

##API

!method: forge.gallery.getImages(success, error)
!param: success `function(files)` callback to be invoked when no errors occur (argument is an array of returned files)
!description: Returns an array of file objects for images selected by the user from their device's gallery.
!platforms: iOS, Android
!param: error `function(content)` called with details of any error which may occur


!method: forge.gallery.getVideos(success, error)
!param: success `function(files)` callback to be invoked when no errors occur (argument is an array of returned files)
!description: Returns an array of file objects for videos selected by the user from their device's gallery.
!platforms: iOS
!param: error `function(content)` called with details of any error which may occur
