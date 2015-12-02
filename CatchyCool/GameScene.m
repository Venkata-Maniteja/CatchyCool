//
//  GameScene.m
//  CatchyCool
//
//  Created by Venkata Maniteja on 2015-11-30.
//  Copyright (c) 2015 Venkata Maniteja. All rights reserved.
//

#import "GameScene.h"
#import "GameViewController.h"

static const int ballHitCategory = 1;


@interface GameScene ()<SKPhysicsContactDelegate>

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@end

@implementation GameScene




- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // stuff
        
        NSLog(@"Size: %@", NSStringFromCGSize(self.size));
        
        self.backgroundColor = [UIColor blueColor];
        self.physicsWorld.contactDelegate = self;
       // [self.physicsWorld setGravity:CGVectorMake(0, 0)];
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    
}

-(void)startRightToLeftWave{
    
   SKSpriteNode * rightBall = [SKSpriteNode spriteNodeWithImageNamed:@"blueGem.png"];
    rightBall.name=@"rightballs";
    
    rightBall.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:rightBall.frame.size];
    rightBall.physicsBody.categoryBitMask=ballHitCategory;
    rightBall.physicsBody.contactTestBitMask=ballHitCategory;
    rightBall.physicsBody.collisionBitMask=ballHitCategory;
    rightBall.physicsBody.dynamic=YES;
    rightBall.physicsBody.affectedByGravity=NO;
    rightBall.physicsBody.usesPreciseCollisionDetection=YES;

    [self addChild:rightBall];

    
    // Determine where to spawn the monster along the Y axis
    int minY = 150;//self.ball.size.height / 2;
    int maxY = self.frame.size.height - 150;  //max Y should be 718
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    rightBall.position = CGPointMake(self.frame.size.width + rightBall.size.width/2, actualY);
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-rightBall.size.width/2, actualY) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [rightBall runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    
}

-(void)startLeftToRightWave{
    
   SKSpriteNode * leftBall = [SKSpriteNode spriteNodeWithImageNamed:@"pinkGem.png"];
    leftBall.name=@"leftballs";
    leftBall.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:leftBall.frame.size];
    leftBall.physicsBody.categoryBitMask=ballHitCategory;
    leftBall.physicsBody.contactTestBitMask=ballHitCategory;
    leftBall.physicsBody.collisionBitMask=ballHitCategory;
    leftBall.physicsBody.dynamic=YES;
    leftBall.physicsBody.affectedByGravity=NO;
    leftBall.physicsBody.usesPreciseCollisionDetection=YES;
    
    
    [self addChild:leftBall];
    
    
    // Determine where to spawn the monster along the Y axis
    int minY = 150;//self.ball.size.height / 2;
    int maxY = self.frame.size.height - 150;  //max Y should be 718
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    leftBall.position = CGPointMake(leftBall.size.width/2, actualY);
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(leftBall.size.width/2+self.frame.size.width, actualY) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [leftBall runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    
    
    
}

-(void)startSecondWave{
    
}

-(void)startThirdWave{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    NSLog(@"you touched at %@",NSStringFromCGPoint(touchLocation));
    
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
   
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
        
    }
    
    if (timeSinceLast<5) {
        
        //just to check the ball bouncing thing, stopping the balls after some time
        [self updateWithTimeSinceLastUpdate:timeSinceLast];
        
        
    }
    
    [self removeNodesOutOfScreen];
    
}


-(void)didBeginContact:(SKPhysicsContact *)contact
{
    
  SKSpriteNode * leftBall = (SKSpriteNode*)contact.bodyA.node;
  SKSpriteNode *  rightBall = (SKSpriteNode *)contact.bodyB.node;
    
    if(leftBall.physicsBody .categoryBitMask == ballHitCategory ||  rightBall.physicsBody.categoryBitMask == ballHitCategory)
    {
        
        NSLog(@"collision");
        
        leftBall.physicsBody.affectedByGravity=YES;
        rightBall.physicsBody.affectedByGravity=YES;
      
       // leftBall.physicsBody.velocity=CGVectorMake(1.0, 8.0);
        
        [self addCrashParticleNode:leftBall.position betweeenNodesFirst:leftBall secondNode:rightBall];
        
        leftBall=nil;
        rightBall=nil;
        
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
    
    [self bounceTheBalls:firstNode secondBall:secondNode];
    
    //uncomment the remove lines for bounce testing
//    [firstNode removeFromParent];
//    [secondNode removeFromParent];
//    
//    firstNode=nil;
//    secondNode=nil;
    
    

}



-(void)bounceTheBalls:(SKSpriteNode *) ball1 secondBall:(SKSpriteNode *)ball2{
    
    GLKVector2 velocity = GLKVector2Make(ball1.physicsBody.velocity.dx, ball1.physicsBody.velocity.dy);
    GLKVector2 direction = GLKVector2Normalize(velocity);
    GLKVector2 newVelocity = GLKVector2MultiplyScalar(direction, 2);

    GLKVector2 velocity2 = GLKVector2Make(ball2.physicsBody.velocity.dx, ball2.physicsBody.velocity.dy);
    GLKVector2 direction2 = GLKVector2Normalize(velocity2);
    GLKVector2 newVelocity2 = GLKVector2MultiplyScalar(direction2, 2);

    ball1.physicsBody.velocity = CGVectorMake(newVelocity.x,newVelocity.y);
    ball2.physicsBody.velocity=CGVectorMake(newVelocity2.x,newVelocity2.y);
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

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    NSLog(@"child count is %lu",(unsigned long)self.children.count);
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self startRightToLeftWave];
        [self startLeftToRightWave];
    }
}



@end
