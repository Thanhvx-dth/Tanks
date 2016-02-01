//
//  NoahUnityPlugin.m
//  Unity-iPhone
//
//  Created by 吉岡 篤志 on 12/01/30.
//  Copyright 2012 SEGA. All rights reserved.
//

#import "NoahUnityPlugin.h"

static NoahUnityPlugin *instance;

@implementation NoahUnityPlugin

- (id)init
{
	self = [super init];
	if(self)
	{
		
	}
	
	return self;
}

+(id)getInstance
{
    @synchronized(self) {
        if(!instance) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

+(id)allocWithZone:(NSZone*)zone
{
    @synchronized(self) {
        if(!instance) {
            instance = [super allocWithZone:zone];
        }
    }
    return instance; 
}

-(id)copyWithZone:(NSZone*)zone
{
    return self;
}

-(id)retain
{
    return self;
}
-(unsigned)retainCount;
{
    return UINT_MAX; 
}
-(oneway void)release
{
    return;
}

-(id)autorelease
{
    return self;
}



- (void)onConnect:(NoahConnectStatusCode)status
{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						[NSString stringWithFormat:@"%d", status], @"result",
						nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];
	
	UnitySendMessage("Noah", "OnConnect", [json UTF8String]);
}

- (void)onCommit:(NoahConnectStatusCode)status :(NSString*)action_id
{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						[NSString stringWithFormat:@"%d", status], @"result",
						action_id, @"action_id",
						nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];
	
	UnitySendMessage("Noah", "OnCommit", [json UTF8String]);
}

- (void)onPurchased:(NoahConnectStatusCode)status :(NSArray*)goods_list
{
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setObject:[NSString stringWithFormat:@"%d", status] forKey:@"result"];
	[dic setObject:[NSString stringWithFormat:@"%d", [goods_list count]] forKey:@"goods_count"];
	for(int i = 0; i < [goods_list count]; i++){
		[dic setObject:[goods_list objectAtIndex:i] forKey:[NSString stringWithFormat:@"goods_id%d", i]];
	}
	
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];
	UnitySendMessage("Noah", "OnPurchased", [json UTF8String]);
}


- (void)onGetPoint:(NoahConnectStatusCode)status :(int)point
{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSString stringWithFormat:@"%d", status], @"result",
						 [NSString stringWithFormat:@"%d", point], @"point",
						 nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];
	
	UnitySendMessage("Noah", "OnGetPoint", [json UTF8String]);
}

- (void)onUsedPoint:(NoahConnectStatusCode)status :(int)point
{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSString stringWithFormat:@"%d", status], @"result",
						 [NSString stringWithFormat:@"%d", point], @"point",
						 nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];
	
	UnitySendMessage("Noah", "OnUsedPoint", [json UTF8String]);
}

- (void)onReview:(NoahConnectStatusCode)status{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSString stringWithFormat:@"%d", status], @"result",
						 nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];
	
	UnitySendMessage("Noah", "OnReview", [json UTF8String]);
}
- (void)onBanner:(NoahConnectStatusCode)status{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSString stringWithFormat:@"%d", status], @"result",
						 nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];
	
	UnitySendMessage("Noah", "OnBannerView", [json UTF8String]);
}

- (void)onOffer:(NoahConnectStatusCode)status{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSString stringWithFormat:@"%d", status], @"result",
						 nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];

	UnitySendMessage("Noah", "OnOffer", [json UTF8String]);
}

- (void)onShop:(NoahConnectStatusCode)status{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSString stringWithFormat:@"%d", status], @"result",
						 nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];

	UnitySendMessage("Noah", "OnShop", [json UTF8String]);
}

- (void)onSetGUID:(NoahConnectStatusCode)status{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSString stringWithFormat:@"%d", status], @"result",
						 nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];
	
	UnitySendMessage("Noah", "OnGUID", [json UTF8String]);	
}

