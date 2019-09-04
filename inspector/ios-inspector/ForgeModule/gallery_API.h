//
//	gallery_API.h
//	ForgeInspector
//
//	Created by Antoine van Gelder on 27/11/2012.
//	Copyright (c) 2012 Trigger Corp. All rights reserved.
//


#import "ELCImagePickerFramework/ELCImagePickerController.h"
#import "ELCImagePickerFramework/ELCAlbumPickerController.h"

@interface gallery_API : NSObject

+ (void) getImages:(ForgeTask*)task;

@end


@interface ImagePickerDelegate : UIViewController <ELCImagePickerControllerDelegate> {
	ForgeTask *task;
}
- (ImagePickerDelegate*) initWithTask:(ForgeTask*)task;

@end


