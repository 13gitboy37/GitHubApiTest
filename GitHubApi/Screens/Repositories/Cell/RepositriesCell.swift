//
//  RepositriesCell.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 29.09.2022.
//

import UIKit
import Kingfisher
import SnapKit

class RepositriesCell: UITableViewCell {
    
    static let reuseIdentifire = "reuseId"
    
    private(set) lazy var nameRepoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        return label
    }()
    
    private(set) lazy var nameLanguageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private(set) lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")?.withTintColor(.systemGray)
        return imageView
    }()
    
    override func prepareForReuse() {
        [self.nameRepoLabel, nameLanguageLabel].forEach { $0.text = nil }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }
    
    func configure(with cellModel: Repository) {
        nameRepoLabel.text = cellModel.name
        nameLanguageLabel.text = cellModel.language
        avatarImage.kf.setImage(with: URL(string: cellModel.owner.avatarUrl),
                                placeholder: UIImage(named: "GitHub-Logo"))
    }
    
    func configure() {
        nameRepoLabel.text = "123"
        nameLanguageLabel.text = "123"
        avatarImage.image = UIImage(systemName: "person.fill")
    }
    
    private func setupViews() {
        contentView.addSubview(nameRepoLabel)
        contentView.addSubview(nameLanguageLabel)
        contentView.addSubview(avatarImage)
    }
    
    private func setupConstraints() {
        avatarImage.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).inset(10)
            make.height.width.equalTo(50)
        }
        
        nameRepoLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImage.snp.right).inset(-20)
            make.top.equalTo(contentView).inset(10)
        }
        
        nameLanguageLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImage.snp.right).inset(-20)
            make.top.equalTo(nameRepoLabel).inset(25)
        }
    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()    }
//
//
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
