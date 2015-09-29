//
//  DetailsViewController.swift
//  XCSDemo
//
//  Created by Mateusz Zając on 29.09.2015.
//
//

import UIKit
import XcodeServerSDK

class DetailsViewController: UIViewController {

    // MARK: Properties
    var server: XcodeServer!
    var bot: Bot!
    
    @IBOutlet weak var cleaningPolicyLabel: UILabel!
    @IBOutlet weak var schemeNameLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    
    @IBOutlet weak var integrateButton: UIButton! {
        didSet {
            integrateButton.layer.borderWidth = 1.0
            integrateButton.layer.borderColor = UIColor(red:1, green:0.493, blue:0.473, alpha:1).CGColor
            integrateButton.layer.cornerRadius = 8.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = bot.name
        
        self.cleaningPolicyLabel.text = "Cleaning policy: \(bot.configuration.builtFromClean.toString())"
        self.schemeNameLabel.text = "Scheme name: \(bot.configuration.schemeName)"
        self.scheduleLabel.text = "Schedule: \(bot.configuration.schedule.schedule.toString())"
    }
    
    // MARK: Properties configuration
    
    func configure(bot: Bot, server: XcodeServer) {
        self.server = server
        self.bot = bot
    }
    
    // MARK: Actions
    
    @IBAction func integrationTapped(sender: UIButton) {
        integrateButton.userInteractionEnabled = false
        server.postIntegration(bot.id) { integration, error in
            guard let integration = integration where error == nil else { return }
            dispatch_async(dispatch_get_main_queue()) {
                self.integrateButton.userInteractionEnabled = true
                let alert = UIAlertController(title: "In progress", message: "Integration for \(self.bot.name) \nhas been started with id: \n\(integration.id)", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
}
