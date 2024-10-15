//
//  ExampleTileTableViewCell.swift
//  swiftExample
//
//  Created by 魏凌云 on 2024/9/27.
//

import UIKit
import SnapKit

class ExampleTileTableViewCell: UITableViewCell {

    let myLabel:UILabel = {
        let lable = UILabel();
        lable.font = UIFont.systemFont(ofSize: 15, weight: .semibold);
        //lable.textColor = UIColor.black
        return lable;
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupViews() {
        self.contentView.addSubview(self.myLabel)
        
        self.myLabel.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
}
