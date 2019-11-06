//	gallery_API.m
//	ForgeInspector
//
//	Created by Antoine van Gelder on 27/11/2012.
//	Copyright (c) 2012 Trigger Corp. All rights reserved.
//

#import "gallery_API.h"
#import <MobileCoreServices/MobileCoreServices.h>

/**
 * gallery_API
 */
@implementation gallery_API

+ (void) getImages:(ForgeTask*)task {
    ELCImagePickerController *pickerController = [[ELCImagePickerController alloc] initImagePicker];
    pickerController.maximumImagesCount = 100;
    pickerController.returnsOriginalImage = YES; // fullscreen vs fullres
    pickerController.returnsImage = NO; // uiimage or image location
    pickerController.onOrder = YES;
    pickerController.mediaTypes = @[(NSString*)kUTTypeImage];
    pickerController.imagePickerDelegate = [[ImagePickerDelegate alloc] initWithTask:task];

    if (@available(iOS 13.0, *)) {
        pickerController.modalPresentationStyle = UIModalPresentationAutomatic;
    } else {
        // Spectacularly, as of iOS 13, earlier versions fail with the default modalPresentationStyle.
        pickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    [[[ForgeApp sharedApp] viewController] presentViewController:pickerController animated:YES completion:nil];
}

+ (void) getVideos:(ForgeTask*)task {
    ELCImagePickerController *pickerController = [[ELCImagePickerController alloc] initImagePicker];
    pickerController.maximumImagesCount = 100;
    pickerController.returnsOriginalImage = YES; // fullscreen vs fullres
    pickerController.returnsImage = NO; // uiimage or image location
    pickerController.onOrder = YES;
    pickerController.mediaTypes = @[(NSString*)kUTTypeMovie];
    pickerController.imagePickerDelegate = [[ImagePickerDelegate alloc] initWithTask:task];
    
    if (@available(iOS 13.0, *)) {
        pickerController.modalPresentationStyle = UIModalPresentationAutomatic;
    } else {
        // Spectacularly, as of iOS 13, earlier versions fail with the default modalPresentationStyle.
        pickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    [[[ForgeApp sharedApp] viewController] presentViewController:pickerController animated:YES completion:nil];
}

@end


/**
 * ImagePickerDelegate
 */
@implementation ImagePickerDelegate

- (ImagePickerDelegate*) initWithTask:(ForgeTask *)forgetask {
    if (self = [super init]) {
        task = forgetask;
    }
    return self;
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void) elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSMutableArray *images = [NSMutableArray arrayWithCapacity:2];

    for (NSDictionary *dict in info) {
        NSMutableDictionary *file = [NSMutableDictionary dictionaryWithCapacity:2];
        [file setValue:[[dict objectForKey:UIImagePickerControllerReferenceURL] absoluteString] forKey:@"uri"];
        if ([picker.mediaTypes containsObject:(NSString *)kUTTypeMovie]) {
            [file setValue:@"video" forKey:@"type"];
        } else {
            [file setValue:@"image" forKey:@"type"];
        }
        [images addObject:file];
    }

    [task success:images];
}

- (void) elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [task success:[NSMutableArray arrayWithCapacity:0]];
}

@end
