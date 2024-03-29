//
//  WPToolBarView.m
//  wxDemo
//
//  Created by 吴鹏 on 16/7/25.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import "WPToolBarView.h"
#import "WPContentLable.h"


@interface WPToolBarView ()<UITextViewDelegate,WPMoreViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,WPBiaoQingViewDelegate>
{
    BOOL isVoice;
    BOOL isBiaoQing;
    BOOL isMore;
}

@property (nonatomic , strong) UIButton * leftBtn;
@property (nonatomic , strong) UIButton * rightbtn1;
@property (nonatomic , strong) UIButton * rightbtn2;
@property (nonatomic , strong) WPTextView * textView;
@property (nonatomic , strong) WPBiaoqiangView * biaoQingView;
@property (nonatomic , strong) WPMoreView * moreView;

@property (nonatomic , strong) UIButton * voiceBtn;
@property (nonatomic , strong) UIViewController * viewController;

@end


@implementation WPToolBarView

- (id)initWithFrame:(CGRect)frame viewController:(UIViewController *)viewController
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.viewController = viewController;
        viewController.automaticallyAdjustsScrollViewInsets = NO;
        self.backgroundColor = UIColorFromRGB(0xececef);
        self.textView = [[WPTextView alloc]initWithFrame:CGRectMake(42, 7.5, self.frame.size.width - 122, 35) mainView:self];
        self.textView.delegate = self;
        self.biaoQingView = [[WPBiaoqiangView alloc]initWithBiaoQingFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 223) mainView:self];
        self.biaoQingView.delegate = self;
        self.moreView = [[WPMoreView alloc]initWithMoreFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 223) mainView:self];
        self.moreView.delegate = self;
        [self addSubview:self.textView];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightbtn1];
        [self addSubview:self.rightbtn2];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(baoqingHidden)
                                                     name:WPBiaoQingWillHidden
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moreHidden)
                                                     name:WPMoreWillHidden
                                                   object:nil];
    }
    return self;
}


#pragma mark - property

- (UIButton *)leftBtn
{
    if(!_leftBtn)
    {
        _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, self.frame.size.height - 30 -10, 30,30)];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _leftBtn;
}

- (UIButton *)rightbtn1
{
    if(!_rightbtn1)
    {
        _rightbtn1 = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 13 - 60, self.frame.size.height - 30 -10, 30,30)];
        [_rightbtn1 setBackgroundImage:[UIImage imageNamed:@"biaoqing"] forState:UIControlStateNormal];
        [_rightbtn1 addTarget:self action:@selector(rightbtn1Click) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightbtn1;
}
- (UIButton *)rightbtn2
{
    if(!_rightbtn2)
    {
        _rightbtn2 = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 5 -30, self.frame.size.height - 30 -10, 30,30)];
        [_rightbtn2 setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_rightbtn2 addTarget:self action:@selector(rightbtn2Click) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightbtn2;
}

- (UIButton *)voiceBtn
{
    if(!_voiceBtn)
    {
        _voiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, 35)];
        [_voiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        _voiceBtn.backgroundColor = UIColorFromRGB(0xececef);
        [_voiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(voiceBtn2Click) forControlEvents:UIControlEventTouchUpInside];
        _voiceBtn.layer.borderWidth = 0.5;
        _voiceBtn.layer.cornerRadius = 6;
        _voiceBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _voiceBtn;
}


#pragma mark - private

