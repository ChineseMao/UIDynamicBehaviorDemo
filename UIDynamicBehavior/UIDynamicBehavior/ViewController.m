//
//  ViewController.m
//  UIDynamicBehavior
//
//  Created by 毛韶谦 on 16/6/9.
//  Copyright © 2016年 毛韶谦. All rights reserved.
//

#import "ViewController.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIDynamicAnimatorDelegate>

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) IBOutlet UIView *animationView;

@end

@implementation ViewController

- (UIDynamicAnimator *)animator {
    
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator.delegate = self;
    }
    return _animator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:imageView];
    
        UIGraphicsBeginImageContext(imageView.frame.size);
        [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);  //线宽
        CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);  //颜色
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 100, 100);  //起点坐标
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 200, 100);   //终点坐标
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        imageView.image=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();  
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取当前ctx
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(ctx, 5.0);  //线宽
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextSetRGBStrokeColor(ctx, 230/265.0, 48/265.0, 48/256.0, 1.0);  //颜色
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, kHeight/2);  //起点坐标
    CGContextAddLineToPoint(ctx, kWidth/2, 0);   //终点坐标
    CGContextStrokePath(ctx);
    
    //画两条射线
    // 创建一个Path句柄
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 初始化该path到一个初始点
    CGPathMoveToPoint(pathRef, &CGAffineTransformIdentity, 100.0f, 0.0f);
    // 添加一条直线，从初始点到该函数指定的坐标点
    CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, 150.0f, 100.0f);
    CGPathMoveToPoint(pathRef, &CGAffineTransformIdentity, 100.0f, 0.0f);
    CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, 100.0f, 150.0f);
    CGPathCloseSubpath(pathRef);
    // 关闭该path
    CGPathCloseSubpath(pathRef);
    // 将此path添加到Quartz上下文中
    CGContextAddPath(ctx, pathRef);
    // 对上下文进行描边
    CGContextStrokePath(ctx);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startAnimation:(UIButton *)sender {
    
//    iOS7UIKit动力学 重力特性UIGravityBehavior
    UIGravityBehavior *behavior = [[UIGravityBehavior alloc] initWithItems:@[self.animationView]];
    //（1）设置重力的方向（是一个角度）
//    behavior.angle=(M_PI_2-M_PI_4);
    //（2）设置重力的加速度,重力的加速度越大，碰撞就越厉害
    behavior.magnitude=10;
    //（3）设置重力的方向（是一个二维向量）
    behavior.gravityDirection=CGVectorMake(0, 1);
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:behavior];
}
- (IBAction)startAnimationCollision:(UIButton *)sender {
    
    //    iOS7UIKit动力学 重力特性UIGravityBehavior
    UIGravityBehavior *behavior = [[UIGravityBehavior alloc] initWithItems:@[self.animationView]];
    //（1）设置重力的方向（是一个角度）
    //    behavior.angle=(M_PI_2-M_PI_4);
    //（2）设置重力的加速度,重力的加速度越大，碰撞就越厉害
    behavior.magnitude=90;
    //（3）设置重力的方向（是一个二维向量）
    behavior.gravityDirection=CGVectorMake(0, 1);
    
    //碰撞检测行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.animationView]];
    //让参照视图的边框成为碰撞检测的边界
    collision.translatesReferenceBoundsIntoBoundary=YES;
    // 添加一个碰撞边界
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(180, 500, 20, 20)];
    [collision addBoundaryWithIdentifier:@"circle" forPath:path];
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:behavior];
    [self.animator addBehavior:collision];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    // 2 创建物理仿真行为(添加仿真元素)-->吸附行为
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.animationView snapToPoint:point];
    
    // 常用属性
    // 防抖系数  0到1  抖动效果逐渐变弱；
    snap.damping = 0.1f;
    // 3 将仿真元素添加到仿真器中
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:snap];
    
//    （1）UIDynamicAnimator的常见方法
//    
//    　　- (void)addBehavior:(UIDynamicBehavior *)behavior;  　　//添加1个物理仿真行为
//    
//    　　- (void)removeBehavior:(UIDynamicBehavior *)behavior;　　//移除1个物理仿真行为
//    
//    　　- (void)removeAllBehaviors;  　　//移除之前添加过的所有物理仿真行为
    
//    （2）UIDynamicAnimator的常见属性
//    
//    　　@property (nonatomic, readonly) UIView* referenceView;  //参照视图
//    
//    　　@property (nonatomic, readonly, copy) NSArray* behaviors;//添加到物理仿真器中的所有物理仿真行为
//    
//    　　@property (nonatomic, readonly, getter = isRunning) BOOL running;//是否正在进行物理仿真
//    
//    　　@property (nonatomic, assign) id <UIDynamicAnimatorDelegate> delegate;//代理对象（能监听物理仿真器的仿真过程，比如开始和结束）
}

- (IBAction)startAnimationCollision1:(UIButton *)sender {
    
    // 1.重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    [gravity addItem:self.animationView];
    
    // 2.碰撞检测行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
    [collision addItem:self.animationView];
    CGPoint startP = CGPointMake(0, kHeight/2);
    CGPoint endP = CGPointMake(kWidth/2, kHeight);
    [collision addBoundaryWithIdentifier:@"line1" fromPoint:startP toPoint:endP];
    CGPoint startP1 = CGPointMake(kWidth*2, kHeight-50);
    [collision addBoundaryWithIdentifier:@"line2" fromPoint:endP toPoint:startP1];
    //    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    
    
    [self.animator removeAllBehaviors];
    // 3.开始仿真
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
}

- (IBAction)attachmentBehaviorAction:(UIButton *)sender {
    
    UIAttachmentBehavior *attachmentB = [[UIAttachmentBehavior alloc] initWithItem:self.animationView attachedToAnchor:CGPointMake(CGRectGetMaxX(self.animationView.frame), CGRectGetMaxY(self.animationView.frame))];
    UIGravityBehavior *gravityB = [[UIGravityBehavior alloc] initWithItems:@[self.animationView]];
    //重力方向；
//    [gravityB setAngle:M_PI magnitude:1.0f];
    gravityB.angle = -M_PI/2;
    [self.animator removeAllBehaviors];
    //开始
    [self.animator addBehavior:attachmentB];
    [self.animator addBehavior:gravityB];
}

//UIDynamicAnimator delegate 代理方法
//结束时调用；
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    
}

//开始时调用；
- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    
}


@end
