//
//  MOSocialFacebook.swift
//  MOSocialTests
//
//  Created by Mark Oelsner on 09/07/15.
//  Copyright (c) 2015 Mark Oelsner. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

public class MOSocialFacebookUser :NSObject
{
    var facebook_id :String?
    var name :String?
    var score :NSNumber?
    var application :String?
    var type :String?
    
    public override init() {
        
    }
    
    public init(name :String?, score: Int?, application :String?, type: String?) {
        self.name = name
        self.score = score
        self.application = application
        self.type = type
    }
}


public class MOSocialFacebook :NSObject, FBSDKLoginButtonDelegate, FBSDKSharingDelegate, FBSDKAppInviteDialogDelegate, FBSDKGameRequestDialogDelegate
{
    var facebookSuccess :(() -> Void)?
    var facebookFail :(() -> Void)?
    
    var presenter :UIViewController?
    
    static let sharedInstance = MOSocialFacebook()
    
    public init(shareViewController :UIViewController)
    {
        presenter = shareViewController
    }
    
    //#MARK: - Login
    
    public override init() {
        
    }
    
    public func loginButton(success:() -> Void, fail:() -> Void) -> FBSDKLoginButton
    {
        facebookSuccess = success;
        facebookFail = fail;
        
        var loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile"]
        loginButton.delegate = self
        
        return loginButton
    }
    
