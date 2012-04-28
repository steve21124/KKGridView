//
//  Demo1ViewController.m
//  GridViewDemo
//
//  Created by Sehat Rosny on 4/25/12.
//  Copyright (c) 2012 kxk design. All rights reserved.
//

#include <math.h>

#import "Demo1ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <KKGridView/KKGridView.h>
#import <KKGridView/KKGridViewCell.h>
#import <KKGridView/KKIndexPath.h>

static const NSUInteger kNumSection = 40;
static inline double radians (double degrees) {return degrees * M_PI/180;}

@implementation Demo1ViewController{
    ALAssetsLibrary *_assetsLibrary;
    NSMutableArray *_photoGroups;
    NSMutableArray *_assets;
    NSCache *_thumbnailCache;
    dispatch_queue_t _imageQueue;

}
@synthesize selectedItem;
@synthesize imagePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - KKGridViewDataSource

- (NSUInteger)numberOfSectionsInGridView:(KKGridView *)gridView
{
    return 1;
}

- (NSUInteger)gridView:(KKGridView *)gridView numberOfItemsInSection:(NSUInteger)section
{
    return 10;
}

- (KKGridViewCell *)gridView:(KKGridView *)gridView cellForItemAtIndexPath:(KKIndexPath *)indexPath
{
    KKGridViewCell *cell = [KKGridViewCell cellForGridView:gridView];
    
    //ALAsset *asset = [[_assets objectAtIndex:indexPath.section] objectAtIndex:indexPath.index];
   // cell.imageView.image = [_thumbnailCache objectForKey:asset];
     UIImage *imageTest = [UIImage imageNamed: @"1_mango.png"];
    
    cell.imageView.image = imageTest;
    
    return cell; 
}
- (void)gridView:(KKGridView *)gridView didSelectItemAtIndexPath:(KKIndexPath *)indexPath{
    
    NSLog(@"did select");
    //
    // Create image picker controller
  //   imagePicker = [[UIImagePickerController alloc] init];
    
  //  imagePicker.delegate = self;
    // Set source to the camera
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    // Show image picker
    [self presentModalViewController:imagePicker animated:YES];    
    
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Save image
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    //[self.gridView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSNumber numberWithInt:selectedItem]]];
    [self.gridView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[KKIndexPath indexPathForIndex:2 inSection:0]]];  
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    if (error){
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];        
    }else{
        
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeKeepingAspect:(CGSize)targetSize
{ 
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }    
    
    CGContextRef bitmap;
    CGImageRef imageRef = [sourceImage CGImage];
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown)
    {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, 8, 4 * targetWidth, genericColorSpace, kCGImageAlphaPremultipliedFirst);
        
    }
    else
    {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, 8, 4 * targetWidth, genericColorSpace, kCGImageAlphaPremultipliedFirst);
        
    }  
    
    CGColorSpaceRelease(genericColorSpace);
    CGContextSetInterpolationQuality(bitmap, kCGInterpolationDefault);
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft)
    {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    }
    else if (sourceImage.imageOrientation == UIImageOrientationRight)
    {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    }
    else if (sourceImage.imageOrientation == UIImageOrientationUp)
    {
        // NOTHING
    }
    else if (sourceImage.imageOrientation == UIImageOrientationDown)
    {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}




/*
- (CGFloat)gridView:(KKGridView *)gridView heightForHeaderInSection:(NSUInteger)section
{
    return 25.f;
}

- (NSString *)gridView:(KKGridView *)gridView titleForHeaderInSection:(NSUInteger)section
{
    return [[_photoGroups objectAtIndex:section] valueForProperty:ALAssetsGroupPropertyName];
}

- (NSArray *)sectionIndexTitlesForGridView:(KKGridView *)gridView {
    return [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",nil];
}
*/



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
   // self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