- (void)leftBtnClick
{
    if(!isVoice)
    {
        self.textView.alpha = 0;
        [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
        [self addSubview:self.voiceBtn];
        [self endEditing:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:WPBiaoQingWillHidden object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:WPMoreWillHidden object:nil];
        [self.rightbtn1 setBackgroundImage:[UIImage imageNamed:@"biaoqing"] forState:UIControlStateNormal];
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50);
        isBiaoQing = NO;
        isMore = NO;
        
    }else
    {
        self.textView.alpha = 1;
        [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [self.textView becomeFirstResponder];
        [self.voiceBtn removeFromSuperview];
    }
    
    isVoice = !isVoice;
    [self configerViewControllerTableviewFram];
    
}

- (void)rightbtn1Click
{
    self.textView.alpha = 1;
    if(!isBiaoQing)
    {
        [self.viewController.view addSubview:self.biaoQingView];
        
        [self.rightbtn1 setBackgroundImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
        [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:WPMoreWillHidden object:nil];
        [self endEditing:YES];
        [self.voiceBtn removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:WPBiaoQingWillShow object:nil];
        [self.textView setNeedsDisplay];
        isVoice = NO;
        isMore = NO;
        isBiaoQing = YES;
        
    }else
    {
        [self.rightbtn1 setBackgroundImage:[UIImage imageNamed:@"biaoqing"] forState:UIControlStateNormal];
        [self.textView becomeFirstResponder];
        [self.biaoQingView removeFromSuperview];
        isBiaoQing = NO;
       
    }
    
    [self configerViewControllerTableviewFram];
    
}

- (void)rightbtn2Click
{
    
    self.textView.alpha = 1;
    if(!isMore)
    {
        [self.viewController.view addSubview:self.moreView];
        [[NSNotificationCenter defaultCenter] postNotificationName:WPBiaoQingWillHidden object:nil];
        [self endEditing:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:WPMoreWillShow object:nil];
        [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [self.rightbtn1 setBackgroundImage:[UIImage imageNamed:@"biaoqing"] forState:UIControlStateNormal];
        [self.voiceBtn removeFromSuperview];
        [self.textView setNeedsDisplay];
        isVoice = NO;
        isBiaoQing = NO;
        isMore = YES;
    }else
    {
        [self.textView becomeFirstResponder];
        [self.moreView removeFromSuperview];
        isMore = NO;
    }
    
    [self configerViewControllerTableviewFram];
}

- (void)voiceBtn2Click
{
    
}

- (void)baoqingHidden
{
    [self.rightbtn1 setBackgroundImage:[UIImage imageNamed:@"biaoqing"] forState:UIControlStateNormal];
    isBiaoQing = NO;
    [self configerViewControllerTableviewFram];
}

- (void)moreHidden
{
    isMore = NO;
}

- (void)configerViewControllerTableviewFram
{
    for(UIView * view in self.viewController.view.subviews)
    {
        if([view isKindOfClass:[UITableView class]])
        {
            [UIView animateWithDuration:0.25
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 view.frame = CGRectMake(0,64, view.frame.size.width, self.frame.origin.y - 64);
                             } completion:nil];
            
        }
    }
    
}


#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    isBiaoQing = NO;
    isMore = NO;
    [self.moreView removeFromSuperview];
    [self.biaoQingView removeFromSuperview];
    [self.rightbtn1 setBackgroundImage:[UIImage imageNamed:@"biaoqing"] forState:UIControlStateNormal];
    [self configerViewControllerTableviewFram];

}

- (BOOL)textView: (UITextView *)textview shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(wp_respond:)])
        {
            WPDataModel * model = [[WPDataModel alloc]init];
        
            model.content = [NSString stringWithFormat:@"%@%@",self.textView.text,@" "];
            model.fromOrto = TO;
            model.stype = PASSSTYPE_STR;
            NSLog(@" %@ ",self.textView.text);
            
            
            NSString * str = [WPStringManager replaceStr:self.textView.text];
            
            model.contentWidth = [WPStringManager getStringRect:str].width;
            model.contentHeight = [WPStringManager getStringRect:str].height + 25;
            [self.delegate wp_respond:model];
            self.textView.text = @"";
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - WPMoreViewDelegate

- (void)moreViewTreated:(NSInteger)treated
{
    if(treated == 0)
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.viewController presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}


#pragma mark - imagepickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(wp_respond:)])
    {
        WPDataModel * model = [[WPDataModel alloc]init];
        model.content = image;
        model.fromOrto = TO;
        model.stype = PASSSTYPE_IMG;
        
        CGSize size = CGSizeMake(150, 180);
        CGSize imgSize= image.size;
        float scale=size.height/size.width;
        float imgScale=imgSize.height/imgSize.width;
        float width=0.0f,height=0.0f;
        if(imgScale<scale&&imgSize.width>size.width){
            width=size.width;
            height=width*imgScale;
        }else if(imgScale>scale&&imgSize.height>size.height){
            height=size.height;
            width=height/imgScale;
        }else
        {
            height = image.size.height;
            width = image.size.width;
        }
        
        model.contentWidth = width;
        model.contentHeight = height;
        [self.delegate wp_respond:model];
    }
}

#pragma mark - biaoqingDelegate

- (void)WPbiaoQiongStr:(NSString *)str
{
    self.textView.text = [NSString stringWithFormat:@"%@%@",self.textView.text,str];
}

@end
