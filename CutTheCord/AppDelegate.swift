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

	@IBOutlet weak var	window: NSWindow!
	@IBOutlet weak var	webView: WKWebView!
	@IBOutlet weak var	urlsMenu: NSMenu!
	var					pageURLs =	[
										[ "name": "Netflix",	"url": "http://netflix.com" ],
										[ "name": "Twitch",		"url": "http://twitch.tv"],
										[ "name": "YouTube",	"url": "http://youtube.com"]
									]

    deinit
	{
        webView.removeObserver(self, forKeyPath: "title", context: &myContext)
    }

	func applicationDidFinishLaunching(_ aNotification: Notification)
	{
		window.level = Int(CGWindowLevelForKey(CGWindowLevelKey.floatingWindow))

        webView.addObserver(self, forKeyPath: "title", options: .new, context: &myContext)
		
		NSApplication.shared().presentationOptions = [NSApplicationPresentationOptions.autoHideDock, NSApplicationPresentationOptions.autoHideMenuBar]
		
		var		x = 0
		for currURL in pageURLs
		{
			let	itemName = currURL["name"]!
			let newItem = urlsMenu.addItem( withTitle: itemName, action: #selector(AppDelegate.takeURLIndexFromTag(_:)), keyEquivalent: "" )
			newItem.tag = x
			
			x += 1
		}
		
		var	recentURLString = UserDefaults.standard.object(forKey: "ULICutTheCordMostRecentURLString") as? String
		if recentURLString == nil
		{
			recentURLString = pageURLs[0]["url"]
		}
		let	osVersion = ProcessInfo.processInfo.operatingSystemVersion
		webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X \(osVersion.majorVersion)_\(osVersion.minorVersion)_\(osVersion.patchVersion)) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9"
		let	pageURL = URL(string: recentURLString!)
		webView.load( URLRequest( url: pageURL! ) )
		
		window.styleMask.remove( [.closable] )
		window.styleMask.insert( [.titled] )
	}
	
	func applicationWillTerminate(_ notification: Notification)
	{
		if let currURL = webView.url
		{
			UserDefaults.standard.set( currURL.absoluteString, forKey: "ULICutTheCordMostRecentURLString")
		}
	}
	
	@IBAction func takeURLIndexFromTag( _ sender: NSMenuItem? )
	{
		let	pageURL = URL(string: pageURLs[sender!.tag]["url"]!)
		webView.load( URLRequest( url: pageURL! ) )
	}
	
	@IBAction func placeWindowInLowerLeft( _ sender : AnyObject? )
	{
		var	box : NSRect = window.frame
		box = NSScreen.screens()![0].frame
		box.size.width /= 4.0
		box.size.height /= 4.0
		window.setFrame( box, display: true )
	}
	
	@IBAction func placeWindowInLowerRight( _ sender : AnyObject? )
	{
		var	box : NSRect = window.frame
		box = NSScreen.screens()![0].frame
		box.size.width = (box.size.width / 5.0) * 2.0
		box.size.height = (box.size.height / 5.0) * 2.0
		window.setFrame( box, display: true )
	}
	
	@IBAction func placeWindowInUpperRight( _ sender : AnyObject? )
	{
		var	box : NSRect = window.frame
		box = NSScreen.screens()![0].frame
		box.origin.x += (box.size.width / 4) * 3
		box.size.width /= 4.0
		box.origin.y += (box.size.height / 4) * 3
		box.size.height /= 4.0
		window.setFrame( box, display: true )
	}
	
	@IBAction func placeWindowInUpperLeft( _ sender : AnyObject? )
	{
		var	box : NSRect = window.frame
		box = NSScreen.screens()![0].frame
		box.size.width = (box.size.width / 5.0) * 2.0
		box.size.height = (box.size.height / 5.0) * 2.0
		window.setFrame( box, display: true )
	}
	
	@IBAction func placeWindowToFillScreen( _ sender : AnyObject? )
	{
		var	box : NSRect = window.frame
		box = NSScreen.screens()![0].frame
		window.setFrame( box, display: true )
	}
	
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
	{
        if context == &myContext
		{
            if let newValue = change?[NSKeyValueChangeKey.newKey]
			{
                window.title = newValue as! String
            }
        }
		else
		{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

