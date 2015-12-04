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
static NSString * const kRingNodeName = @"movable";

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
    _background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:_background];
    
    
    [self addRing];
}

-(void)addRing{
    
    _ringNode=[SKSpriteNode spriteNodeWithImageNamed:@"hue_ring.png"];
    _ringNode.size=CGSizeMake(80, 80);
    _ringNode.position=CGPointMake(0, 0);
    _ringNode.anchorPoint=CGPointMake(0.5,0.5);
    _ringNode.name=kRingNodeName;
    [_background addChild:_ringNode];
    
    [self bounceTheBlueBallAtPoint:CGPointMake(0, -150)];
    
    
    //    [self bounceThePinkBallAtPoint:CGPointMake(0, 0)];
    
//    [self bounceTheBlueBallAtPoint:[self randomPointGenerator]];

}

-(CGPoint)randomPointGenerator{
    
    int x = arc4random() % (int) self.frame.size.width;
    int y = arc4random() % (int) self.frame.size.height;
    
    return CGPointMake(x, y);
    
}

-(void)bounceTheBlueBallAtPoint:(CGPoint)point{
    
    
    SKSpriteNode * blueBall = [SKSpriteNode spriteNodeWithImageNamed:@"hRedBall.png"];
    blueBall.name=@"leftballs";
    blueBall.size=CGSizeMake(75, 75);
    
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
    
    //blueBall.position=point;
    
    [_background addChild:blueBall];
   
    blueBall.position=point;
    
    
   
    //applying impulse to bounce off
//    CGVector impulse = CGVectorMake(-30.0,-30.0);
//    [blueBall.physicsBody applyImpulse:impulse];
    
    

    
    
}

-(void)bounceThePinkBallAtPoint:(CGPoint)point{
    
    
    SKSpriteNode * pinkBall = [SKSpriteNode spriteNodeWithImageNamed:@"sGreenBall.png"];
    pinkBall.name=@"rightballs";
    pinkBall.size=CGSizeMake(50, 50);
    
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
    
    pinkBall.position=point;
//    [self addChild:pinkBall];
    
    
    
    //applying impulse to bounce off
    CGVector impulse = CGVectorMake(30.0,60.0);
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



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    [self selectNodeForTouch:touchLocation];
    
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    CGPoint previousPosition = [touch previousLocationInNode:self];
    
    CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y); //trying to add 30,30 offset
    
             [self panForTranslation:translation];
    
    NSLog(@"ring position is %@",NSStringFromCGPoint(_ringNode.position));
    
}

- (void)selectNodeForTouch:(CGPoint)touchLocation {
    
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


-(void)checkSpriteMovement{
    
    [self enumerateChildNodesWithName:@"leftballs" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
       
        SKSpriteNode *ball=(SKSpriteNode *)node;
        
        if (ball.physicsBody.resting) {
            
            NSLog(@"The ball position is %@",NSStringFromCGPoint(ball.position));
        }
        
    }];
    
}


@end