- (void)onDeleteUserData:(NoahConnectStatusCode)status{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSString stringWithFormat:@"%d", status], @"result",
						 nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];
	
	UnitySendMessage("Noah", "OnDelete", [json UTF8String]);
}

- (void)onReward:(NoahConnectStatusCode)status{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSString stringWithFormat:@"%d", status], @"result",
						 nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];

	UnitySendMessage("Noah", "OnRewardView", [json UTF8String]);
}

- (NoahDeviceOrientation)getStatusBarOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    NoahDeviceOrientation noahOrientation;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            noahOrientation = NoahDeviceOrientationPortrait;
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            noahOrientation = NoahDeviceOrientationPortraitUpsideDown;
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            noahOrientation = NoahDeviceOrientationLandscapeRight;
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            noahOrientation = NoahDeviceOrientationLandscapeLeft;
            break;
            
        default:
            noahOrientation = NoahDeviceOrientationUnknown;
            break;
    }
	return noahOrientation;
}

- (void)noahBannerWallViewControllerDidFnish:(NoahBannerWallViewController *)viewController
{
	NoahDeviceOrientation noahOrientation = [[NoahUnityPlugin getInstance] getStatusBarOrientation];
	UnitySendMessage("Noah", "NoahBannerWallViewControllerDidFnish", [[NSString stringWithFormat:@"%d",(int)noahOrientation] UTF8String]);
}

-(void)noahOfferViewControllerFailedWithOption:(NSString *)reason {
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"result", nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];
	UnitySendMessage("Noah", "OnOffer", [json UTF8String]);
}

-(void)noahOfferViewControllerDidDisappear:(NoahOfferViewController*)viewController {
	NSLog(@"noahOfferViewControllerDidDisappear");
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"7", @"result", nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];
	UnitySendMessage("Noah", "OnOffer", [json UTF8String]);


	NoahDeviceOrientation noahOrientation = [[NoahUnityPlugin getInstance] getStatusBarOrientation];
	UnitySendMessage("Noah", "NoahOfferViewControllerDidDisappear", [[NSString stringWithFormat:@"%d",(int)noahOrientation] UTF8String]);
}

-(void)noahOfferViewControllerDidAppear:(NoahOfferViewController*)viewController {
	NSLog(@"noahOfferViewControllerDidAppear");
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"result", nil];
	NSString *json = [Noah_JSON Noah_encodeJSON:dic];
	UnitySendMessage("Noah", "OnOffer", [json UTF8String]);
}

@end


