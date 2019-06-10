//
//  SharingEventCell.swift
//  patient-app
//
//  Created by Elliott Brunet on 06.06.19.
//  Copyright © 2019 Elliott Brunet. All rights reserved.
//

import UIKit

class SharingEventCell: UITableViewCell {

    @IBOutlet weak var LabelWhoPrs: UILabel!
    @IBOutlet weak var LabelWhoIst: UILabel!
    @IBOutlet weak var LabelNumberOfElementsShared: UILabel!
    @IBOutlet weak var LableStartDate: UILabel!
    @IBAction func ButtonStopSharing(_ sender: Any) {
        if let safeDelegate = self.delegate {
            safeDelegate.stopSharing(event: event!)
        }
    }
    
    weak var delegate: InnerTableCellDelegate? = nil
    
    var event: SharingEvent?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellForEvent(event: SharingEvent?) {
        if event == nil {
        } else {
            self.event = event
            LabelWhoPrs.text = event?.sharingWithPerson
            LabelWhoIst.text = event?.sharingWithInstitution
            LabelNumberOfElementsShared.text = event?.numberOfElmentsShared
            LableStartDate.text = parseDate(date: event?.dateStart as! Date)
        }
    }

    func parseDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy | HH:mm:SS"
        return dateFormatter.string(from: date)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol InnerTableCellDelegate: class {
    func stopSharing(event: SharingEvent)
}
