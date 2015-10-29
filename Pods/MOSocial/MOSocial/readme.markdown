MOSocial Guide
=====================

__Developer: Mark Oelsner__

work in progress

This is a beta build - I will change some function names and parameters in the future
Use this version only if the old framework doesn’t compile in your project.

Some Facebook features only work if the Facebook App is installed on the device, if you get fails and don't know the cause, this might be the issue'

__Some examples:__

Login:

        MOSocialFacebook().login({ () -> Void in
            println("Facebook login success")
            self.performSegueWithIdentifier("showFeatureTests", sender: self)
            }, fail: { () -> Void in
                println("Facebook login fail")
        })



Share a link:

	MOSocialFacebook(shareViewController: self).shareLink(NSURL(string: "http://	mobivention.com/")!, success: { () -> Void in
 	           
 	       }) { () -> Void in
  	          
  	      }


------------------

