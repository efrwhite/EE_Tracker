import UIKit

class DocumentTableViewCell: UITableViewCell {
    var editButtonAction: (() -> Void)?

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        contentView.addSubview(editButton)
        setupConstraints()
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 50),
            editButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func editButtonTapped() {
        editButtonAction?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        editButtonAction = nil
    }
}
