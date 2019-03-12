//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Brooke Kumpunen on 3/11/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    //Landing pads and properties
    var selectedAlarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateviews()
        }
    }
    
    var alarmIsOn: Bool = true
    
    //MARK: Outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var enableAlarmButton: UIButton!
    
    //MARK: Methods
    
    private func updateviews() {
        guard let selectedAlarm = selectedAlarm else {return}
        alarmNameTextField.text = selectedAlarm.name
        datePicker.date = selectedAlarm.fireDate
        if selectedAlarm.enabled {
            enableAlarmButton.setTitle("On", for: .selected)
        } else {
            enableAlarmButton.setTitle("Off", for: .disabled)
        }
    }

    //MARK: Actions
    
    @IBAction func enableButtonTapped(_ sender: UIButton) {
        guard let selectedAlarm = selectedAlarm else {return}
        if selectedAlarm.enabled {
            enableAlarmButton.setTitle("Turn off alarm", for: .normal)
        }else {
            enableAlarmButton.setTitle("Turn on alarm", for: .disabled)
        }
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let alarmName = alarmNameTextField.text else {return}
        if let selectedAlarm = selectedAlarm {
            AlarmController.shared.updateAlarm(alarm: selectedAlarm, fireDate: datePicker.date, name: alarmName, enabled: alarmIsOn)
        } else {
            AlarmController.shared.addAlarm(fireDate: datePicker.date, name: alarmName, enabled: alarmIsOn)
        }
        navigationController?.popViewController(animated: true)
    }
    
}