UIView* NoahRotateView(UIView *view, CGRect rect){
	float x = rect.origin.x;
	float y = rect.origin.y;
	float w = rect.size.width;
	float h = rect.size.height;
	
	CGRect r = [[UIScreen mainScreen] bounds];
	float screenW = r.size.width;
	float screenH = r.size.height;	
	
	float canvas_rotation = 0;
	float transX = 0;
	float transY = 0;
	
	CGAffineTransform affine = CGAffineTransformIdentity;
	switch ([[UIApplication sharedApplication] statusBarOrientation])
	{
		case UIInterfaceOrientationPortrait:{
			canvas_rotation = 0;
			transX = 0;
			transY = 0;
		}break;
			
		case UIInterfaceOrientationPortraitUpsideDown:{
			NSLog(@"UIInterfaceOrientationPortraitUpsideDown");
			canvas_rotation = 180;
			transX = -screenW + w;
			transY = -screenH + h;
		}break;
			
		case UIInterfaceOrientationLandscapeLeft:{
			NSLog(@"UIInterfaceOrientationLandscapeLeft");
			canvas_rotation = 270;
			transX = -screenH + w/2 + h/2;
			transY = -screenW + (screenW - w/2) + h/2;
		}break;
			
		case UIInterfaceOrientationLandscapeRight:{
			NSLog(@"UIInterfaceOrientationLandscapeRight");
			canvas_rotation = 90;
			transX = w/2 - h/2;
			transY = -screenW + w/2 + h/2;
		}break;
        default:
            break;
	}
	affine = CGAffineTransformRotate(affine, canvas_rotation * M_PI / 180);
	affine = CGAffineTransformTranslate(affine, transX + x, transY + y);
	[view setTransform:affine];
	NSLog(@"x = %f, y = %f,w = %f, h = %f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
	return view;
}

UIView* NoahRotateView2(UIView *view, CGRect rect, int orientation){
	float canvas_rotation = 0;
	CGAffineTransform affine = CGAffineTransformIdentity;
	
	NSLog(@"orientation = %d", orientation);
	if(orientation == 1){
		switch ([[UIApplication sharedApplication] statusBarOrientation])
		{
			case UIInterfaceOrientationLandscapeLeft:{
				canvas_rotation = 270;
			}break;
				
			case UIInterfaceOrientationLandscapeRight:{
				canvas_rotation = 90;
			}break;
            default:
                break;
		}
	}else{
		switch ([[UIApplication sharedApplication] statusBarOrientation])
		{
			case UIInterfaceOrientationPortrait:{
				canvas_rotation = 0;
			}break;
				
			case UIInterfaceOrientationPortraitUpsideDown:{
				canvas_rotation = 180;
			}break;
            default:
                break;
		}
	}
	affine = CGAffineTransformRotate(affine, canvas_rotation * M_PI / 180);
	[view setTransform:affine];
//	view.frame.origin = CGPointMake(0, 0);
	NSLog(@"x = %f, y = %f,w = %f, h = %f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
	return view;
}


void NoahAlert_(char *title, char *message)
{
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
		UIAlertController *alertController =
			[UIAlertController alertControllerWithTitle:[NSString stringWithUTF8String:title]
												message:[NSString stringWithUTF8String:message]
										 preferredStyle:UIAlertControllerStyleAlert];
		[alertController addAction:[UIAlertAction actionWithTitle:@"OK"
							 style:UIAlertActionStyleDefault
						   handler:nil]];
		[UnityGetGLViewController() presentViewController:alertController animated:YES completion:nil];
	} else {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[NSString stringWithUTF8String:title]
														 message:[NSString stringWithUTF8String:message]
														delegate:NULL 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil] autorelease];
		[alert show];
	}
}

char* NoahMakeStringCopy (const char* string)
{
	if (string == NULL)
		return NULL;
	
	char* res = (char*)malloc(strlen(string) + 1);
	strcpy(res, string);
	return res;
}

char* NoahGetNSTemporaryDirectoryPath_()
{
	NSString *path = NSHomeDirectory();
	NSString *tmpDirectory = [path stringByAppendingPathComponent:@"tmp"];
	return NoahMakeStringCopy([tmpDirectory UTF8String]);
}

void NoahInitialize_()
{
	[[NoahManager sharedManager] setDelegate:[NoahUnityPlugin getInstance]];
}

void NoahConnect_(char *consumer_key, char *secret_key)
{	
	[[NoahManager sharedManager] connect:[NSString stringWithUTF8String:consumer_key]
										:[NSString stringWithUTF8String:secret_key]
										:NoahSupportSDKUnity];
}

void NoahConnect2_(char *consumer_key, char *secret_key, char *action_id)
{	
	[[NoahManager sharedManager] connect:[NSString stringWithUTF8String:consumer_key]
										:[NSString stringWithUTF8String:secret_key]
										:NoahSupportSDKUnity
										:[NSString stringWithUTF8String:action_id]];
}

void NoahAdAlert_() {
    [[NoahManager sharedManager] adAlert];
}

bool NoahGetAdIdFlag_() {
    return [[NoahManager sharedManager] getAdIdFlag];
}

void NoahSetGUID_(char *guid)
{
	[[NoahManager sharedManager] setGUID:[NSString stringWithUTF8String:guid]];
}

