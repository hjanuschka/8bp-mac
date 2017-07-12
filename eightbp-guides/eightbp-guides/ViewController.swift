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
    var BallSize: CGFloat = 20
    var showBankShot = false
    
    var bankStart: CGPoint?
    var bankFirstHit: CGPoint?
    
    
    func drawLine(x: CGFloat, y: CGFloat) {
        let myPath = NSBezierPath()
        myPath.move(to: mouse!)
        myPath.line(to: CGPoint(x: x, y: y))
        //myPath.lineWidth = 15.0;
        let color = NSColor.red;
        color.set()
        myPath.stroke()
    }
    override func draw(_ dirtyRect: NSRect) {
        
        drawHoleLines();
        drawBankShotLines();
        
        
    }
    func getAngle(fromPoint: CGPoint, toPoint: CGPoint) -> CGFloat {
        let dx: CGFloat = fromPoint.x - toPoint.x
        let dy: CGFloat = fromPoint.y - toPoint.y
        let twoPi: CGFloat = 2 * CGFloat(Double.pi)
        let radians: CGFloat = (atan2(dy, -dx) + twoPi).truncatingRemainder(dividingBy: twoPi)
        return radians * 360 / twoPi
    }

    func drawBankShotLines() {
        if(!showBankShot || bankFirstHit == nil || bankStart == nil) {
            return;
        }
        
        
        
        var screenMax = CGPoint(x: self.frame.width, y: self.frame.height)
        var lastPoint:CGPoint = .zero;
        
        var slope:CGFloat = 1.0;

        
        if (bankFirstHit!.x != bankStart!.x) {
            slope = (bankFirstHit!.y - bankStart!.y) / (bankFirstHit!.x - bankStart!.x);
            lastPoint = CGPoint(x: screenMax.x, y: slope * (screenMax.x-bankFirstHit!.x)+bankFirstHit!.y)
        } else {
            slope = 0
            lastPoint.x = bankFirstHit!.x;
            lastPoint.y = screenMax.y;
        
        }
        
        
        
        
        
        
        NSLog("Slope: %03.03f", slope);
        NSLog("Last Point", NSStringFromPoint(lastPoint))
        
        let myPath = NSBezierPath()
        myPath.move(to: bankStart!)
        myPath.line(to: bankFirstHit!)
        //myPath.lineWidth = 15.0;
        let color = NSColor.red;
        color.set()
        myPath.stroke()

        let extensionPath = NSBezierPath()
        extensionPath.lineCapStyle = .squareLineCapStyle

        extensionPath.move(to: bankFirstHit!)
        extensionPath.line(to: lastPoint)
        extensionPath.lineWidth = 15.0;
        
        
        

        
        let color1 = NSColor.blue;
        color1.set()
        extensionPath.stroke()

      
        
        
        
        /*
        UIBezierPath *myPath = [UIBezierPath bezierPath];
        [myPath moveToPoint: firstPoint];
        [myPath addLineToPoint: secondPoint];
        myPath.lineWidth = 10;
        [[UIColor yellowColor]setStroke];
        [myPath stroke];
        
        //this is the extension from the second point to the end of the screen
        [myPath addLineToPoint: lastPoint];
        [myPath stroke];
        */
        
    }
    
    func drawHoleLines() {
        let drawMargin:CGFloat = 10
        let ajusteX:CGFloat = 15;
        let ajusteY:CGFloat = 40;
        
        //Left Bottom
        self.drawLine(x: drawMargin, y: drawMargin);
        //Bottom Center
        self.drawLine(x: frame.size.width/2-5, y: drawMargin);
        //Bottom Right
        self.drawLine(x: frame.size.width-drawMargin, y: drawMargin);
        
        //Top Left
        self.drawLine(x: drawMargin, y: frame.size.height-drawMargin);
        //Top Middle
        self.drawLine(x: frame.size.width/2-5, y: frame.size.height-drawMargin);
        //Top Right
        self.drawLine(x: frame.size.width - drawMargin, y: frame.size.height-drawMargin);
        
        
        let circle = NSBezierPath(ovalIn: NSRect(x: (mouse?.x)!-(BallSize/2), y: (mouse?.y)!-(BallSize/2), width: BallSize, height: BallSize))
        circle.stroke()
        circle.fill()
        
        //self.drawLine(x: 0, y: 0);
        
        
        
    }
}

class ViewController: NSViewController, NSWindowDelegate {
    var currentCenter: NSPoint = CGPoint(x:0, y:0);
    var Lines:Line?
    
    private var settings: SettingsWindow!

    
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
        
        
        // 0 == CUEBALL
        // 1 == BANK START
        // 2 == FIRST BANK HIT
        if(settings.ballType.selectedSegment == 1) {
            Lines?.showBankShot = true;
            Lines?.bankStart = p;
            
        }
        if(settings.ballType.selectedSegment == 2) {
            Lines?.showBankShot = true;
            Lines?.bankFirstHit = p;
            
            /*
            if(p.y >= view.frame.size.height/2) {
                Lines?.bankFirstHit = CGPoint(x: p.x, y: view.frame.size.height)
            } else {
                Lines?.bankFirstHit = CGPoint(x: p.x, y: 0)
            }
             */
        }
        if(settings.ballType.selectedSegment == 0) {
            currentCenter = p;
            Lines?.mouse = p;
   
        }
        
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
        
        //Settings Window
        settings = SettingsWindow(windowNibName: "SettingsWindow")
        settings.drawController=self
        settings.showWindow(self)
        settings.window?.level = Int(CGWindowLevelForKey(.floatingWindow))
        
        
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

