//
//  AppDelegate.swift
//  CutTheCord
//
//  Created by Uli Kusterer on 02/01/16.
//  Copyright © 2016 Uli Kusterer. All rights reserved.
//

import Cocoa
import WebKit


var	myContext = 0


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	@IBOutlet weak var webView: WKWebView!
	@IBOutlet weak var urlsMenu: NSMenu!
	var					pageURLs =	[
										[ "name": "Netflix",	"url": "http://netflix.com" ],
										[ "name": "Twitch",		"url": "http://twitch.tv"],
										[ "name": "YouTube",	"url": "http://youtube.com"]
									]

    deinit {
        webView.removeObserver(self, forKeyPath: "title", context: &myContext)
    }

	func applicationDidFinishLaunching(aNotification: NSNotification) {
//		window.styleMask = /*NSBorderlessWindowMask |*/ NSResizableWindowMask | NSTexturedBackgroundWindowMask
		window.level = Int(CGWindowLevelForKey(CGWindowLevelKey.FloatingWindowLevelKey))

        webView.addObserver(self, forKeyPath: "title", options: .New, context: &myContext)
		
		NSApplication.sharedApplication().presentationOptions = [NSApplicationPresentationOptions.AutoHideDock, NSApplicationPresentationOptions.AutoHideMenuBar]
		
		var		x = 0
		for currURL in pageURLs
		{
			let	itemName = currURL["name"]!
			let newItem = urlsMenu.addItemWithTitle( itemName, action: "takeURLIndexFromTag:", keyEquivalent: "" )
			newItem!.tag = x
			
			x += 1
		}
		
		var	recentURLString = NSUserDefaults.standardUserDefaults().objectForKey("ULICutTheCordMostRecentURLString") as? String
		if recentURLString == nil
		{
			recentURLString = pageURLs[0]["url"]
		}
		let	osVersion = NSProcessInfo.processInfo().operatingSystemVersion
		webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X \(osVersion.majorVersion)_\(osVersion.minorVersion)_\(osVersion.patchVersion)) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9"
		let	pageURL = NSURL(string: recentURLString!)
		webView.loadRequest( NSURLRequest( URL: pageURL! ) )
	}
	
	func applicationWillTerminate(notification: NSNotification) {
		if let currURL = webView.URL
		{
			NSUserDefaults.standardUserDefaults().setObject( currURL.absoluteString, forKey: "ULICutTheCordMostRecentURLString")
		}
	}
	
	func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool
	{
		return true
	}
	
	@IBAction func takeURLIndexFromTag( sender: NSMenuItem? ) {
		let	pageURL = NSURL(string: pageURLs[sender!.tag]["url"]!)
		webView.loadRequest( NSURLRequest( URL: pageURL! ) )
	}
	
	@IBAction func placeWindowInLowerLeft( sender : AnyObject? ) {
		var	box : NSRect = window.frame
		box = NSScreen.screens()![0].frame
		box.size.width /= 4.0
		box.size.height /= 4.0
		window.setFrame( box, display: true )
	}
	
	@IBAction func placeWindowInLowerRight( sender : AnyObject? ) {
		var	box : NSRect = window.frame
		box = NSScreen.screens()![0].frame
		box.origin.x += (box.size.width / 4) * 3
		box.size.width /= 4.0
		box.size.height /= 4.0
		window.setFrame( box, display: true )
	}
	
	@IBAction func placeWindowInUpperRight( sender : AnyObject? ) {
		var	box : NSRect = window.frame
		box = NSScreen.screens()![0].frame
		box.origin.x += (box.size.width / 4) * 3
		box.size.width /= 4.0
		box.origin.y += (box.size.height / 4) * 3
		box.size.height /= 4.0
		window.setFrame( box, display: true )
	}
	
	@IBAction func placeWindowInUpperLeft( sender : AnyObject? ) {
		var	box : NSRect = window.frame
		box = NSScreen.screens()![0].frame
		box.size.width /= 4.0
		box.origin.y += (box.size.height / 4) * 3
		box.size.height /= 4.0
		window.setFrame( box, display: true )
	}
	
	@IBAction func placeWindowToFillScreen( sender : AnyObject? ) {
		var	box : NSRect = window.frame
		box = NSScreen.screens()![0].frame
		window.setFrame( box, display: true )
	}
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            if let newValue = change?[NSKeyValueChangeNewKey] {
                window.title = newValue as! String
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}