    public func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let success = facebookSuccess
        {
            success()
        }
    }
    
    public func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        if let fail = facebookFail
        {
            fail()
        }
    }
    
    public func login(success:() -> Void, fail:() -> Void)
    {
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil && FBSDKProfile.currentProfile() != nil)
        {
            success()
        }
        else
        {
            facebookSuccess = success
            facebookFail = fail
            
            var login = FBSDKLoginManager()
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated:", name:FBSDKProfileDidChangeNotification, object: nil)
            
            login .logInWithReadPermissions(["public_profile"], handler: { (result, error) -> Void in
                if error != nil
                {
                    fail()
                }
                else if result.isCancelled
                {
                    
                }
                else
                {
                    
                }
                
            })
        }
    }
    
    func onProfileUpdated(notification: NSNotification)
    {
        NSLog("TEST")
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        if let success = facebookSuccess
        {
            // cleanup shared instance
            facebookSuccess = nil
            facebookFail = nil
            
            success()
        }
    }
    
    public func logout()
    {
        if FBSDKAccessToken.currentAccessToken() != nil
        {
            var login = FBSDKLoginManager()
            login.logOut()
            //            if let success = facebookSuccess
            //            {
            //                success()
            //            }
        }
    }
    
    public func loginWithReadPersmission(readPermission :String, success:() -> Void, fail:() -> Void)
    {
        if FBSDKAccessToken.currentAccessToken().hasGranted(readPermission)
        {
            //            if let success = facebookSuccess
            //            {
            success()
            //            }
        }
        else
        {
            var loginManager = FBSDKLoginManager()
            loginManager.logInWithReadPermissions([readPermission], handler: { (result, error) -> Void in
                if error != nil
                {
                    //                    if let fail = self.facebookFail
                    //                    {
                    fail()
                    //                    }
                }
                else
                {
                    //                    if let success = self.facebookSuccess
                    //                    {
                    success()
                    //                    }
                }
            })
        }
    }
    
    public func loginWithPublishPermission(publishPersmission :String, success:() -> Void, fail:() -> Void)
    {
        if FBSDKAccessToken.currentAccessToken().hasGranted(publishPersmission)
        {
            //            if let success = self.facebookSuccess
            //            {
            success()
            //            }
        }
        else
        {
            var loginManager = FBSDKLoginManager()
            loginManager.logInWithPublishPermissions([publishPersmission], handler: { (result, error) -> Void in
                if error != nil
                {
                    //                    if let fail = self.facebookFail
                    //                    {
                    fail()
                    //                    }
                }
                else
                {
                    //                    if let success = self.facebookSuccess
                    //                    {
                    success()
                    //                    }
                }
            })
        }
    }
    
    // MARK: Share
    
    func shareContent(content :FBSDKSharingContent)
    {
        if let vc = presenter
        {
            FBSDKShareDialog.showFromViewController(vc, withContent: content, delegate: self)
        }
    }
    
    public func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        if let fail = facebookFail
        {
            fail()
        }
    }
    
    public func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        if let success = facebookSuccess
        {
            success()
        }
    }
    
    public func sharerDidCancel(sharer: FBSDKSharing!) {
        
    }
    
    // MARK: Like Button
    
    public func likeButtonWithObjectID(objectID :String) -> FBSDKLikeControl
    {
        var likeButton = FBSDKLikeControl()
        likeButton.objectID = objectID
        return likeButton
    }
    
    public func likeButton() -> FBSDKLikeControl
    {
        var likeButton = self.likeButtonWithObjectID("https://www.facebook.com/mobivention")
        return likeButton
    }
    
    // MARK: Share Button
    
    public func shareButtonWithContent(shareContent :FBSDKSharingContent) -> FBSDKShareButton
    {
        var button = FBSDKShareButton()
        button.shareContent = shareContent
        return button
    }
    
    // MARK: Send Button
    
    public func sendButtonWithContent(shareContent :FBSDKSharingContent) -> FBSDKSendButton
    {
        var button = FBSDKSendButton()
        button.shareContent = shareContent
        return button
    }
    
    // MARK: Like Links
    
    func createLinkContentWithURL(shareURL :NSURL) -> FBSDKShareLinkContent
    {
        var content = FBSDKShareLinkContent()
        content.contentURL = shareURL
        return content
    }
    
    public func shareLink(shareURL :NSURL, success:() -> Void, fail:() -> Void)
    {
        facebookSuccess = success
        facebookFail = fail
        
        var content = self.createLinkContentWithURL(shareURL)
        self.shareContent(content)
    }
    
    // MARK: Photos
    
    func createPhotoContent(shareImages :[UIImage], userGenerated: Bool) -> FBSDKSharePhotoContent
    {
        var fbSharePhotos = NSMutableArray()
        
        for shareImage :UIImage in shareImages
        {
            var photo = FBSDKSharePhoto()
            photo.image = shareImage
            photo.userGenerated = userGenerated
            fbSharePhotos.addObject(photo)
        }
        
        
        var content = FBSDKSharePhotoContent()
        content.photos = fbSharePhotos as [AnyObject]
        
        return content
    }
    
    public func shareImage(shareImage :UIImage, userGenerated :Bool, success:() -> Void, fail:() -> Void)
    {
        facebookSuccess = success
        facebookFail = fail
        
        var content = self.createPhotoContent([shareImage], userGenerated: userGenerated)
        self.shareContent(content)
    }
    
    public func shareImages(shareImages :[UIImage], userGenerated :Bool, success:() -> Void, fail:() -> Void)
    {
        facebookSuccess = success
        facebookFail = fail
        
        var content = self.createPhotoContent(shareImages, userGenerated: userGenerated)
        self.shareContent(content)
    }
    
    // MARK: Videos
    
    func createVideoContentWithVideoAssetURL(videoAssetURL :NSURL) -> FBSDKShareVideoContent
    {
        var video = FBSDKShareVideo()
        video.videoURL = videoAssetURL
        
        var content = FBSDKShareVideoContent()
        content.video = video
        
        return content
    }
    
    public func shareVideoWithAssetURL(videoAssetURL :NSURL, success:() -> Void, fail:() -> Void)
    {
        facebookSuccess = success
        facebookFail = fail
        
        var content = self.createVideoContentWithVideoAssetURL(videoAssetURL)
        self.shareContent(content)
    }
    
    // MARK: Open Graph Stories
    
    // Graph stories are not so easy, you probably want to share them without using MOSocial. Facebook provides a code generator for your custom objects
    public func shareGraphStory(graphAction :FBSDKShareOpenGraphAction, previewPropertyName :String)
    {
        var content = FBSDKShareOpenGraphContent()
        content.action = graphAction;
        
        content.previewPropertyName = previewPropertyName
        
        self.shareContent(content)
    }
    
    // MARK: Additional Facebook Features
    
    // MARK: Profile
    
    public func currentProfile() -> FBSDKProfile
    {
        var currentProfile = FBSDKProfile.currentProfile()
        return currentProfile
    }
    
    public func currentProfilePicture() -> FBSDKProfilePictureView
    {
        var profilePicture = FBSDKProfilePictureView()
        
        var currentProfile = self.currentProfile()
        profilePicture.profileID = currentProfile.userID
        profilePicture.pictureMode = FBSDKProfilePictureMode.Square
        return profilePicture
    }
    
    public func profilePictureForID(profileID :String) -> FBSDKProfilePictureView
    {
        var profilePicture = FBSDKProfilePictureView()
        profilePicture.profileID = profileID
        profilePicture.pictureMode = FBSDKProfilePictureMode.Square
        return profilePicture
    }
    
    // MARK: App Invites / App Links
    
    public func inviteFriends(appLinkURL :NSURL?, previewImageURL :NSURL?, success:() -> Void, fail:() -> Void)
    {
        facebookSuccess = success
        facebookFail = fail
        
        var content = FBSDKAppInviteContent()
        content.appLinkURL = appLinkURL
        //        content.appInvitePreviewImageURL = previewImageURL
        
        FBSDKAppInviteDialog.showWithContent(content, delegate: self)
    }
    
    public func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        if let success = facebookSuccess
        {
            success()
        }
    }
    
    public func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        if let fail = facebookFail
        {
            fail()
        }
    }
    
    // MARK: Scores and Achievements
    
    public func shareAchievement(urlString :String, success:() -> Void, fail:() -> Void)
    {
        var achievementsParams = NSMutableDictionary(object: urlString, forKey: "achievement")
        
        if FBSDKAccessToken.currentAccessToken().hasGranted("publish_actions") == true
        {
            var request = FBSDKGraphRequest(graphPath: "/me/achievements", parameters: achievementsParams as [NSObject : AnyObject], HTTPMethod: "POST")
            
            request.startWithCompletionHandler({ (connection, result, error) -> Void in
                if error != nil
                {
                    fail()
                }
                else
                {
                    success()
                }
            })
        }
        else
        {
            fail()
        }
    }
    
    public func shareScore(score :Int, success:() -> Void, fail:() -> Void)
    {
        facebookSuccess = success
        facebookFail = fail
        
        var scoreParams = NSMutableDictionary(object: score, forKey: "score")
        
        var request = FBSDKGraphRequest(graphPath: "/me/scores", parameters: scoreParams as [NSObject : AnyObject], HTTPMethod: "POST")
        
        request.startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil
            {
                if let fail = self.facebookFail
                {
                    fail()
                }
            }
            else
            {
                if let success = self.facebookSuccess
                {
                    success()
                }
            }
            
        }
    }
    
    public func userScore(success:(score :Int) -> Void, fail:() -> Void)
    {
        
        var request = FBSDKGraphRequest(graphPath: "/me/scores", parameters:NSDictionary(object: "score", forKey: "fields") as [NSObject : AnyObject], HTTPMethod: "GET")
        
        request.startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil
            {
                fail()
            }
            else
            {
                if let resultdict = result as? NSDictionary
                {
                    var data : NSArray = resultdict.objectForKey("data") as! NSArray
                    
                    if data.count > 0
                    {
                        if let userDict :NSDictionary = data[0] as? NSDictionary
                        {
                            if let user :NSDictionary = userDict["user"] as? NSDictionary
                            {
                                if let userScore :Int = user["score"] as? Int
                                {
                                    success(score: userScore)
                                }
                                else
                                {
                                    success(score: 0)
                                }
                            }
                        }
                    }
                    else
                    {
                        success(score: 0)
                    }
                }
            }
        }
    }
    
    public func friendScores(success:(scores: [MOSocialFacebookUser]) -> Void, fail:() -> Void)
    {
        
        self.loginWithReadPersmission("user_friends", success: { () -> Void in
            var request = FBSDKGraphRequest(graphPath: "/app/scores", parameters: NSDictionary(object: "score", forKey: "fields") as [NSObject : AnyObject], HTTPMethod: "GET")
            request.startWithCompletionHandler { (connection, result, error) -> Void in
                if error != nil
                {
                    fail()
                }
                else
                {
                    var scoreUsers = [MOSocialFacebookUser]()
                    
                    if let resultdict = result as? NSDictionary
                    {
                        if let data : NSArray = resultdict.objectForKey("data") as? NSArray
                        {
                            for userDict in data
                            {
                                if let user :NSDictionary = userDict["user"] as? NSDictionary
                                {
                                    var scoreUser = MOSocialFacebookUser()
                                    scoreUser.name = user["name"] as? String
                                    scoreUser.score = userDict["score"] as? Int
                                    scoreUser.application = user["application"] as? String
                                    scoreUser.type = user["type"] as? String
                                    scoreUser.facebook_id = user["id"] as? String
                                    
                                    if let name = scoreUser.name, fbScore = scoreUser.score
                                    {
                                        NSLog("%@", name + " " + fbScore.stringValue)
                                    }
                                    
                                    scoreUsers.append(scoreUser)
                                    
                                }
                            }
                        }
                    }
                    success(scores: scoreUsers)
                }
            }
            }) { () -> Void in
                fail()
        }
        
    }
    
    public func requestDialog (message :String, title :String, success:() -> Void, fail:() -> Void)
    {
        facebookSuccess = success
        facebookFail = fail
        
        var gameRequestContent = FBSDKGameRequestContent()
        gameRequestContent.message = message
        gameRequestContent.title = title
        
        FBSDKGameRequestDialog .showWithContent(gameRequestContent, delegate: self)
    }
    
    public func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        if let success = self.facebookSuccess
        {
            success()
        }
    }
    
    public func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: NSError!) {
        if let fail = self.facebookFail
        {
            fail()
        }
    }
    
    public func gameRequestDialogDidCancel(gameRequestDialog: FBSDKGameRequestDialog!) {
        
    }
    
    // pick friends is not available atm - in future versions you might need to build a custom UI for this
    
}
