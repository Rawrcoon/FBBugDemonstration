//
//  MOSocialTwitter.swift
//  MOSocialTests
//
//  Created by Mark Oelsner on 09/07/15.
//  Copyright (c) 2015 Mark Oelsner. All rights reserved.
//

import Foundation
import Accounts
import Social

class MOSocialTwitter
{
    
    func twitterFollow(twitterName: String, success:() -> Void, fail:() -> Void)
    {
        var accountStore = ACAccountStore()
        var accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted, error) -> Void in
            if granted == true
            {
                var accountsArray = accountStore.accountsWithAccountType(accountType)
                
                if accountsArray.count > 0
                {
                    var twitterAccount : ACAccount = accountsArray[0] as! ACAccount
                    
                    var parameterDict = NSMutableDictionary()
                    parameterDict.setValue(twitterName, forKey: "screen_name")
                    parameterDict.setValue("true", forKey: "follow")
                    
                    var followURL = NSURL(string: "https://api.twitter.com/1/friendships/create.json")
                    
                    var postRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: followURL, parameters: parameterDict as [NSObject : AnyObject])
                    postRequest.account = twitterAccount
                    
                    postRequest.performRequestWithHandler({ (responseData, urlResponse, error) -> Void in
                        if urlResponse.statusCode == 404 || urlResponse.statusCode == 410
                        {
                            println("No twitter user found")
                            fail()
                        }
                        else if(error != nil)
                        {
                            println("Twitter follow error: %@", error.localizedDescription)
                            fail()
                        }
                        else
                        {
                            println("Follow success")
                            success()
                        }
                    })
                }
                else
                {
                    println("No twitter user found")
                    fail()
                }
            }
            else
            {
                println("No twitter user found")
                fail()
            }
        }
    }
}