//
//  PictrueView.m
//  SCNews
//
//  Created by 凌       陈 on 11/6/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "PictrueView.h"

@implementation PictrueView

-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.maximumZoomScale = 5.0;//最大缩放倍数
        self.minimumZoomScale = 1.0;//最小缩放倍数
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor blackColor];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;//在UIImageView上加手势识别，打开用户交互
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [_imageView addGestureRecognizer:doubleTap];//添加双击手势
        [self addSubview:_imageView];
        
    }
    return self;
}



- (void)setImage:(UIImage *)image{
    self.imageView.image = image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat maxHeight = self.bounds.size.height;
    CGFloat maxWidth = self.bounds.size.width;
    //如果图片尺寸大于view尺寸，按比例缩放
    if(width > maxWidth || height > width){
        CGFloat ratio = height / width;
        CGFloat maxRatio = maxHeight / maxWidth;
        if(ratio < maxRatio){
            width = maxWidth;
            height = width*ratio;
        }else{
            height = maxHeight;
            width = height / ratio;
        }
    }
    self.imageView.frame = CGRectMake((maxWidth - width) / 2, (maxHeight - height) / 2, width, height);
}


#pragma mark UIScrollViewDelegate
//指定缩放UIScrolleView时，缩放UIImageView来适配
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

//缩放后让图片显示到屏幕中间
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize originalSize = self.bounds.size;
    CGSize contentSize = self.contentSize;
    CGFloat offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
    CGFloat offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
    self.imageView.center = CGPointMake(contentSize.width / 2 + offsetX, contentSize.height / 2 + offsetY);
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recongnizer
{
    UIGestureRecognizerState state = recongnizer.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            //以点击点为中心，放大图片
            CGPoint touchPoint = [recongnizer locationInView:recongnizer.view];
            BOOL zoomOut = self.zoomScale == self.minimumZoomScale;
            CGFloat scale = zoomOut?self.maximumZoomScale:self.minimumZoomScale;
            [UIView animateWithDuration:0.3 animations:^{
                self.zoomScale = scale;
                if(zoomOut){
                    CGFloat x = touchPoint.x*scale - self.bounds.size.width / 2;
                    CGFloat maxX = self.contentSize.width-self.bounds.size.width;
                    CGFloat minX = 0;
                    x = x > maxX ? maxX : x;
                    x = x < minX ? minX : x;
                    
                    CGFloat y = touchPoint.y * scale-self.bounds.size.height / 2;
                    CGFloat maxY = self.contentSize.height-self.bounds.size.height;
                    CGFloat minY = 0;
                    y = y > maxY ? maxY : y;
                    y = y < minY ? minY : y;
                    self.contentOffset = CGPointMake(x, y);
                }
            }];
            
        }
            break;
        default:break;
    }
}

@end
