//
//  UsersTableCell.swift
//  XIBViewer
//
//  Created by Huy on 18/6/24.
//

import UIKit

class UsersTableCell: UITableViewCell {
    
    @IBOutlet private weak var cellName: UILabel!
    static private let id = "UsersTableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}


extension UsersTableCell{
    
    static func getNib() -> UINib{
        return UINib(nibName: "UsersTableCell", bundle: nil)
    }
    
    static func getID() -> String{
        id
    }

    func setData(name:String){
        cellName.text = name
    }
    
}
