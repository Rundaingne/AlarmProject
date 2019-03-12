//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Brooke Kumpunen on 3/11/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    
    //MARK: Properties/Landing Pads
    weak var delegate: SwitchTableViewCellDelegate?
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let alarm = alarm else {return}
        let dateFormatter = DateFormatter()
        var fireTimeAsString: String {
            get {
                return dateFormatter.string(from: alarm.fireDate)
            }
        }
        nameLabel.text = alarm.name
        timeLabel.text = fireTimeAsString
        alarmSwitch.isOn = alarm.enabled
    }
    
    //MARK: Actions
    
    @IBAction func alarmSwitch(_ sender: UISwitch) {
        delegate?.switchCellSwitchValueChanged(cell: self)
    }
    
}
