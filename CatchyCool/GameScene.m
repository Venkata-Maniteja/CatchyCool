//
//  GameScene.m
//  CatchyCool
//
//  Created by Venkata Maniteja on 2015-11-30.
//  Copyright (c) 2015 Venkata Maniteja. All rights reserved.
//

#import "GameScene.h"
#import "GameViewController.h"

static const int blueBallHitCategory        = 1<<0;
static const int wallHitCategory            = 1<<1;
static const int pinkBallHitCategory        = 1<<2;
static const int ringHitCategory            = 1<<3;
static const int greenHitCategory           = 1<<4;
static const int redHitCategory             = 1<<5;
static NSString * const kRingNodeName       = @"movable";

@interface GameScene ()<SKPhysicsContactDelegate>{
    
    int seconds;
}

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@property (nonatomic, strong) SKSpriteNode *background;
@property (nonatomic, strong) SKSpriteNode *ringNode;


@end

@implementation GameScene




- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // stuff
        
        NSLog(@"Size: %@", NSStringFromCGSize(self.size));
        
        self.backgroundColor = [UIColor colorWithRed:250/255.0 green:240/255.0 blue:230/255.0 alpha:1];
        
        self.physicsWorld.contactDelegate = self;
       // [self.physicsWorld setGravity:CGVectorMake(0, 0)];
        self.physicsBody=[SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(self.frame.origin.x, self.frame.origin.y+100, self.frame.size.width, self.frame.size.height-200)];   //to make balls bounce
        self.physicsBody.categoryBitMask=wallHitCategory;
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    seconds=0;
    
    [self addBackground];
   
}



-(void)addBackground{
    
    _background = [SKSpriteNode spriteNodeWithImageNamed:@"parkImage.jpg"];
    _background.size = self.frame.size;
    _background.anchorPoint=CGPointMake(0, 0);
    _background.position = CGPointMake(0,0);
    
    
    [self addBallOfType:@"hGreenBall.png" ofSize:CGSizeMake(75, 75) addSpriteName:@"greenball" atPoint:CGPointMake(100, 100) withBounce:YES withVelocity:[self backwardCrossHitWithSpeed:50] andHitCategory:blueBallHitCategory];
    
    [self addBallOfType:@"hRedBall.png" ofSize:CGSizeMake(75, 75) addSpriteName:@"redball" atPoint:CGPointMake(200, 100) withBounce:YES withVelocity:[self hitTotopWithSpeed:60] andHitCategory:pinkBallHitCategory];
    
    [self addBallOfType:@"hYellowBall.png" ofSize:CGSizeMake(75, 75) addSpriteName:@"yellowball" atPoint:CGPointMake(400, 100) withBounce:YES withVelocity:[self hitToLeftWithSpeed:80] andHitCategory:blueBallHitCategory];
    
    [self addBallOfType:@"hBlackBall.png" ofSize:CGSizeMake(75, 75) addSpriteName:@"blackball" atPoint:CGPointMake(200, 300) withBounce:YES withVelocity:[self forwardCrossHitWithSpeed:50] andHitCategory:blueBallHitCategory];

    [self addChild:_background];
    
    
    
     [self addRing];
}

-(void)addRing{
    
    _ringNode=[SKSpriteNode spriteNodeWithImageNamed:@"hue_ring.png"];
    _ringNode.size=CGSizeMake(80, 80);
    _ringNode.position=CGPointMake(300, 300);
   _ringNode.anchorPoint=CGPointMake(0.5,0.5);
    _ringNode.name=kRingNodeName;
    _ringNode.zPosition = 200;
    [self addChild:_ringNode];
    

}


#pragma speed and point generators

-(CGPoint)randomPointGenerator{
    
    int x = arc4random() % (int) self.frame.size.width;
    int y = arc4random() % (int) self.frame.size.height;
    
    return CGPointMake(x, y);
    
}

//need to add angle of hit to these methods

-(CGVector)hitToLeftWithSpeed:(float)speed{
    
    return CGVectorMake(-speed, 0);
}

-(CGVector)hitToRightWithSpeed:(float)speed{
    
    return CGVectorMake(speed, 0);
}

