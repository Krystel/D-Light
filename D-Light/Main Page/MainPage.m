//
//  MainPage.m
//  D-Light
//
//  Created by Krystel Chaccour on 10/29/15.
//  Copyright © 2015 Krystel Chaccour. All rights reserved.
//

#import "MainPage.h"
#import "D_Light-Swift.h"
#import "DessertCell.h"
#import "DessertObject.h"
#import "DetailsPage.h"
#import "DMSlideTransition.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface MainPage () <ScrollPagerDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, UITextFieldDelegate>
{
    UITextField *search_field;
}
@property (nonatomic, retain) UITableView *cake_table, *pie_table, *cupcakes_table, *fruit_table;
@property (nonatomic, retain) NSString *viewType, *searchTextString;
@property (nonatomic, retain) NSMutableArray *desser_arr, *searchArray;
@property (nonatomic, retain) DMSlideTransition *slideTransition;
@property (nonatomic, retain) UISearchController *searchController;


@end

@implementation MainPage
@synthesize cake_table;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[ColorTheme d_lightGrey]];
    
    [self loadInterface];
}

#pragma mark - Interface
#pragma mark

/*
 ** Create and Load the view UI
 */
-(void)loadInterface
{
    UIImageView *header_view = [[UIImageView alloc] init];
    [header_view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [header_view setImage:[UIImage imageNamed:@"Header"]];
    [header_view setContentMode:UIViewContentModeScaleAspectFill];
    [header_view setBackgroundColor:[UIColor clearColor]];
    [header_view setUserInteractionEnabled:YES];
    [self.view addSubview:header_view];
    
    search_field = [[UITextField alloc] init];
    [search_field setTranslatesAutoresizingMaskIntoConstraints:NO];
    [search_field setTextColor:[UIColor whiteColor]];
    [search_field setTextAlignment:NSTextAlignmentLeft];
    [search_field setFont:[FontManager lightFontOfSize:14]];
    [search_field setClearButtonMode:UITextFieldViewModeWhileEditing];
    [search_field setBorderStyle:UITextBorderStyleNone];
    search_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [search_field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [header_view addSubview:search_field];
    
    UIImageView *search_icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [search_icon setImage:[UIImage imageNamed:@"Search-Icon"]];
    search_field.rightViewMode = UITextFieldViewModeUnlessEditing;
    [search_field setRightView:search_icon];
    
    UIView *line = [[UIView alloc] init];
    [line setTranslatesAutoresizingMaskIntoConstraints:NO];
    [line setBackgroundColor:[ColorTheme d_lightGrey]];
    [header_view addSubview:line];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    
    ScrollPager *categories_scroll = [[ScrollPager alloc] init];
    [categories_scroll setTranslatesAutoresizingMaskIntoConstraints:NO];
    [categories_scroll setDelegate:self];
    [categories_scroll setBackgroundColor:[ColorTheme d_lightGrey]];
    [categories_scroll setSelectedFont:[FontManager bookFontOfSize:15]];
    [categories_scroll setFont:[FontManager lightFontOfSize:14]];
    [categories_scroll setSelectedTextColor:[ColorTheme d_purple]];
    [categories_scroll setTextColor:[ColorTheme d_darkGrey]];
    [categories_scroll setIndicatorColor:[ColorTheme d_purple]];
    [categories_scroll setIndicatorHeight:3.0];
    [categories_scroll setIndicatorSizeMatchesTitle:YES];
    categories_scroll.scrollView = scrollView;
    [categories_scroll.scrollView setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:categories_scroll];
    
    cake_table = [[UITableView alloc] init];
    [cake_table setBackgroundColor:[ColorTheme d_lightGrey]];
    [cake_table setDataSource:self];
    [cake_table setDelegate:self];
    [cake_table setShowsHorizontalScrollIndicator:NO];
    [cake_table setShowsVerticalScrollIndicator:NO];
    [cake_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [cake_table setScrollsToTop:YES];
    
    self.cupcakes_table = [[UITableView alloc] init];
    [self.cupcakes_table setBackgroundColor:[ColorTheme d_lightGrey]];
    [self.cupcakes_table setDataSource:self];
    [self.cupcakes_table setDelegate:self];
    [self.cupcakes_table setShowsHorizontalScrollIndicator:NO];
    [self.cupcakes_table setShowsVerticalScrollIndicator:NO];
    [self.cupcakes_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.cupcakes_table setScrollsToTop:YES];
    
    self.pie_table = [[UITableView alloc] init];
    [self.pie_table setBackgroundColor:[ColorTheme d_lightGrey]];
    [self.pie_table setDataSource:self];
    [self.pie_table setDelegate:self];
    [self.pie_table setShowsHorizontalScrollIndicator:NO];
    [self.pie_table setShowsVerticalScrollIndicator:NO];
    [self.pie_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.pie_table setScrollsToTop:YES];
    
    self.fruit_table = [[UITableView alloc] init];
    [self.fruit_table setBackgroundColor:[ColorTheme d_lightGrey]];
    [self.fruit_table setDataSource:self];
    [self.fruit_table setDelegate:self];
    [self.fruit_table setShowsHorizontalScrollIndicator:NO];
    [self.fruit_table setShowsVerticalScrollIndicator:NO];
    [self.fruit_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.fruit_table setScrollsToTop:YES];
    
    cake_table.contentInset = UIEdgeInsetsMake(42,0,0,0);
    self.cupcakes_table.contentInset = UIEdgeInsetsMake(42,0,0,0);
    self.pie_table.contentInset = UIEdgeInsetsMake(42,0,0,0);
    self.fruit_table.contentInset = UIEdgeInsetsMake(42,0,0,0);
    
    [cake_table registerClass:[DessertCell class] forCellReuseIdentifier:@"dessCell"];
    [self.cupcakes_table registerClass:[DessertCell class] forCellReuseIdentifier:@"dessCell"];
    [self.pie_table registerClass:[DessertCell class] forCellReuseIdentifier:@"dessCell"];
    [self.fruit_table registerClass:[DessertCell class] forCellReuseIdentifier:@"dessCell"];
    
    [categories_scroll addSegments:@[@"Cakes", @"Cupcakes", @"Pies", @"Fruit"] views:@[cake_table, self.cupcakes_table, self.pie_table, self.fruit_table]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:header_view forKey:@"header"];
    [dict setObject:search_field forKey:@"sfield"];
    [dict setObject:scrollView forKey:@"scrollview"];
    [dict setObject:categories_scroll forKey:@"catscroll"];
    [dict setObject:self.view forKey:@"view"];
    [dict setObject:line forKey:@"line"];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[header]-0-|" options:0 metrics:nil views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[header]" options:0 metrics:nil views:dict]];
    
    [header_view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[line]-50-|" options:0 metrics:nil views:dict]];
    [header_view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(1)]-15-|" options:0 metrics:nil views:dict]];
    
    [header_view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[sfield]-50-|" options:0 metrics:nil views:dict]];
    [header_view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sfield(>=30)]-20-|" options:0 metrics:nil views:dict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[catscroll(==view)]" options:0 metrics:nil views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[header]-0-[catscroll(40)]" options:0 metrics:nil views:dict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollview]-0-|" options:0 metrics:nil views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[header]-0-[scrollview]-0-|" options:0 metrics:nil views:dict]];
    
    self.viewType = @"cakes";
    
    [cake_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - Table View Delegates
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.viewType isEqualToString:@"cakes"])
        return [self.searchArray count] > 0 ? [self.searchArray count] : [self.cake_arr count];
    else if ([self.viewType isEqualToString:@"cupcakes"])
        return [self.searchArray count] > 0 ? [self.searchArray count] : [self.cupcake_arr count];
    else if ([self.viewType isEqualToString:@"pie"])
        return [self.searchArray count] > 0 ? [self.searchArray count] :  [self.pie_arr count];
    else if ([self.viewType isEqualToString:@"fruit"])
        return [self.searchArray count] > 0 ? [self.searchArray count] : [self.fruit_arr count];
    else
        return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DessertCell *cell = (DessertCell *)[tableView dequeueReusableCellWithIdentifier:@"dessCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ([self.viewType isEqualToString:@"cakes"])
        self.desser_arr = [NSMutableArray arrayWithArray:[self.searchArray count] > 0 ? self.searchArray : self.cake_arr];
    else if ([self.viewType isEqualToString:@"cupcakes"])
        self.desser_arr = [NSMutableArray arrayWithArray:[self.searchArray count] > 0 ? self.searchArray : self.cupcake_arr];
    else if ([self.viewType isEqualToString:@"pie"])
        self.desser_arr = [NSMutableArray arrayWithArray:[self.searchArray count] > 0 ? self.searchArray : self.pie_arr];
    else if ([self.viewType isEqualToString:@"fruit"])
        self.desser_arr = [NSMutableArray arrayWithArray:[self.searchArray count] > 0 ? self.searchArray : self.fruit_arr];
    
    // check if the array is populated from the parsed API or the db
    // when dealing with realm objects, we access its properties in a different way than we do a regular nsdictionary
    if (self.result_type == 101)
    {
        [cell.dessert_title setText:[[self.desser_arr objectAtIndex:indexPath.row] objectForKey:@"name"]];
        [cell.prep_text setText:[[self.desser_arr objectAtIndex:indexPath.row] objectForKey:@"total-time"]];
        [cell.cal_text setText:[[self.desser_arr objectAtIndex:indexPath.row] objectForKey:@"calories"]];
        if ([[self.desser_arr objectAtIndex:indexPath.row] objectForKey:@"image"])
            [cell.dessert_image sd_setImageWithURL:[NSURL URLWithString:[[self.desser_arr objectAtIndex:indexPath.row] objectForKey:@"image"]]
                                  placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    }
    else if (self.result_type == 102)
    {
        DessertObject *dess_object = self.desser_arr[indexPath.row];

        [cell.dessert_title setText:[dess_object name]];
        [cell.prep_text setText:[dess_object total_time]];
        [cell.cal_text setText:[dess_object calories]];
        if ([dess_object image])
            [cell.dessert_image sd_setImageWithURL:[NSURL URLWithString:[dess_object image]]
                                  placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    [self onScaleTransitionButton:indexPath];
}

#pragma mark - Scroll Pager delegate
#pragma mark

/*
 ** Handle the swipe scroller control
 */
-(void)scrollPager:(ScrollPager *)scrollPager changedIndex:(NSInteger)changedIndex
{
    self.searchTextString = @"";
    [search_field setText:self.searchTextString];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    [self.searchArray removeAllObjects];
    
    switch (changedIndex) {
        case 0:
            self.viewType = @"cakes";
            [self.cake_table reloadData];
            [self.cake_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        case 1:
            self.viewType = @"cupcakes";
            [self.cupcakes_table reloadData];
            [self.cupcakes_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        case 2:
            self.viewType = @"pie";
            [self.pie_table reloadData];
            [self.pie_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        case 3:
            self.viewType = @"fruit";
            [self.fruit_table reloadData];
            [self.fruit_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
            
        default:
            break;
    }
}


#pragma mark - Go to Details
#pragma mark
/*
 ** Custom transition animation to Details page
 ** Make sure to set the delegate of the controller to the custom transition
 */

- (void)onScaleTransitionButton:(NSIndexPath *)indexPath {
    self.slideTransition = [[DMSlideTransition alloc]init];
    [self presentWithTransition:self.slideTransition andIndex:indexPath];
}

- (void)presentWithTransition:(id)transition andIndex:(NSIndexPath *)indexP
{
    DetailsPage *details = [[DetailsPage alloc] init];
    if (self.result_type == 101)
        details.info_dict = [NSMutableDictionary dictionaryWithDictionary:[self.desser_arr objectAtIndex:indexP.row]];
    else if (self.result_type == 102)
        details.info_dict = [NSMutableDictionary dictionaryWithObjects:@[[self.desser_arr objectAtIndex:indexP.row]] forKeys:@[@"Dessert"]];
    [details setTransitioningDelegate:transition];
    [self presentViewController:details animated:YES completion:nil];
    
}

#pragma mark - Search Methods
#pragma mark -

-(void)textFieldDidChange:(UITextField*)textField
{
    self.searchTextString = textField.text;
    [self updatesearchArray];
}

/*
 **Update seach method where the textfield acts as seach bar
 */
-(void)updatesearchArray
{
    NSMutableArray *tempArr = [NSMutableArray array];
    
    if ([self.viewType isEqualToString:@"cakes"])
        tempArr = [NSMutableArray arrayWithArray:self.cake_arr];
    else if ([self.viewType isEqualToString:@"cupcakes"])
        tempArr = [NSMutableArray arrayWithArray:self.cupcake_arr];
    else if ([self.viewType isEqualToString:@"pie"])
        tempArr = [NSMutableArray arrayWithArray:self.pie_arr];
    else if ([self.viewType isEqualToString:@"fruit"])
        tempArr = [NSMutableArray arrayWithArray:self.fruit_arr];
    
    
    if (self.searchTextString.length != 0) {
        self.searchArray = [NSMutableArray array];
        
        if (self.result_type == 101)
        {
            for ( NSDictionary* item in tempArr ) {
                
                if ([[[item objectForKey:@"name"] lowercaseString] rangeOfString:[self.searchTextString lowercaseString]].location != NSNotFound || [[[item objectForKey:@"calories"] lowercaseString] rangeOfString:[self.searchTextString lowercaseString]].location != NSNotFound || [[[item objectForKey:@"total-time"] lowercaseString] rangeOfString:[self.searchTextString lowercaseString]].location != NSNotFound) {
                    [self.searchArray addObject:item];
                }
            }
        }
        else if (self.result_type == 102)
        {
            for ( DessertObject *item in tempArr ) {
                
                if ([[item.name lowercaseString] rangeOfString:[self.searchTextString lowercaseString]].location != NSNotFound || [[item.calories lowercaseString] rangeOfString:[self.searchTextString lowercaseString]].location != NSNotFound || [[item.total_time lowercaseString] rangeOfString:[self.searchTextString lowercaseString]].location != NSNotFound) {
                    [self.searchArray addObject:item];
                }
            }

        }
    }
    else
    {
        
        self.searchArray = tempArr;
    }
    
    if ([self.viewType isEqualToString:@"cakes"])
        [self.cake_table reloadData];
    else if ([self.viewType isEqualToString:@"cupcakes"])
        [self.cupcakes_table reloadData];
    else if ([self.viewType isEqualToString:@"pie"])
        [self.pie_table reloadData];
    else if ([self.viewType isEqualToString:@"fruit"])
        [self.fruit_table reloadData];
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
