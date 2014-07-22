//
//  AR_ViewController.m
//  AccordianView
//
//

#import "AR_ViewController.h"
#define Yvalueinitial 0
@interface AR_ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewForAccordian;

@property (nonatomic) BOOL isExpanded;
@property (nonatomic) NSUInteger tagOfViewExpanded;

@end

@implementation AR_ViewController
@synthesize scrollViewForAccordian;
@synthesize isExpanded;
@synthesize tagOfViewExpanded;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self settingDifferentDevices];
    
    [self setTableOuter:17];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) settingDifferentDevices
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 480)
    {
        NSLog(@"its 3.5 inch");
        scrollViewForAccordian.frame  = CGRectMake(scrollViewForAccordian.frame.origin.x, scrollViewForAccordian.frame.origin.y, scrollViewForAccordian.frame.size.width, scrollViewForAccordian.frame.size.height-88);
        
    }
    else
    {
        NSLog(@"its 4 inch");
        
        
    }
}
-(void)setTableOuter:(NSUInteger)noOfOuterRows
{
    int yValue=Yvalueinitial;
    for (UIView *views in scrollViewForAccordian.subviews)
    {
        [views removeFromSuperview];
    }
    for (int i=1 ; i<= noOfOuterRows; i++)
    {
        UIView *viewForOutertable = [[UIView alloc]initWithFrame:CGRectMake(0, yValue, 320, 44)];
        viewForOutertable.tag = i;
        UILabel *labelOnOuter = [[UILabel alloc]initWithFrame:CGRectMake(60, 7, 250, 30)];
        labelOnOuter.text = [NSString stringWithFormat:@"Process no: %i", i];
        labelOnOuter.textColor = [UIColor whiteColor];
        
        UIButton *buttonToEnlarge = [[UIButton alloc]initWithFrame:CGRectMake(20, 7, 30 , 30)];
        buttonToEnlarge.tag = i;
        [buttonToEnlarge setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
        
        [buttonToEnlarge setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateSelected];
        [buttonToEnlarge addTarget:self action:@selector(expandButtonTapped:) forControlEvents: UIControlEventTouchUpInside];
        UIImageView *imageViewFOrOuterTable = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        imageViewFOrOuterTable.image = [UIImage imageNamed:@"gray_bar_520X88.png"];
        [viewForOutertable addSubview:imageViewFOrOuterTable];
        [viewForOutertable addSubview:labelOnOuter];
        [viewForOutertable addSubview:buttonToEnlarge];
        [scrollViewForAccordian addSubview:viewForOutertable];
        yValue = yValue+viewForOutertable.frame.size.height;
    }
    [scrollViewForAccordian setContentSize:CGSizeMake(320, yValue)];
}



-(void)setTableInner:(NSUInteger)noOfInnerRows forTag:(NSUInteger)tagForView
{
    float yValue=Yvalueinitial, yValueForSubviews;
    tagOfViewExpanded = tagForView;
    UIView *viewBelowWhichItStarts;
    NSMutableArray *subviewsArray = [scrollViewForAccordian.subviews mutableCopy];
    NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:YES];
    [subviewsArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
    
    for (UIView * subviews in subviewsArray)
    {
        if (subviews.tag == 0 )
        {
            [subviews removeFromSuperview];
        }
        if (subviews.tag ==tagForView )
        {
            viewBelowWhichItStarts = subviews;
            yValueForSubviews=viewBelowWhichItStarts.frame.origin.y+viewBelowWhichItStarts.frame.size.height;
        }
    }
    yValue = viewBelowWhichItStarts.frame.origin.y+44;
    for (int i=0 ; i< noOfInnerRows; i++)
    {
        UIView *viewForInnerTable = [[UIView alloc]initWithFrame:CGRectMake(0, yValue, 320, 44)];
        viewForInnerTable.backgroundColor = [UIColor redColor];
        yValue = yValue+viewForInnerTable.frame.size.height;
        UIImageView *imageViewForInnerTable = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        imageViewForInnerTable.image = [UIImage imageNamed:@"light_gray_bar_with_blue_stripe.png"];
        [viewForInnerTable addSubview:imageViewForInnerTable];
        
        UILabel *labelForInner = [[UILabel alloc]initWithFrame:CGRectMake(50, 7, 200, 30)];
        float i = arc4random_uniform(8);
        labelForInner.text= [NSString stringWithFormat:@"subProcess: %i", (int)i];
        [viewForInnerTable addSubview:labelForInner];
        [scrollViewForAccordian addSubview:viewForInnerTable];
    }
    yValueForSubviews = yValue;
    for (UIView * subviews in subviewsArray)
    {
        if (subviews.tag > tagForView)
        {
            [scrollViewForAccordian bringSubviewToFront:subviews];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            subviews.frame = CGRectMake(0, yValueForSubviews, 320, viewBelowWhichItStarts.frame.size.height);
            [UIView commitAnimations];
            
            
            yValueForSubviews = yValueForSubviews + viewBelowWhichItStarts.frame.size.height;
        }
    }
    [scrollViewForAccordian setContentSize:CGSizeMake(320, yValueForSubviews+2)];
}


-(void)expandButtonTapped:(UIButton *)sender
{
    for (UIView *outerViews in scrollViewForAccordian.subviews)
    {
        if (outerViews.tag >0)
        {
            for (UIView *subviews in outerViews.subviews)
            {
                if ([subviews isMemberOfClass:[UIButton class]])
                {
                    ((UIButton *)subviews).selected = NO;
                }
                if ([subviews isMemberOfClass:[UIImageView class]])
                {
                    ((UIImageView *)subviews).image = [UIImage imageNamed:@"gray_bar_520X88.png"];
                    if (outerViews.tag == sender.tag && !sender.selected)
                    {
                        ((UIImageView *)subviews).image = [UIImage imageNamed:@"gray_bar_520X88_selected.png"];
                    }
                }
            }
        }
    }
    if (!isExpanded) // when NO process tree is already expanded
    {
        isExpanded = YES;
        sender.selected = YES;
        [self setTableInner:sender.tag forTag:sender.tag];
    }
    else // when the process tree is already expanded
    {
        isExpanded =NO;
        if (sender.tag == tagOfViewExpanded)
        {
            sender.selected = NO;
            [self bringUpViews:tagOfViewExpanded];
        }
        else
        {
            sender.selected = YES;
            [self bringUpViews:tagOfViewExpanded];
            [self setTableInner:sender.tag forTag:sender.tag];
            isExpanded = YES;
        }
        
    }
}

-(void)bringUpViews:(NSUInteger)tagForView
{
    UIView *viewBelowWhichItStarts;
    float yValueForSubviews;
    for (UIView * subviews in scrollViewForAccordian.subviews)
    {
        if (subviews.tag == tagForView)
        {
            viewBelowWhichItStarts =subviews;
            yValueForSubviews = viewBelowWhichItStarts.frame.origin.y+44;
        }
        if (subviews.tag > tagForView )
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            subviews.frame = CGRectMake(0, yValueForSubviews, 320, viewBelowWhichItStarts.frame.size.height);
            [UIView commitAnimations];
            yValueForSubviews = yValueForSubviews + viewBelowWhichItStarts.frame.size.height;
        }
    }
    [scrollViewForAccordian setContentSize:CGSizeMake(320, yValueForSubviews)];
    yValueForSubviews = viewBelowWhichItStarts.frame.origin.y;
    [scrollViewForAccordian bringSubviewToFront:viewBelowWhichItStarts];
    float yChek = yValueForSubviews;
    // if needed to remove the previosly cretaed views
    for (UIView * subviews in scrollViewForAccordian.subviews)
    {
        if (subviews.tag == 0)
        {
            if ((subviews.frame.origin.y - yChek) == 44)
            {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                subviews.frame = CGRectMake(0, yValueForSubviews, 320, viewBelowWhichItStarts.frame.size.height);
                [UIView commitAnimations];
                yChek +=44;
                
            }
        }
    }
}


@end
