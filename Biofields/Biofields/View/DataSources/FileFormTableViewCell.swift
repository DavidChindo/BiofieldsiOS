//
//  FileFormTableViewCell.swift
//  Biofields
//
//  Created by David Barrera on 9/27/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class FileFormTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deletebtn: UIButton!
    weak var delegate: FormRequisitionDelegate?
    var index:Int = -1
    
    @IBAction func onDeleteFileClick(_ sender: Any) {
     delegate?.onDeleteFile(index: self.index)
    }
}
