//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Brooke Kumpunen on 3/11/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? SwitchTableViewCell
        //2) Get the data
        let alarm = AlarmController.shared.alarms[indexPath.row]
        //3) Put data into cell
        cell?.delegate = self
        cell?.alarm = alarm
        return cell ?? UITableViewCell()
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarmToRemove = AlarmController.shared.alarms[indexPath.row]
        AlarmController.shared.deleteAlarm(alarm: alarmToRemove)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlarmDetailVC" {
            let destinationVC = segue.destination as? AlarmDetailTableViewController
            guard let index = tableView.indexPathForSelectedRow else {return}
            let selectedAlarm = AlarmController.shared.alarms[index.row]
            destinationVC?.selectedAlarm = selectedAlarm
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension AlarmListTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let alarm = cell.alarm else {return}
        AlarmController.shared.toggleEnabled(for: alarm)
        tableView.reloadData()
    }
    
    
}
