//
//  LoadingPage.m
//  D-Light
//
//  Created by Krystel Chaccour on 10/29/15.
//  Copyright © 2015 Krystel Chaccour. All rights reserved.
//

#import "LoadingPage.h"
#import "MainPage.h"
#import "DMAlphaTransition.h"
#import "DessertObject.h"

@interface LoadingPage () <UIViewControllerTransitioningDelegate>
{
    UIImageView *background_img;
}
@property (nonatomic, retain) DMAlphaTransition *alphaTransition;
@property (nonatomic, retain) NSMutableArray *cake_arr, *cupcake_arr, *pie_arr, *fruit_arr;
@property (nonatomic, assign) int number;
@property (nonatomic, strong) RLMNotificationToken *notification;
@end

@implementation LoadingPage


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.number = 0;
    
    background_img = [[UIImageView alloc] init];
    [background_img setTranslatesAutoresizingMaskIntoConstraints:NO];
    [background_img setImage:[UIImage imageNamed:@"Intro-Image"]];
    [background_img setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:background_img];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[background_img]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(background_img)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[background_img]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(background_img)]];
    
    [self.view setBackgroundColor:[ColorTheme d_lightGrey]];
    
    // initialize all arrays used
    
    self.cake_arr = [NSMutableArray array];
    self.cupcake_arr = [NSMutableArray array];
    self.pie_arr = [NSMutableArray array];
    self.fruit_arr = [NSMutableArray array];
    
    [self getCakes];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadInterface];
    });
}

#pragma mark - Interface
#pragma mark
/*
 ** Function that creates and loads the view UI
 */

