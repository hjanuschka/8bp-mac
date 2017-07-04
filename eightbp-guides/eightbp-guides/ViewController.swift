//
//  ViewController.swift
//  eightbp-guides
//
//  Created by Januschka Helmut on 04.07.17.
//  Copyright © 2017 hjanuschka. All rights reserved.
//

import Cocoa

final class Line: NSView {
    var mouse: CGPoint?
    
    func drawLine(x: CGFloat, y: CGFloat) {
        let myPath = NSBezierPath()
        myPath.move(to: mouse!)
        myPath.line(to: CGPoint(x: x, y: y))
        myPath.lineWidth = 15.0;
        myPath.stroke()
    }
    override func draw(_ dirtyRect: NSRect) {
        
        //Left Bottom
        self.drawLine(x: 10, y: 10);
        //Bottom Center
        self.drawLine(x: frame.size.width/2, y: 0);
        //Bottom Right
        self.drawLine(x: frame.size.width-10, y: 10);
        
        //Top Left
        self.drawLine(x: 10, y: frame.size.height-10);
        //Top Middle
        self.drawLine(x: frame.size.width/2, y: frame.size.height);
        //Top Right
        self.drawLine(x: frame.size.width-10, y: frame.size.height-10);
        
        
        let circle = NSBezierPath(ovalIn: NSRect(x: (mouse?.x)!-10, y: (mouse?.y)!-10, width: 20, height: 20))
        circle.stroke()
        circle.fill()
        
        //self.drawLine(x: 0, y: 0);
        
        
        
    }
}

class ViewController: NSViewController, NSWindowDelegate {
    var currentCenter: NSPoint = CGPoint(x:0, y:0);
    var Lines:Line?
    
    override func flagsChanged(with event: NSEvent) {
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.shift]:
            print("shift key is pressed")
        case [.control]:
            print("control key is pressed")
        case [.option] :
            print("option key is pressed")
        case [.command]:
            print("Command key is pressed")
            view.window?.ignoresMouseEvents=false;
        case [.control, .shift]:
            print("control-shift keys are pressed")
        case [.option, .shift]:
            print("option-shift keys are pressed")
        case [.command, .shift]:
            print("command-shift keys are pressed")
        case [.control, .option]:
            print("control-option keys are pressed")
        case [.control, .command]:
            print("control-command keys are pressed")
        case [.option, .command]:
            print("option-command keys are pressed")
        case [.shift, .control, .option]:
            print("shift-control-option keys are pressed")
        case [.shift, .control, .command]:
            print("shift-control-command keys are pressed")
        case [.control, .option, .command]:
            print("control-option-command keys are pressed")
        case [.shift, .command, .option]:
            print("shift-command-option keys are pressed")
        case [.shift, .control, .option, .command]:
            print("shift-control-option-command keys are pressed")
        default:
            view.window?.ignoresMouseEvents=true;
            print("no modifier keys are pressed")
        }
    }
    override func mouseDown(with event: NSEvent) {
        let p = event.locationInWindow;
        NSLog("%@", NSStringFromPoint(p));
        currentCenter = p;
        Lines?.mouse = p;
        Lines?.needsDisplay=true;
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.isOpaque = false
        view.window?.backgroundColor = .clear
        view.window?.delegate = self
        view.window?.ignoresMouseEvents=true;
        self.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = self.view.frame;

        self.Lines = Line(frame: frame)
        self.Lines?.mouse = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2);
        
        
        view.addSubview(self.Lines!)
        self.Lines?.needsDisplay=true;
        
        // Do any additional setup after loading the view.
        
        NSApplication.shared().windows.first?.level = Int(CGWindowLevelForKey(.floatingWindow))
        
        view.layer?.borderWidth = 1.0;
        view.layer?.borderColor = .black;
        
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) {
            self.flagsChanged(with: $0)
            return $0
        }
        
    }
    func windowDidResize(_ notification: Notification) {
        // Your code goes here
        NSLog("AAA")
        self.Lines?.frame = view.frame;
        self.Lines?.needsDisplay=true;
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

