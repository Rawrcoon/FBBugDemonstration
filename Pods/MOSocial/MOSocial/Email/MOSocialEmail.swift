//
//  MOSocialEmail.swift
//  MOSocialTests
//
//  Created by Mark Oelsner on 09/07/15.
//  Copyright (c) 2015 Mark Oelsner. All rights reserved.
//

import Foundation
import MessageUI

public class MOSocialEmail : NSObject, MFMailComposeViewControllerDelegate
{
//    -(void)sendEmailWithSubject:(NSString*)subject Body:(NSString*)body Link:(NSString*)link Recipents:(NSArray*)recipents Image:(UIImage*)image Success:(void (^)())success Fail:(void (^)())fail
    
    var shareViewController :UIViewController?
    
    var mailController = MFMailComposeViewController()
    var mailSuccess :(() -> Void)?
    var mailFail :(() -> Void)?
    
    public init(shareViewController :UIViewController)
    {
        self.shareViewController = shareViewController
    }
    
    public func sendEmail(subject :String, body :String, link :String, recipents: [String],image :UIImage?, success:() -> Void, fail:() -> Void)
    {
        mailSuccess = success
        mailFail = fail
        
        if MFMailComposeViewController.canSendMail() == true
        {
            mailController.mailComposeDelegate = self
            mailController.setSubject(subject)
            mailController.setMessageBody(body + "\n\n" + link, isHTML: false)
            mailController.setToRecipients(recipents)
            
            if let img = image
            {
                var imageData :NSData = UIImagePNGRepresentation(img)
                mailController.addAttachmentData(imageData, mimeType: "image/png", fileName: "Image.png")
            }
            
            shareViewController?.presentViewController(mailController, animated: true, completion: nil)
        }
    }

    public func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        if error == nil
        {
            
        }
        else
        {
            if result.value == MFMailComposeResultSent.value
            {
                if let success = mailSuccess
                {
                    success()
                }
            }
            else if (result.value == MFMailComposeResultCancelled.value || result.value == MFMailComposeResultSaved.value)
            {
                
            }
            else if result.value == MFMailComposeResultFailed.value
            {
                if let fail = mailFail
                {
                    fail()
                }
            }
        }
        
        controller.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}