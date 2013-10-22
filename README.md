blnetworking
============

BLNetworking is a set of modifications to AFNetworking 2.0.  iOS 7 Required.  Install AFNetworking via cocoapod.  

========
PREINSTALL
========

If you do not have Cocoapods installed, do so now.  If you have an old copy installed, run "pod update" in the terminal.  

=========
INSTALLATION
========

1. Create a new project in XCode, and save the project to disk.

2. Quit XCode

3. Using Finder, or Terminal, create a suitable directory structure on disk to keep BLNetworking, CocoaPods, and your own code separate.  I recommend making a directory parallel to the Project and ProjectTests directories called ThirdParty.  I typically make my cocoapods install parallel to the Project and ProjectTests directories.  It's up to you, just remember the path to your BLNetworking directory.

4. Create a Podfile requiring iOS 7 and AFNetworking.  Save it to directory where you want the Pods directory to be created.  Run "pod install"

5. cd to your BLNetworking location and run "git clone https://github.com/bokojo/blnetworking"

6. Confirm that a new directory "blnetworking" exists on disk in your current location.

7. Run XCode and open the Project.xcworkspace. (IMPORTANT: It wont be the Recently Opened Project.xcproj.  Use the workspace.) 

8. Add the BLNetworking.xcproj (NOT BLNetworking.xcworkspace) to your workspace by going to File -> Add Files to Project.  I usually drag it above the Pods project.  

9. Now we need to add the header search path to your main project.  Click on the top Project icon in the XCode file manager, select Build Settings from the top menu bar of the editor panel, and search for User Header Search Path.  This should be empty in a new project.

10. Select the empty field and add two records: $(inherited) and $(SRCROOT)/_YOUR_BLNETWORK_LOCATION

11. Be sure that your values now appear in the settings list once you click off the field editor.

12. Create your very own BLAPIController subclass, and enjoy the ease and flexibility of building API support into apps with ease.
