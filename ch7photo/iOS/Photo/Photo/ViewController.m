#import "ViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)cameraButtonTouched:(id)sender {
    
    // 카메라 기능 체크
    bool available = [UIImagePickerController
                      isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (available == NO) {
        return;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    cameraUI.delegate = self;
    cameraUI.mediaTypes = [[NSArray alloc]
                           initWithObjects: (NSString *) kUTTypeImage, nil];
    cameraUI.allowsEditing = NO;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
}

- (IBAction)libraryButtonTouched:(id)sender {
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.delegate = self;
    
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [[NSArray alloc]
                          initWithObjects: (NSString *) kUTTypeImage, nil];
    mediaUI.allowsEditing = NO;
    
    [self presentViewController:mediaUI animated:YES completion:nil];
}

- (IBAction)albumButtonTouched:(id)sender {
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.delegate = self;
    
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc]
                          initWithObjects: (NSString *) kUTTypeImage, nil];
    mediaUI.allowsEditing = YES;
    
    [self presentViewController:mediaUI animated:YES completion:nil];
}

#pragma mark - Methods

- (void)alertMetaData:(NSDictionary *)metaData {
    NSString *date = [[metaData objectForKey:@"{Exif}"]
                      objectForKey:@"DateTimeOriginal"];
    
    NSString *latStr = [[metaData objectForKey:@"{GPS}"]
                        objectForKey:@"Latitude"];
    double lat = [latStr doubleValue];
    
    NSString *lonStr = [[metaData objectForKey:@"{GPS}"]
                        objectForKey:@"Longitude"];
    double lon = [lonStr doubleValue];
    
    NSString *msg = [NSString stringWithFormat:@"촬영 일시: %@\n촬영 위치: %.2f, %.2f",
                     date, lat, lon];
    UIAlertView *uav = [[UIAlertView alloc] initWithTitle:@"EXIF 메타데이터"
                                                  message:msg
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
    [uav show];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"MediaType: %@", mediaType);
    
    // Show Image if Image
    
    if ([mediaType isEqualToString:@"public.image"]) {
        if (picker.allowsEditing) {
            // editedImage
            UIImage *editedImage = (UIImage *) [info objectForKey:
                                                UIImagePickerControllerEditedImage];
            self.imageView.image = editedImage;
        }
        if (!picker.allowsEditing) {
            // originalImage
            UIImage *originalImage = (UIImage *) [info objectForKey:
                                                  UIImagePickerControllerOriginalImage];
            self.imageView.image = originalImage;
        }
    }
    
    // MetaData for New Photo
    
    NSDictionary *mediaMetaData =
    [info objectForKey:UIImagePickerControllerMediaMetadata];
    
    if (mediaMetaData != nil) {
        [self alertMetaData:mediaMetaData];
        return;
    }
    
    // MetaData for Library Photo
    
    NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSLog(@"referenceURL: %@", referenceURL);
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        NSDictionary *metadata = rep.metadata;
        
        [self alertMetaData:metadata];
    } failureBlock:^(NSError *error) {
        // error handling
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"%@", @"dismiss");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