-(CGVector)hitTotopWithSpeed:(float)spped{
    
    return CGVectorMake(0, spped);
}

-(CGVector)hitToBottomWithSpeed:(float)speed{
    
    return CGVectorMake(0, -speed);
}

-(CGVector)forwardCrossHitWithSpeed:(float)speed{
    
    return CGVectorMake(speed, speed);
}

-(CGVector)backwardCrossHitWithSpeed:(float)speed{
    
    return CGVectorMake(-speed, -speed);
}


//add methods to positipon the ball


-(CGPoint)addBallAtCenterWithOffsetX:(int)x withOffsetY:(int)y{
    
    return CGPointMake(100+x, 100+y);
}
-(CGPoint)addBallAtTopLeftWithOffsetX:(int) x withOffsetY:(int)y{
    
    return CGPointMake(200+x, 100+y);
}

-(CGPoint)addBallAtTopRightWithOffsetX:(int)x withOffsetY:(int)y{
    
    return CGPointMake(100+x, 100+y);
}

-(CGPoint)addBallAtBottomRightWithOffsetX:(int)x withOffsetY:(int)y{
    
    return CGPointMake(100+x, 2100+y);
}

-(CGPoint)addBallAtBottomLeftWithOffsetX:(int)x withOffsetY:(int)y{
    
    return CGPointMake(100+x, 200+y);
}


-(void)removeAllBalls{
    
    [self enumerateChildNodesWithName:@"redballs" usingBlock:^(SKNode *node,BOOL *stop){
        
        SKSpriteNode *ball = (SKSpriteNode *)node;
            [ball removeFromParent];
            NSLog(@"left ball removed");
            ball=nil;
        
    }];
    
    [self enumerateChildNodesWithName:@"blueballs" usingBlock:^(SKNode *node,BOOL *stop){
        
        SKSpriteNode *ball = (SKSpriteNode *)node;
        [ball removeFromParent];
        NSLog(@"left ball removed");
        ball=nil;
        
    }];

    
}


-(void)addBallOfType:(NSString *)imageName ofSize:(CGSize) size addSpriteName:(NSString *)name atPoint:(CGPoint)point withBounce:(BOOL) bounce withVelocity:(CGVector)velocity andHitCategory:(int) category{
    
    
    SKSpriteNode * ball = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    ball.name=name;
    ball.size=size;
    ball.anchorPoint=CGPointMake(0, 0);
    
    ball.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    ball.physicsBody.categoryBitMask=category;
    ball.physicsBody.collisionBitMask=blueBallHitCategory|pinkBallHitCategory|wallHitCategory;
    ball.physicsBody.contactTestBitMask=blueBallHitCategory|pinkBallHitCategory|wallHitCategory;
    
    ball.physicsBody.dynamic=YES;
    ball.physicsBody.affectedByGravity=NO;
    ball.physicsBody.restitution=1.0;
    ball.physicsBody.friction=0.0;
    ball.physicsBody.linearDamping=0.0;
    ball.physicsBody.angularDamping=0.0;
    
    ball.position=point;
    ball.zPosition = 100;
    
    [self addChild:ball];
    
    //need to add real physics to this method,like slow when hit something
  
    //applying impulse to bounce off
    
    if (bounce) {
        CGVector impulse = velocity;
        [ball.physicsBody applyImpulse:impulse];
        
    }
    
    
}






-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    [self rotateRingAtTouch:touchLocation];
    
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    CGPoint previousPosition = [touch previousLocationInNode:self];
    
    CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y); //trying to add 30,30 offset
    
             [self panForTranslation:translation];
    
    NSLog(@"ring position is %@",NSStringFromCGPoint(_ringNode.position));
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //cancel the rotation
    [_ringNode removeAllActions];
}

- (void)rotateRingAtTouch:(CGPoint)touchLocation {
    
        SKAction *rotateAction = [SKAction rotateByAngle:degToRad(180.0f) duration:2.0];
        
        [_ringNode runAction:[SKAction repeatActionForever:rotateAction]];
    
}



float degToRad(float degree) {
    return degree / 180.0f * M_PI;
}

- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGSize winSize = self.size;
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, -[_background size].width+ winSize.width);
    retval.y = [self position].y;
    return retval;
}

- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = [_ringNode position];
        [_ringNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)]; //trying to give 30,30 offset
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
   
    seconds++;
//    NSLog(@"x value is %d",x/60);
    if (seconds/60 <=0) {
       // [self bounceThePinkBallAtPoint:[self randomPointGenerator]];
        
    }
    
    [self checkSpriteMovement];
    
    //not needed at this point
    //[self removeNodesOutOfScreen];
    
}



-(void)didBeginContact:(SKPhysicsContact *)contact
{
    
    //somehoe firstnode is returned as SKScene, dont get frightned....
    
  SKSpriteNode * firstNode = (SKSpriteNode*)contact.bodyA.node;
  SKSpriteNode *  secondNode = (SKSpriteNode *)contact.bodyB.node;
    
    //need a condition to detect when ball hit the wall
    
    if((firstNode.physicsBody .categoryBitMask == blueBallHitCategory &&  secondNode.physicsBody.categoryBitMask == pinkBallHitCategory) || (firstNode.physicsBody .categoryBitMask == pinkBallHitCategory &&  secondNode.physicsBody.categoryBitMask == blueBallHitCategory))
    {
        
        NSLog(@"collision");
        
        firstNode.physicsBody.affectedByGravity=YES;
        secondNode.physicsBody.affectedByGravity=YES;
      
        
        [self addCrashParticleNode:firstNode.position betweeenNodesFirst:firstNode secondNode:secondNode];
        
        firstNode=nil;
        secondNode=nil;
        
    }
    
    if (firstNode.physicsBody .categoryBitMask == wallHitCategory ||  secondNode.physicsBody.categoryBitMask == wallHitCategory) {
        
        NSLog(@"do nothing");
        
        [self runAction:[SKAction playSoundFileNamed:@"basketBall bounce.WAV" waitForCompletion:NO]];
        
        secondNode.anchorPoint=CGPointMake(0.5, 0.5);
            [secondNode runAction:[SKAction rotateByAngle:degToRad(180.0f) duration:3.0]];//:degToRad(5.0f) duration:1.0]];
        
    }
}

-(void)addCrashParticleNode:(CGPoint)position betweeenNodesFirst:(SKSpriteNode *)firstNode secondNode:(SKSpriteNode *)secondNode{
    
    NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"];
    
    SKEmitterNode *crashNode = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
    
    crashNode.numParticlesToEmit=15;
    crashNode.name=@"crash";
    
    [self addChild:crashNode];
    crashNode.position=firstNode.position;
    
    CFTimeInterval totalTime = 0.5 + crashNode.particleLifetime+crashNode.particleLifetimeRange/2;
    [crashNode runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0.5 duration:totalTime],
                                            [SKAction removeFromParent]]]];
    
    //setup your methods and other things here
    
    
    //uncomment the remove lines for bounce testing
    [firstNode removeFromParent];
    [secondNode removeFromParent];
    
    firstNode=nil;
    secondNode=nil;
    
    

}






-(void)removeNodesOutOfScreen{
    
    [self enumerateChildNodesWithName:@"leftballs" usingBlock:^(SKNode *node,BOOL *stop){
        
        SKSpriteNode *ball = (SKSpriteNode *)node;
        
        if (ball.position.x>self.frame.size.width){
            
            [ball removeFromParent];
           NSLog(@"left ball removed");
            ball=nil;
            
        }
        
    }];
    
    [self enumerateChildNodesWithName:@"rightballs" usingBlock:^(SKNode *node,BOOL *stop){
        
        SKSpriteNode *ball = (SKSpriteNode *)node;
        
        if(ball==nil){
            NSLog(@"ball nil");
        }
        if (ball.position.x<0){
            
            [ball removeFromParent];
            NSLog(@"right ball removed");
            ball = nil;
        }
        
        
    }];
    
}


-(void)checkSpriteMovement{
    
    [self enumerateChildNodesWithName:@"leftballs" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
       
        SKSpriteNode *ball=(SKSpriteNode *)node;
        
        if (ball.physicsBody.resting) {
            
            NSLog(@"The ball position is %@",NSStringFromCGPoint(ball.position));
        }
        
    }];
    
}


@end
