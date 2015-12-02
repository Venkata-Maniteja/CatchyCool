//
//  GameScene.m
//  CatchyCool
//
//  Created by Venkata Maniteja on 2015-11-30.
//  Copyright (c) 2015 Venkata Maniteja. All rights reserved.
//

#import "GameScene.h"
#import "GameViewController.h"

static const int blueBallHitCategory = 1<<0;
static const int wallHitCategory = 1<<1;
static const int pinkBallHitCategory= 1<<2;


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
        self.physicsBody=[SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(self.frame.origin.x, self.frame.origin.y+100, self.frame.size.width, self.frame.size.height-200)];   //to make balls bounce
        self.physicsBody.categoryBitMask=wallHitCategory;
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    [self bounceTheBlueBallAtPoint:CGPointMake(100, 200)];
    //[self bounceThePinkBall];
    [self bounceTheBlueBallAtPoint:CGPointMake(300, 100)];
    
    
}

-(void)bounceTheBlueBallAtPoint:(CGPoint)point{
    
    
    SKSpriteNode * blueBall = [SKSpriteNode spriteNodeWithImageNamed:@"blueGem.png"];
    blueBall.name=@"rightballs";
    
    blueBall.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:blueBall.frame.size.width/2];
    
    
    blueBall.physicsBody.categoryBitMask=blueBallHitCategory;
    blueBall.physicsBody.collisionBitMask=blueBallHitCategory|pinkBallHitCategory|wallHitCategory;
    blueBall.physicsBody.contactTestBitMask=blueBallHitCategory|pinkBallHitCategory|wallHitCategory;
    
    blueBall.physicsBody.dynamic=YES;
    blueBall.physicsBody.affectedByGravity=NO;
    blueBall.physicsBody.restitution=1.0;
    blueBall.physicsBody.friction=0.0;
    blueBall.physicsBody.linearDamping=0.0;
    blueBall.physicsBody.angularDamping=0.0;
    
    blueBall.position=point;
    
    [self addChild:blueBall];
    
    
   
    //applying impulse to bounce off
    CGVector impulse = CGVectorMake(30.0,60.0);
    [blueBall.physicsBody applyImpulse:impulse];
    
    

    
    
}

-(void)bounceThePinkBall{
    
    
    SKSpriteNode * pinkBall = [SKSpriteNode spriteNodeWithImageNamed:@"pinkGem.png"];
    pinkBall.name=@"rightballs";
    
    pinkBall.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:pinkBall.frame.size.width/2];
    
    
    pinkBall.physicsBody.categoryBitMask=pinkBallHitCategory;
    pinkBall.physicsBody.collisionBitMask=pinkBallHitCategory|blueBallHitCategory|wallHitCategory;
    pinkBall.physicsBody.contactTestBitMask=pinkBallHitCategory|blueBallHitCategory|wallHitCategory;
    
    pinkBall.physicsBody.dynamic=YES;
    pinkBall.physicsBody.affectedByGravity=NO;
    pinkBall.physicsBody.restitution=1.0;
    pinkBall.physicsBody.friction=0.0;
    pinkBall.physicsBody.linearDamping=0.0;     //<1.0
    pinkBall.physicsBody.angularDamping=0.0;  //<1.0
    
    pinkBall.position=CGPointMake(200, 200);
    
    [self addChild:pinkBall];
    
    
    
    //applying impulse to bounce off
    CGVector impulse = CGVectorMake(60.0,30.0);
    [pinkBall.physicsBody applyImpulse:impulse];
    
    
    
    
    
}

-(void)startRightToLeftWave{
    
   SKSpriteNode * blueBall = [SKSpriteNode spriteNodeWithImageNamed:@"blueGem.png"];
    blueBall.name=@"rightballs";
    
    blueBall.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:blueBall.frame.size];
    
    blueBall.physicsBody.categoryBitMask=blueBallHitCategory;
    blueBall.physicsBody.contactTestBitMask=blueBallHitCategory|wallHitCategory|pinkBallHitCategory;
    blueBall.physicsBody.collisionBitMask=blueBallHitCategory|pinkBallHitCategory|wallHitCategory;
    blueBall.physicsBody.dynamic=YES;
    blueBall.physicsBody.affectedByGravity=NO;
    blueBall.physicsBody.usesPreciseCollisionDetection=YES;
  
    [self addChild:blueBall];

    
    // Determine where to spawn the monster along the Y axis
    int minY = 150;//self.ball.size.height / 2;
    int maxY = self.frame.size.height - 150;  //max Y should be 718
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    blueBall.position = CGPointMake(self.frame.size.width + blueBall.size.width/2, actualY);
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-blueBall.size.width/2, actualY) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [blueBall runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    
    
}

-(void)startLeftToRightWave{
    
   SKSpriteNode * pinkBall = [SKSpriteNode spriteNodeWithImageNamed:@"pinkGem.png"];
    pinkBall.name=@"leftballs";
    pinkBall.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:pinkBall.frame.size];
    
    pinkBall.physicsBody.categoryBitMask=pinkBallHitCategory;
    pinkBall.physicsBody.contactTestBitMask=pinkBallHitCategory|blueBallHitCategory|wallHitCategory;
    pinkBall.physicsBody.collisionBitMask=pinkBallHitCategory|blueBallHitCategory|wallHitCategory;
    pinkBall.physicsBody.dynamic=YES;
    pinkBall.physicsBody.affectedByGravity=NO;
    pinkBall.physicsBody.usesPreciseCollisionDetection=YES;
    
    pinkBall.position=CGPointMake(20, 20);
    [self addChild:pinkBall];
    
    
    // Determine where to spawn the monster along the Y axis
    int minY = 150;//self.ball.size.height / 2;
    int maxY = self.frame.size.height - 150;  //max Y should be 718
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    pinkBall.position = CGPointMake(pinkBall.size.width/2, actualY);
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(pinkBall.size.width/2+self.frame.size.width, actualY) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [pinkBall runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    
    
    
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

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    NSLog(@"child count is %lu",(unsigned long)self.children.count);
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
       // [self startRightToLeftWave];
        //[self startLeftToRightWave];
    }
}



@end
