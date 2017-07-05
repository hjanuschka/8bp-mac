//
//  SettingsWindow.swift
//  eightbp-guides
//
//  Created by Januschka Helmut on 05.07.17.
//  Copyright © 2017 hjanuschka. All rights reserved.
//

import Cocoa

class SettingsWindow: NSWindowController {
    @IBOutlet weak var alwaysClickable: NSButtonCell!
    var drawController:ViewController?
    @IBAction func clicky(_ sender: Any) {
        NSLog("xxx %ld", alwaysClickable.state);
        drawController?.view.window?.ignoresMouseEvents=alwaysClickable.state == 1 ? false : true;
    }
    override func windowDidLoad() {
        super.windowDidLoad()
        NSLog("asdasd");
        drawController?.Lines?.mouse=CGPoint(x:0, y:0);
    
        drawController?.Lines?.needsDisplay=true;
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
