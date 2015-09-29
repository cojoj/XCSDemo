//
//  ViewController.swift
//  XCSDemo
//
//  Created by Mateusz Zając on 29.09.2015.
//
//

import UIKit
import XcodeServerSDK

class BotsTableViewController: UITableViewController {

    // MARK: Properties
    lazy var server: XcodeServer = {
        do {
            let config = try XcodeServerConfig(host: "https://localhost")
            let endpoints = XcodeServerEndpoints(serverConfig: config)
            return XcodeServer(config: config, endpoints: endpoints)
        } catch {
            fatalError("Cannot initialize XcodeServer.")
        }
    }()
    
    var bots: [Bot] = []
    
    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch bots and store them
        server.getBots { bots, error in
            guard let bots = bots where error == nil else {
                print("Bots fetching error: \(error)")
                return
            }
            
            self.bots = bots
            self.tableView.reloadData()
        }
    }
}

extension BotsTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bots.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BotCell", forIndexPath: indexPath)
        
        let bot = bots[indexPath.row]
        cell.textLabel?.text = bot.name
        cell.detailTextLabel?.text = String(bot.integrationsCount)
        
        return cell
    }
    
}

