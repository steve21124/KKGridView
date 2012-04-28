//
//  Demo1ViewController.h
//  GridViewDemo
//
//  Created by Sehat Rosny on 4/25/12.
//  Copyright (c) 2012 kxk design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KKGridView/KKGridViewController.h>

@interface Demo1ViewController : KKGridViewController{
    NSInteger selectedItem;
    UIImagePickerController *imagePicker;
}
@property (nonatomic, readwrite) NSInteger selectedItem;
@property (nonatomic, retain) UIImagePickerController *imagePicker;

@end
