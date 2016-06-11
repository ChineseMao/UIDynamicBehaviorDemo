//
//  ViewController.m
//  UIDynamicBehavior
//
//  Created by 毛韶谦 on 16/6/9.
//  Copyright © 2016年 毛韶谦. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) IBOutlet UIView *animationView;

@end

@implementation ViewController

- (UIDynamicAnimator *)animator {
    
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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




@end
