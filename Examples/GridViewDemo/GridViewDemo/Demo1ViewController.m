//
//  Demo1ViewController.m
//  GridViewDemo
//
//  Created by Sehat Rosny on 4/25/12.
//  Copyright (c) 2012 kxk design. All rights reserved.
//

#import "Demo1ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <KKGridView/KKGridView.h>
#import <KKGridView/KKGridViewCell.h>
#import <KKGridView/KKIndexPath.h>

static const NSUInteger kNumSection = 40;

@implementation Demo1ViewController{
    ALAssetsLibrary *_assetsLibrary;
    NSMutableArray *_photoGroups;
    NSMutableArray *_assets;
    NSCache *_thumbnailCache;
    dispatch_queue_t _imageQueue;

}

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
    return 3;
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
