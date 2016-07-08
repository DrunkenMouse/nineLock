//
//  ADView.m
//  手势解锁
//
//  Created by 王奥东 on 16/3/21.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADView.h"

@interface ADView ()

@property(strong,nonatomic)NSMutableArray<UIButton *> * selectedArray;

@property(strong,nonatomic)UIColor *lineColor;

@property(assign,nonatomic)CGPoint locPoint;

@end


@implementation ADView

-(UIColor *)lineColor{
    
    if (_lineColor == nil) {
        _lineColor = [UIColor whiteColor];
    }
    
    return _lineColor;
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bez = [[UIBezierPath alloc]init];
    
    for (int i = 0; i<self.selectedArray.count; i++) {
       
        if (i==0) {
            [bez moveToPoint:self.selectedArray[i].center];
        }else{
            [bez addLineToPoint:self.selectedArray[i].center];
        }
    }
    if (self.selectedArray.count>0) {
        [bez addLineToPoint:self.locPoint];
    }
    
    [self.lineColor set];
    
    [bez stroke];
}

-(NSMutableArray *)selectedArray{
    
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    
    return _selectedArray;
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = touches.anyObject;
    
    CGPoint loc = [touch locationInView:touch.view];
    self.locPoint = loc;
    
    for (int i = 0; i<self.subviews.count ; i++) {
        UIButton *btn = self.subviews[i];
        
        if (CGRectContainsPoint(btn.frame, loc)&&!btn.highlighted) {
            
            btn.highlighted = YES;
            [self.selectedArray addObject:btn];
            
        }
    }
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = touches.anyObject;
   
    CGPoint loc = [touch locationInView:touch.view];
     self.locPoint = loc;
    for (int i = 0; i<self.subviews.count ; i++) {
        UIButton *btn = self.subviews[i];
        
        if (CGRectContainsPoint(btn.frame, loc)&&!btn.highlighted) {
            
            btn.highlighted = YES;
            [self.selectedArray addObject:btn];
            
        }
    }
    [self setNeedsDisplay];

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.locPoint = [[self.selectedArray lastObject] center];
    
    NSMutableString *str = [[NSMutableString alloc]init];
    for (int i=0; i<self.selectedArray.count; i++) {
        [str appendFormat:@"%@",@(self.selectedArray[i].tag)];
    }
    
    if ([str isEqualToString:@"123"]) {
        [self clearPath];
    }else{
        for (UIButton *btn in self.selectedArray) {
        
            btn.highlighted = NO;
            btn.selected = YES;
    
        }
        
        self.lineColor = [UIColor redColor];
        [self setNeedsDisplay];
        self.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self clearPath];
        });
        self.userInteractionEnabled = YES;
      
    }
    
}
-(void)clearPath{
    
    self.lineColor = [UIColor whiteColor];
    
    for (UIButton *btn in self.selectedArray) {
        
        btn.highlighted = NO;
        btn.selected = NO;
        
    }
    [self.selectedArray removeAllObjects];
    [self setNeedsDisplay];
}
-(void)awakeFromNib{
    
    for (int i= 0 ; i<9 ; i++) {
        
        UIButton *btn = [[UIButton alloc]init];
        
        btn.userInteractionEnabled = NO;
        
        btn.tag = i;
        
        btn.imageView.image = [UIImage imageNamed:@"gesture_node_normal"];
        
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateHighlighted];
        
        [btn setImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateSelected];
        
        [self addSubview:btn];
        
    }
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    for (int i=0; i< self.subviews.count; i++) {
        
        CGFloat width = self.frame.size.width;
        
     //   CGFloat height = self.bounds.size.height;
        
        int columns = 3;
        
        int row = i/columns;
        int col = i%columns;
        
        CGFloat btnW = 74;
        CGFloat btnH = btnW;
        
        CGFloat marginW = (width - columns*btnW)/(columns-1);
        CGFloat marginH = marginW;
        
        CGFloat x = col * (btnW + marginW);
        CGFloat y = row * (btnH + marginH);
        
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, btnW , btnH);
        
        
    }
  

    
}

@end