void NoahShowBanner_(int type, float x, float y)
{
	[[NoahManager sharedManager] showBanner:UnityGetGLViewController().view
										   :(NoahBannerSize)type
										   :CGPointMake(x, y)];
}

void NoahShowBannerWithTag_(int type, float x, float y, char *tag)
{
    [[NoahManager sharedManager] showBanner:UnityGetGLViewController().view
                                       size:(NoahBannerSize)type
                                   position:CGPointMake(x, y)
                                    withTag:[NSString stringWithUTF8String:tag]];
}

void NoahSetBannerEffect_(int effect_type)
{
	[[NoahManager sharedManager] setBannerEffect:(NoahBannerEffect)effect_type];
}

void NoahCloseBanner_()
{
	[[NoahManager sharedManager] closeBanner];
}

int ConvertOrientationMask(int orientation) {
    UIInterfaceOrientationMask mask;
    if(orientation == 0) {
        mask = UIInterfaceOrientationMaskLandscapeRight;
    } else if(orientation == 1) {
        mask = UIInterfaceOrientationMaskPortrait;
    } else if(orientation == 2) {
        mask = UIInterfaceOrientationMaskLandscapeLeft;
    } else if(orientation == 3) {
        mask = UIInterfaceOrientationMaskPortraitUpsideDown;
    } else if(orientation == 4) {
        mask = UIInterfaceOrientationMaskLandscape;
    } else if(orientation == 5) {
        mask = UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    } else {
        mask = UIInterfaceOrientationMaskAll;
    }
    return mask;
}

UIInterfaceOrientation ConvertOrientation(int orientation) {
    UIInterfaceOrientation converted = UIInterfaceOrientationUnknown;
    if(orientation == 0) {
        converted= UIInterfaceOrientationLandscapeRight;
    } else if(orientation == 1) {
        converted = UIInterfaceOrientationPortrait;
    } else if(orientation == 2) {
        converted = UIInterfaceOrientationLandscapeLeft;
    } else if(orientation == 3) {
        converted = UIInterfaceOrientationPortraitUpsideDown;
    } else if(orientation == 4) {
        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
            converted = UIInterfaceOrientationLandscapeLeft;
        } else {
            converted = UIInterfaceOrientationLandscapeRight;
        }
    } else if(orientation == 5) {
        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            converted = UIInterfaceOrientationPortraitUpsideDown;
        } else {
            converted = UIInterfaceOrientationPortrait;
        }
    }
    return converted;
}

void NoahOffer_(char *guid, int orientation){
    if (orientation < 0 || orientation > 5) {
        return;
    }
    
    NoahOfferType offerType = [[NoahManager sharedManager] openOfferExternal:[NSString stringWithUTF8String:guid]];
    if(offerType == NoahOfferInternal) {
        UIInterfaceOrientation controllerOrientation = ConvertOrientation(orientation);
        UIInterfaceOrientationMask mask = ConvertOrientationMask(orientation);
        NoahOfferViewController *controller = [[[NoahOfferViewController alloc] initWithDelegate:[NoahUnityPlugin getInstance] orientation:controllerOrientation rotatable:mask] autorelease];
        if (controller != nil) {
            [controller setGUID:[NSString stringWithUTF8String:guid]];
            [UnityGetGLViewController() presentViewController:controller animated:YES completion:nil];
        }
    }
}

void NoahOfferWithTag_(char *guid, int orientation, char *tag)
{
    if (orientation < 0 || orientation > 5) {
        return;
    }

    NoahOfferType offerType = [[NoahManager sharedManager] openOfferExternal:[NSString stringWithUTF8String:guid]:[NSString stringWithUTF8String:tag]];
    if(offerType == NoahOfferInternal) {
        UIInterfaceOrientation controllerOrientation = ConvertOrientation(orientation);
        UIInterfaceOrientationMask mask = ConvertOrientationMask(orientation);
        NoahOfferViewController *controller = [[[NoahOfferViewController alloc] initWithDelegate:[NoahUnityPlugin getInstance] orientation:controllerOrientation rotatable:mask] autorelease];
        if (controller != nil) {
            [controller setGUID:[NSString stringWithUTF8String:guid]];
            [controller setTrackingTag:[NSString stringWithUTF8String:tag]];
            [UnityGetGLViewController() presentViewController:controller animated:YES completion:nil];
        }
    }
}

