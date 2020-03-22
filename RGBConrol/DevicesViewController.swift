//
//  DevicesViewController.swift
//  RGBConrol
//
//  Created by Andrew Zinoviev on 3/22/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit
import RGBDriver

class DevicesViewController: UIViewController, SubnetScannerDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    var hosts = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicId")!
        cell.textLabel?.text = hosts[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func hostFound(host: String) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.hosts.append(host)
            self.tableView.insertRows(at: [IndexPath(row: self.hosts.count - 1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    func scanDidFinished() {
        DispatchQueue.main.async {
            self.refreshButton.isEnabled = true
        }
    }
    
    func clearTable(){
        if(hosts.isEmpty){
            return
        }
        tableView.beginUpdates()
        for _ in 1...hosts.count{
            tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }
        hosts.removeAll()
        tableView.endUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        refresh()
    }
    
    func refresh(){
        refreshButton.isEnabled = false
        clearTable()
        let scanner = SubnetScanner(delegate: self)
        scanner.scanForTCPPortOpened()
    }
    
    @IBAction func onRefrechClicked(_ sender: Any) {
        refresh()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "useDevice" else {
            return
        }
        guard let dest = segue.destination as? ViewController else { return }
        dest.host = hosts[(tableView.indexPathForSelectedRow?.row)!]
    }
    
}
