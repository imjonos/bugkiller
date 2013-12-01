//
//  HelloWorldLayer.m
//  BugKiller
//
//  Created by NOs on 07.07.13.
//  Copyright NOs 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer
CCSprite *taracan;
// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
    [layer setTouchEnabled : YES];

   
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	
    //if ((self = [super initWithColor:cc4(0, 255, 0, 255)])){
    
    
    if( (self=[super init]) ) {
        
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
        [self addChild:colorLayer z:0];
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// create and initialize a Label
		//CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director for the window size
		
		// position the label on the center of the screen
		//label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		//[self addChild: label];
		 //CCSprite
		taracan = [CCSprite spriteWithFile:@"tarakan.jpg"];
        taracan.position =  ccp( size.width /2 , 0 );
        [self addChild:taracan z:100];
        [self schedule:@selector(nextFrame:)];
        
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// to avoid a retain-cycle with the menuitem and blocks
		__block id copy_self = self;
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}];
		
		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}];

		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		//[self addChild:menu];

	}
    [self setTouchEnabled : YES];
    //self.isTouchEnabled = YES;
	return self;
}

-(void)onEnter
{
    [super onEnter];
    
    [self setTouchEnabled : YES];
}

- (void) nextFrame:(ccTime)dt {
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    taracan.position = ccp( taracan.position.x , taracan.position.y + 100*dt );
    if (taracan.position.y > size.height + 50) {
    [self taracan];
    }
}

-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch");
     CGSize size = [[CCDirector sharedDirector] winSize];
    CGPoint location = [self convertTouchToNodeSpace: touch];
     
        if (CGRectContainsPoint(taracan.boundingBox, location))
        {
            [self taracan];
            [self BamOnX:location.x andY:location.y];
            return YES;
        }
    
    
    return NO;
}


-(void) taracan
{
	int r = arc4random() % 1000;
    taracan.position =  ccp( r, -70);
}
-(CGPoint) locationFromTouch:(UITouch*)touch
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(void) BamOnX:(int) x andY:(int) y
{
    CCSprite* blood = [CCSprite spriteWithFile:@"blood.jpg"];
    blood.position =  ccp( x , y );
    [self addChild:blood];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