void NoahCloseOffer_()
{
	[[NoahManager sharedManager] closeOffer];
}

void NoahShop_(char *guid, int orientation){
	CGRect rect;
	CGSize size;
	CGRect r = [[UIScreen mainScreen] bounds];
	
	NSLog(@"screen size w = %f, h = %f", r.size.width ,r.size.height);
    // Landscape / ReverseLandscape / SensorLandscape
	if(orientation == 0 || orientation == 2 || orientation == 4){
		rect = CGRectMake(0, 0, r.size.width, r.size.height);
		size = CGSizeMake(r.size.width, r.size.height);
	}else{
		rect = CGRectMake(-(r.size.height - r.size.width) / 2, (r.size.height - r.size.width) / 2, r.size.height, r.size.width);
		size = CGSizeMake(r.size.height, r.size.width);
	}

	[[NoahManager sharedManager] shop:UnityGetGLViewController().view
									 :[NSString stringWithUTF8String:guid]
									 :size];
}

void NoahShopWithTag_(char *guid, int orientation, char *tag)
{
	CGRect rect;
	CGSize size;
	CGRect r = [[UIScreen mainScreen] bounds];
	
	NSLog(@"screen size w = %f, h = %f", r.size.width ,r.size.height);
    // Landscape / ReverseLandscape / SensorLandscape
	if(orientation == 0 || orientation == 2 || orientation == 4){
		rect = CGRectMake(0, 0, r.size.width, r.size.height);
		size = CGSizeMake(r.size.width, r.size.height);
	}else{
		rect = CGRectMake(-(r.size.height - r.size.width) / 2, (r.size.height - r.size.width) / 2, r.size.height, r.size.width);
		size = CGSizeMake(r.size.height, r.size.width);
	}
    
	[[NoahManager sharedManager] shop:UnityGetGLViewController().view
                                 guid:[NSString stringWithUTF8String:guid]
                                 size:size
                                  tag:[NSString stringWithUTF8String:tag]];
}

void NoahCloseShop_()
{
	[[NoahManager sharedManager] closeShop];
}

void NoahGetPurchased_()
{
	[[NoahManager sharedManager] getPurchased];
}

void NoahCommit_(char *action_id)
{
	[[NoahManager sharedManager] commit:[NSString stringWithUTF8String:action_id]];
}


