//
//  AppDelegate.swift
//  CutTheCord
//
//  Created by Uli Kusterer on 02/01/16.
//  Copyright © 2016 Uli Kusterer. All rights reserved.
//

import Cocoa
import WebKit


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	@IBOutlet weak var webView: WKWebView!

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
		
		window.styleMask = NSBorderlessWindowMask | NSResizableWindowMask | NSTexturedBackgroundWindowMask
		window.level = Int(CGWindowLevelForKey(CGWindowLevelKey.PopUpMenuWindowLevelKey))
//		var	box : NSRect = window.frame
//		box.size = NSScreen.screens()![0].frame.size
//		window.setFrame( box, display: true )
		
		NSApplication.sharedApplication().presentationOptions = [NSApplicationPresentationOptions.AutoHideDock, NSApplicationPresentationOptions.AutoHideMenuBar]
		
		let	osVersion = NSProcessInfo.processInfo().operatingSystemVersion
		webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X \(osVersion.majorVersion)_\(osVersion.minorVersion)_\(osVersion.patchVersion)) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9"
		let	pageURL = NSURL(string:"http://netflix.com")
		webView.loadRequest( NSURLRequest( URL: pageURL! ) )
	}
}

