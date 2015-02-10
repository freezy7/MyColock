//
//  ViewController.m
//  CoreAnimation
//
//  Created by R_style Man on 15-1-15.
//  Copyright (c) 2015年 R_style Man. All rights reserved.
//

#define SCREEN [UIScreen mainScreen].bounds.size

#import "ViewController.h"

@interface ViewController ()
{
    NSTimer* _timer;
}

@property (nonatomic,weak) IBOutlet UIImageView* hourHand;
@property (nonatomic,weak) IBOutlet UIImageView* minuteHand;
@property (nonatomic,weak) IBOutlet UIImageView* secondHand;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.layerView.center = CGPointMake(SCREEN.width/2, SCREEN.height/2);
    
//    CALayer* blueLayer = [CALayer layer];
//    blueLayer.frame = CGRectMake(50, 50, 100, 100);
//    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
//    [self.layerView.layer addSublayer:blueLayer];
//    
    //self.layerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    _hourHand.layer.anchorPoint = CGPointMake(0.5, 0.8);
    _minuteHand.layer.anchorPoint = CGPointMake(0.5, 0.8);
    _secondHand.layer.anchorPoint = CGPointMake(0.5, 0.8);
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stick) userInfo:nil repeats:YES];
    
    [self updateHandsAnimated:NO];
}

-(void) stick
{
    [self updateHandsAnimated:YES];
}

-(void) updateHandsAnimated:(BOOL) animated
{
    // convert time to hours,minutes and seconds
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger uints = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents* components = [calendar components:uints fromDate:[NSDate date]];
    // calculate hour hand angle
    CGFloat hourAngle = (components.hour/12.0)*2*M_PI;
    CGFloat minuteAngle = (components.minute/60.0)*2*M_PI;
    CGFloat secondAngle = (components.second/60.0)*2*M_PI;
    
    // rotate hands
    [self setAngle:hourAngle forHand:self.hourHand animated:animated];
    [self setAngle:minuteAngle forHand:self.minuteHand animated:animated];
    [self setAngle:secondAngle forHand:self.secondHand animated:animated];
    
}

-(void) setAngle:(CGFloat) angle forHand:(UIView*) handView animated:(BOOL) animated
{
    //generate transform
    CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1);
    if (animated)
    {
        // create transform animation
        CABasicAnimation* animation = [CABasicAnimation animation];
        [self updateHandsAnimated:NO];
        animation.keyPath = @"transform";
        animation.toValue = [NSValue valueWithCATransform3D:transform];
        animation.duration = 1;
        animation.delegate = self;
        [animation setValue:handView forKey:@"handView"];
        [handView.layer addAnimation:animation forKey:nil];
    }
    else
    {
        // set tansform directly
        handView.layer.transform = transform;
    }
}

-(void) animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    // set final posion for hand view
    UIView* handView = [anim valueForKey:@"handView"];
    handView.layer.transform = [anim.toValue CATransform3DValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