bool NoahGetOfferImage_(int button_num, char *tmpFileName)
{	
    UIImage *image = [[NoahManager sharedManager] getOfferImage:(NoahOfferButton)button_num];
	if(image == nil) return false;
	
    NSData *data = UIImagePNGRepresentation(image); 
	if(data == nil) return false;

	NSString *path = NSHomeDirectory();
	NSString *tmpDirectory = [path stringByAppendingPathComponent:@"tmp"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@" , tmpDirectory, [NSString stringWithUTF8String:tmpFileName]];  	
	
	return ([data writeToFile:filePath atomically:YES] == YES);
}

void NoahReview_()
{
	[[NoahManager sharedManager] review];
}

void NoahReviewWithTag_(char *tag)
{
    [[NoahManager sharedManager] review:[NSString stringWithUTF8String:tag]];
}

void NoahGetPoint_()
{
	[[NoahManager sharedManager] getPoint];
}

void NoahUsePoint_(int use_point)
{
	[[NoahManager sharedManager] usePoint:use_point];
}

char* NoahGetVersion_()
{
	return NoahMakeStringCopy([[[NoahManager sharedManager] getVersion] UTF8String]);
}

int NoahGetNewRewardNum_()
{
	return [[NoahManager sharedManager] getNewRewardNum];
}

void NoahShowNewRewardLabel_(float x, float y)
{
	[[NoahManager sharedManager] showNewRewardLabel:UnityGetGLViewController().view
												   :CGPointMake(x, y)];
}

void NoahSetNewRewardLabelEffect_(int effect_type)
{
	[[NoahManager sharedManager] setNewRewardLabelEffect:(NoahNewRewardEffect)effect_type];
}

bool NoahGetBannerFlag_()
{
	return ([[NoahManager sharedManager] getBannerFlag] == YES);
}

bool NoahGetOfferFlag_()
{
	return ([[NoahManager sharedManager] getOfferFlag] == YES);	
}

bool NoahGetShopFlag_()
{
	return ([[NoahManager sharedManager] getShopFlag] == YES);	
}

bool NoahGetReviewFlag_()
{
	return ([[NoahManager sharedManager] getReviewFlag] == YES);	
}

bool NoahGetRewardFlag_()
{
	return ([[NoahManager sharedManager] getRewardFlag] == YES);	
}

bool NoahGetBannerWallFlag_()
{
    return ([[NoahManager sharedManager] getBannerWallFlag] == YES);
}

char* NoahGetNoahId_()
{
	return NoahMakeStringCopy([[[NoahManager sharedManager] getNoahIdentifier] UTF8String]);
}

char* NoahGetCheckToken_()
{
    return NoahMakeStringCopy([[[NoahManager sharedManager] getValidityCheckToken] UTF8String]);
}

char* NoahGetAlertMessage_()
{
    NSArray *array = [[NoahManager sharedManager] getAlertMessage];
    if(array == nil) {
        return NoahMakeStringCopy([@"[]" UTF8String]);
    }
    NSString *json = @"[";
    for (int i = 0; i < [array count]; i++) {
        if(i == 0) {
            json = [json stringByAppendingString:@"{"];
        } else {
            json = [json stringByAppendingString:@",{"];
        }
        json = [json stringByAppendingFormat:@"\"%@\":\"%@\",", @"title", [[array objectAtIndex:i] objectForKey:@"title"]];
        json = [json stringByAppendingFormat:@"\"%@\":\"%@\",", @"msg", [[array objectAtIndex:i] objectForKey:@"msg"]];
        json = [json stringByAppendingFormat:@"\"%@\":\"%@\"", @"btn", [[array objectAtIndex:i] objectForKey:@"btn"]];
        json = [json stringByAppendingString:@"}"];
    }
    json = [json stringByAppendingString:@"]"];
    NSLog(@"NoahGetAlertMssage_:%@", json);
    return NoahMakeStringCopy([json UTF8String]);
}

void NoahBackground_()
{
    NoahCloseBanner_();
	[[NoahManager sharedManager] background];
}

void NoahResume_()
{
	[[NoahManager sharedManager] resume];
}

void NoahSetDebugMode_(bool flg)
{
	[[NoahManager sharedManager] setDebugMode:flg ? YES : NO];
}

bool NoahGetDebugMode_()
{
	return ([[NoahManager sharedManager] getDebugMode] == YES);
}

void NoahDeleteUserData_()
{
	[[NoahManager sharedManager] deleteUserData];
}

bool NoahHasNewReward_()
{
	return ([[NoahManager sharedManager] hasNewOffer] == YES);
}

bool NoahHasNewOffer_()
{
	return ([[NoahManager sharedManager] hasNewOffer] == YES);
}

void NoahBannerWall_(int orientation)
{
    // Noahのconnectが通っていない場合はnilをかえす
    // Landscape / ReverseLandscape / SensorLandscape
	if(orientation == 0 || orientation == 2 || orientation == 4){
        orientation = 0;
    }
    // Portrait / ReversePortrait / SensorPortrait
    else {
        orientation = 1;
    }
    NoahBannerWallViewController *vc = [[[NoahBannerWallViewController alloc] initWithDelegate:[NoahUnityPlugin getInstance] orientation:(NoahOrientationType)orientation] autorelease];
    if (vc != nil) {
        [UnityGetGLViewController() presentViewController:vc animated:YES completion:nil];
    }
}

void NoahBannerWall2_(int orientation, bool flg)
{
    // NoahRotatableTypeを決める
    NoahRotatableType rotatableType;
    if(flg){
        rotatableType = NoahRotatableAll;
    } else {
        rotatableType = NoahRotatableNever;
    }
    if(orientation == 4){
        rotatableType = NoahRotatablePortrait;
    } else if(orientation == 5) {
        rotatableType = NoahRotatableLandscape;
    }
    // Landscape / ReverseLandscape / SensorLandscape
    if(orientation == 0 || orientation == 2 || orientation == 4){
        orientation = 0;
    }
    // Portrait / ReversePortrait / SensorPortrait
    else {
        orientation = 1;
    }
    NoahBannerWallViewController *vc = [[[NoahBannerWallViewController alloc] initWithDelegate:[NoahUnityPlugin getInstance] orientation:(NoahOrientationType)orientation rotatable:rotatableType] autorelease];
    if (vc != nil) {
        [UnityGetGLViewController() presentViewController:vc animated:YES completion:nil];
    }
}

bool NoahGetBannerWalFlag_()
{
	return ([[NoahManager sharedManager] getBannerWallFlag] == YES);	
}

void NoahBannerWallWithTag_(int orientation, bool flg, char *tag)
{
    NoahRotatableType rotatableType;
    if(flg){
        rotatableType = NoahRotatableAll;
    } else {
        rotatableType = NoahRotatableNever;
    }
    if(orientation == 4) {
        rotatableType = NoahRotatablePortrait;
    } else if(orientation == 5) {
        rotatableType = NoahRotatableLandscape;
    }
    // Landscape / ReverseLandscape / SensorLandscape
	if(orientation == 0 || orientation == 2 || orientation == 4){
        orientation = 0;
    }
    // Portrait / ReversePortrait / SensorPortrait
    else {
        orientation = 1;
    }
    NoahBannerWallViewController *vc = [[[NoahBannerWallViewController alloc] initWithDelegate:[NoahUnityPlugin getInstance] orientation:(NoahOrientationType)orientation rotatable:rotatableType] autorelease];
    [vc setTrackingTag:[NSString stringWithUTF8String:tag]];
    if (vc != nil) {
        [UnityGetGLViewController() presentViewController:vc animated:YES completion:nil];
    }
}

bool NoahGetNewBadge_(int badge_type, char *tmpFileName)
{	
    UIImage *image = [[NoahManager sharedManager] getNewBadge:(NoahBadgeType)badge_type];
	if(image == nil) return false;
	
    NSData *data = UIImagePNGRepresentation(image); 
	if(data == nil) return false;

	NSString *path = NSHomeDirectory();
	NSString *tmpDirectory = [path stringByAppendingPathComponent:@"tmp"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@" , tmpDirectory, [NSString stringWithUTF8String:tmpFileName]];  	
	
	return ([data writeToFile:filePath atomically:YES] == YES);
}

bool NoahIsConnecting_(){
    return [[NoahManager sharedManager] isConnecting];
}

int GetRenderScreenWidth_()
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = [UIScreen mainScreen].scale;
    return (int)(width * scale);
}
int GetRenderScreenHeight_()
{
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    return (int)(height * scale);
}

float NoahGetDisplayScale_() {
    return (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) ? [[UIScreen mainScreen] nativeScale] : [[UIScreen mainScreen]scale];
}
char* NoahGetLastErrorMessage_()
{
    return NoahMakeStringCopy([[[NoahManager sharedManager] getLastErrorMessage] UTF8String]);
}

int NoahGetOfferDisplayType_()
{
    return (int)[[NoahManager sharedManager] getOfferType];
}