-(void)loadInterface
{
    CSAnimationView *animate_subviews = [[CSAnimationView alloc] init];
    [animate_subviews setTranslatesAutoresizingMaskIntoConstraints:NO];
    [animate_subviews setType:CSAnimationTypeFadeIn];
    [animate_subviews setDelay:0.1];
    [animate_subviews setDuration:0.3];
    [animate_subviews setUserInteractionEnabled:YES];
    [background_img addSubview:animate_subviews];
    
    UIImageView *logo = [[UIImageView alloc] init];
    [logo setTranslatesAutoresizingMaskIntoConstraints:NO];
    [logo setImage:[UIImage imageNamed:@"Logo"]];
    [logo setContentMode:UIViewContentModeScaleAspectFill];
    [animate_subviews addSubview:logo];
    
    UILabel *loading_label = [[UILabel alloc] init];
    [loading_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [loading_label setText:@"We know you can't wait to get your hands dirty with all these sweets.\n\n\nWe're gathering all the recipes we can find around the web."];
    [loading_label setFont:[FontManager bookFontOfSize:13]];
    [loading_label setNumberOfLines:0];
    [loading_label setLineBreakMode:NSLineBreakByWordWrapping];
    [loading_label setTextAlignment:NSTextAlignmentCenter];
    [loading_label setTextColor:[UIColor whiteColor]];
    [animate_subviews addSubview:loading_label];
  
    UIView *line = [[UIView alloc] init];
    [line setTranslatesAutoresizingMaskIntoConstraints:NO];
    [line setBackgroundColor:[UIColor whiteColor]];
    [line setAlpha:0.7];
    [animate_subviews addSubview:line];
    
    UILabel *waiting_label = [[UILabel alloc] init];
    [waiting_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [waiting_label setText:@"It won't be long now :)"];
    [waiting_label setFont:[FontManager regularLobster:19]];
    [waiting_label setNumberOfLines:0];
    [waiting_label setLineBreakMode:NSLineBreakByWordWrapping];
    [waiting_label setTextAlignment:NSTextAlignmentCenter];
    [waiting_label setTextColor:[UIColor whiteColor]];
    [animate_subviews addSubview:waiting_label];

    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    [indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [animate_subviews addSubview:indicator];

    [indicator startAnimating];
    
    [animate_subviews startCanvasAnimation];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:animate_subviews forKey:@"animate"];
    [dict setObject:background_img forKey:@"view"];
    [dict setObject:logo forKey:@"logo"];
    [dict setObject:loading_label forKey:@"loading"];
    [dict setObject:waiting_label forKey:@"waiting"];
    [dict setObject:line forKey:@"line"];
    [dict setObject:indicator forKey:@"indicator"];
    
    [background_img addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[animate(==view)]-0-|" options:0 metrics:nil views:dict]];
    [background_img addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[animate]-0-|" options:0 metrics:nil views:dict]];

    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[logo]" options:0 metrics:nil views:dict]];
    [animate_subviews addConstraint:[NSLayoutConstraint constraintWithItem:logo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:animate_subviews attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[loading]-30-|" options:0 metrics:nil views:dict]];
    [animate_subviews addConstraint:[NSLayoutConstraint constraintWithItem:loading_label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:animate_subviews attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];

    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[line(60)]" options:0 metrics:nil views:dict]];
    [animate_subviews addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:animate_subviews attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[loading]-25-[line(1)]" options:0 metrics:nil views:dict]];

    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line]-25-[waiting]" options:0 metrics:nil views:dict]];
    [animate_subviews addConstraint:[NSLayoutConstraint constraintWithItem:waiting_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:animate_subviews attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[indicator]-50-|" options:0 metrics:nil views:dict]];
    [animate_subviews addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:animate_subviews attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

}

#pragma mark -  Main Page
#pragma mark

/*
 ** Custom transition animation to Main page
 ** Make sure to set the delegate of the controller to the custom transition
 */
- (IBAction)onScaleTransitionButton:(id)sender {
    self.alphaTransition = [[DMAlphaTransition alloc]init];
    [self presentWithTransition:self.alphaTransition andTag:sender];
}

- (void)presentWithTransition:(id)transition andTag:(id)sender
{
    MainPage *mp = [[MainPage alloc] init];
    mp.result_type = 101;
    mp.cake_arr = [NSMutableArray arrayWithArray:self.cake_arr];
    mp.cupcake_arr = [NSMutableArray arrayWithArray:self.cupcake_arr];
    mp.pie_arr = [NSMutableArray arrayWithArray:self.pie_arr];
    mp.fruit_arr = [NSMutableArray arrayWithArray:self.fruit_arr];
    [mp setTransitioningDelegate:transition];
    [self presentViewController:mp animated:YES completion:nil];
    
}


#pragma mark - Parsing/Retrieval Action
#pragma mark

/*
 ** Function to parse and save the cakes api
 ** TacoShell is a NSURLWrapper library, makes the use of GET/POST calls more clean, and direct
 */
-(void)getCakes
{
    
    TacoShell *ts = [[TacoShell alloc] initWithURL:[NSURL URLWithString:@"https://api.myjson.com/bins/56ru6"]];
    ts.method = BKTSRequestMethodGET;
    ts.contentType = BKTSRequestContentTypeApplicationJSON;
    ts.completionBlock = ^(NSDictionary *dictionary, NSInteger httpResponseStatusCode, id response){
        for (id object in response)
        {
            [self.cake_arr addObject:object];
        }
        
        [self addToDB:self.cake_arr];

        self.number ++;
        [self getCupcakes];
        
    };
    
    [ts start];
}


/*
 ** Function to parse and save the cupcakes api
 */
-(void)getCupcakes
{
    
    TacoShell *ts = [[TacoShell alloc] initWithURL:[NSURL URLWithString:@"https://api.myjson.com/bins/12vri"]];
    ts.method = BKTSRequestMethodGET;
    ts.contentType = BKTSRequestContentTypeApplicationJSON;
    ts.completionBlock = ^(NSDictionary *dictionary, NSInteger httpResponseStatusCode, id response){
        for (id object in response)
        {
            [self.cupcake_arr addObject:object];
        }
        [self addToDB:self.cupcake_arr];
        
        self.number ++;
        [self getPies];
    };
    
    [ts start];
}

/*
 ** Function to parse and save the pie api
 */
-(void)getPies
{
    
    TacoShell *ts = [[TacoShell alloc] initWithURL:[NSURL URLWithString:@"https://api.myjson.com/bins/w8ke"]];
    ts.method = BKTSRequestMethodGET;
    ts.contentType = BKTSRequestContentTypeApplicationJSON;
    ts.completionBlock = ^(NSDictionary *dictionary, NSInteger httpResponseStatusCode, id response){
        for (id object in response)
        {
            [self.pie_arr addObject:object];
        }
        [self addToDB:self.pie_arr];
        
        self.number ++;
        [self getFruit];
    };
    
    [ts start];
}


/*
 ** Function to parse and save the fruit api
 */
-(void)getFruit
{
    
    TacoShell *ts = [[TacoShell alloc] initWithURL:[NSURL URLWithString:@"https://api.myjson.com/bins/3vwc6"]];
    ts.method = BKTSRequestMethodGET;
    ts.contentType = BKTSRequestContentTypeApplicationJSON;
    ts.completionBlock = ^(NSDictionary *dictionary, NSInteger httpResponseStatusCode, id response){
        for (id object in response)
        {
            [self.fruit_arr addObject:object];
        }
        
        self.number ++;
        [self addToDB:self.fruit_arr];
        
        if (self.number == 4)
            [self performSelector:@selector(onScaleTransitionButton:) withObject:nil afterDelay:1.0];
        
    };
    
    [ts start];
}

#pragma mark - Load into DB
#pragma mark


/*
 ** Function to load and save the data parsed into the DB accordingly
 */
- (void)addToDB:(NSArray *)arrayToAdd
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // Import many items in a background thread
    dispatch_async(queue, ^{
        // Get new realm and table since we are in a new thread
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (NSInteger index = 0; index < [arrayToAdd count]; index++) {
            // Add row via dictionary. Order is ignored.
            [DessertObject createInRealm:realm withValue:@{@"dessert_id":[[arrayToAdd objectAtIndex:index] objectForKey:@"id"],
                                                           @"name": [[arrayToAdd objectAtIndex:index] objectForKey:@"name"],
                                                           @"tags": [[arrayToAdd objectAtIndex:index] objectForKey:@"tags"],
                                                           @"desc": [[arrayToAdd objectAtIndex:index] objectForKey:@"description"],
                                                           @"prep_time": [[arrayToAdd objectAtIndex:index] objectForKey:@"prep-time"],
                                                           @"cook_time": [[arrayToAdd objectAtIndex:index] objectForKey:@"cook-time"],
                                                           @"total_time": [[arrayToAdd objectAtIndex:index] objectForKey:@"total-time"],
                                                           @"calories": [[arrayToAdd objectAtIndex:index] objectForKey:@"calories"],
                                                           @"ingredients": [[arrayToAdd objectAtIndex:index] objectForKey:@"ingredients"],
                                                           @"recipe": [[arrayToAdd objectAtIndex:index] objectForKey:@"recipe"],
                                                           @"image": [[arrayToAdd objectAtIndex:index] objectForKey:@"image"],
                                                           @"source": [[arrayToAdd objectAtIndex:index] objectForKey:@"source"]}];
        }
        [realm commitWriteTransaction];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
