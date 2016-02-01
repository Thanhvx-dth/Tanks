//
//  test.h
//  Unity-iPhone
//
//  Created by 吉岡 篤志 on 12/01/30.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoahManager.h"
#import "Noah_JSON.h"
#import "NoahBannerWallViewController.h"
#import "NoahOfferViewController.h"

typedef enum {
    NoahDeviceOrientationUnknown = -1,
    NoahDeviceOrientationPortrait = 0,
    NoahDeviceOrientationPortraitUpsideDown,
    NoahDeviceOrientationLandscapeLeft,
    NoahDeviceOrientationLandscapeRight,
} NoahDeviceOrientation;

@interface NoahUnityPlugin : NSObject <NoahManagerDelegate, NoahBannerWallViewControllerDelegate, NoahOfferViewControllerDelegate>
{
}
@end

extern UIViewController *UnityGetGLViewController();

extern "C" {
    UIView* NoahRotateView(UIView *view, CGRect rect);
    UIView* NoahRotateView2(UIView *view, CGRect rect, int orientation);
    void NohaAlert_(char *title, char *message);
    char* NoahMakeStringCopy (const char* string);
    char* NoahGetNSTemporaryDirectoryPath_();
    void NoahInitialize_();
    void NoahConnect_(char *consumer_key, char *secret_key);
    void NoahConnect2_(char *consumer_key, char *secret_key, char *action_id);
    void NoahSetGUID_(char *guid);
    void NoahShowBanner_(int type, float x, float y);
    void NoahShowBannerWithTag_(int type, float x, float y, char *tag);
    void NoahSetBannerEffect_(int effect_type);
    void NoahCloseBanner_();
    void NoahOffer_(char *guid, int orientation);
    void NoahOfferWithTag_(char *guid, int orientation, char *tag);
    void NoahCloseOffer_();
    void NoahShop_(char *guid, int orientation);
    void NoahShopWithTag_(char *guid, int orientation, char *tag);
    void NoahCloseShop_();
    void NoahGetPurchased_();
    void NoahCommit_(char *action_id);
    bool NoahGetOfferImage_(int button_num, char *tmpFileName);
    void NoahReview_();
    void NoahReviewWithTag_(char *tag);
    void NoahGetPoint_();
    void NoahUsePoint_(int use_point);
    char* NoahGetVersion_();
    int GetNewRewardNum_();
    void NoahShowNewRewardLabel_(float x, float y);
    void NoahSetNewRewardLabelEffect_(int effect_type);
    bool NoahGetBannerFlag_();
    bool NoahGetOfferFlag_();
    bool NoahGetShopFlag_();
    bool NoahGetReviewFlag_();
    bool NoahGetRewardFlag_();
    bool NoahGetBannerWallFlag_();
    char* NoahGetNoahId_();
    char* NoahGetCheckToken_();
    char* NoahGetAlertMessage_();
    void NoahBackground_();
    void NoahResume_();
    void NoahSetDebugMode_(bool flg);
    bool NoahGetDebugMode_();
    void NoahDeleteUserData_();
    bool NoahHasNewReward_();
    bool NoahHasNewOffer_();
    bool NoahGetNewBadge_(int badge_type, char *tmpFileName);
    void NoahAlert_(char *title, char *message);
    int NoahGetNewRewardNum_();
    void NoahBannerWall_(int orientation);
    void NoahBannerWall2_(int type, bool flg);
    void NoahBannerWallWithTag_(int type, bool flg, char *tag);
    bool NoahGetAdIdFlag_();
    void NoahAdAlert_();
    bool NoahGetBannerWalFlag_();
    bool NoahIsConnecting_();
    int GetRenderScreenWidth_();
    int GetRenderScreenHeight_();
    float NoahGetDisplayScale_();
    char* NoahGetLastErrorMessage_();
    int NoahGetOfferDisplayType_();
}
