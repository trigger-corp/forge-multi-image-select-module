//	gallery_API.m
//	ForgeInspector
//
//	Created by Antoine van Gelder on 27/11/2012.
//	Copyright (c) 2012 Trigger Corp. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <Photos/Photos.h>

#import "gallery_API.h"


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

- (void) elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray*)selection {
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSMutableArray *files = [NSMutableArray arrayWithCapacity:selection.count];

    for (NSDictionary *item in selection) {
        // get PHAsset for selection
        NSURL *referenceURL = [item objectForKey:UIImagePickerControllerReferenceURL];
        PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[referenceURL] options:nil];
        PHAsset *asset = [result firstObject];
        if (asset == nil) {
            [task error:[NSString stringWithFormat:@"Could not locate asset with reference url: %@", [referenceURL absoluteString]]];
            return;
        }

        // construct a ForgeFile from PHAsset
        if (asset.mediaType == PHAssetMediaTypeImage) {
            [files addObject:@{
                @"uri": [NSString stringWithFormat:@"photo-library://image/%@?ext=JPG", [asset localIdentifier]],
                @"type": @"image"
            }];
        } else if (asset.mediaType == PHAssetMediaTypeVideo) {
            [files addObject:@{
                @"uri": [NSString stringWithFormat:@"photo-library://video/%@?ext=MOV", [asset localIdentifier]],
                @"type": @"video"
            }];
        } else {
            [task error:[NSString stringWithFormat:@"Invalid media type for reference url: %@ -> %ld", [referenceURL absoluteString], (long)asset.mediaType]];
        }
    }

    [task success:files];
}


- (void) elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [task success:[NSMutableArray arrayWithCapacity:0]];
}

@end
