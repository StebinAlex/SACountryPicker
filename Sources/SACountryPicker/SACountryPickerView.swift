//
//  SACountryPickerView.swift
//  CountryPickerDemo
//
//  Created by StebinAlex on 04/02/21.
//

import UIKit

public protocol SACountryPickerViewDelegate {
    func selectedCountry(name: String, countryCode: String, phoneCode: Int)
    func closeClicked()
}

public class SACountryPickerView: UIView {

    let countryPicker = SACountryPicker()
    var OriginalCountries: PhoneCountryCode?
    var countries: PhoneCountryCode?
    var tableView = UITableView()
    var searchField = UITextField()
    var topView = UIView()
    public var delegate: SACountryPickerViewDelegate?

    public var topColor = UIColor.systemGreen {
        didSet {
            updateUI()
        }
    }
    public var titleColor = UIColor.white {
        didSet {
            updateUI()
        }
    }

    var hideTopView: Bool = false  {
        didSet {
            updateUI()
        }
    }
    public var title = String() {
        didSet {
            updateUI()
        }
    }
    var hideSearchBar: Bool = false  {
        didSet {
            updateUI()
        }
    }


    private func updateUI() {
        self.subviews.forEach( {$0.removeFromSuperview()} )
        if !hideTopView {
            topView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 40)
            topView.backgroundColor = topColor
            addSubview(topView)

            let titleLbl = UILabel(frame: CGRect(x: 10, y: 0, width: frame.width - 50, height: 40))
            titleLbl.text = title
            titleLbl.textColor = titleColor
            titleLbl.font = UIFont.boldSystemFont(ofSize: 14)
            topView.addSubview(titleLbl)
            let cancel = Bundle.module.path(forResource: "cancel", ofType: "png") ?? ""
            let closeBtn = UIButton(frame: CGRect(x: frame.width - 30, y: 10, width: 20, height: 20))
            closeBtn.setImage(UIImage(named: cancel), for: .normal)
            closeBtn.addTarget(self, action: #selector(closeClicked(_:)), for: .touchUpInside)
            topView.addSubview(closeBtn)
        }
        if !hideSearchBar {
            let y: CGFloat = hideTopView == true ? 0.0 : 40.0
            searchField.frame = CGRect(x: 5, y: y + 5, width: frame.width - 10, height: 25)
            searchField.placeholder = "Search..."
            searchField.borderStyle = .roundedRect
            searchField.font = UIFont.boldSystemFont(ofSize: 14)
            searchField.tintColor = topColor
            addSubview(searchField)
        }
        var y: CGFloat = hideTopView == true ? 0.0 : 40.0
        y = hideSearchBar == true ? y : y + 35
        tableView.frame = CGRect(x: 0, y: y, width: frame.width, height: frame.height - y)
        addSubview(tableView)

    }


    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        countries = countryPicker.countryList()
        OriginalCountries = countries
        searchField.delegate = self
        updateUI()
        tableView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @objc func closeClicked(_ sender: UIButton) {
        delegate?.closeClicked()
    }
}



extension SACountryPickerView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryCell
        cell.selectionStyle = .none
        cell.nameLbl.text = countries?[indexPath.row].countryEn
        cell.codeLbl.text = "(+\(countries?[indexPath.row].phoneCode ?? 0))"
        cell.flag.image = countryPicker.imageForCountryCode(countries?[indexPath.row].countryCode ?? "")
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let c = countries?[indexPath.row] {
            delegate?.selectedCountry(name: c.countryEn, countryCode: c.countryCode, phoneCode: c.phoneCode)
        }
    }

}




class CountryCell: UITableViewCell {

    let nameLbl = UILabel()
    let codeLbl = UILabel()
    let flag = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)


        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        nameLbl.font = UIFont.systemFont(ofSize: 12)
        nameLbl.textAlignment = .left
        contentView.addSubview(nameLbl)
        NSLayoutConstraint.activate([
            nameLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100),
            nameLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            nameLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            nameLbl.heightAnchor.constraint(equalToConstant: 40)
        ])

        codeLbl.translatesAutoresizingMaskIntoConstraints = false
        codeLbl.font = UIFont.systemFont(ofSize: 12)
        codeLbl.textAlignment = .center
        contentView.addSubview(codeLbl)
        NSLayoutConstraint.activate([
            codeLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 45),
            codeLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            codeLbl.widthAnchor.constraint(equalToConstant: 50),
            codeLbl.heightAnchor.constraint(equalToConstant: 40)
        ])

        flag.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(flag)
        NSLayoutConstraint.activate([
            flag.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            flag.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            flag.widthAnchor.constraint(equalToConstant: 30),
            flag.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SACountryPickerView: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        countries = OriginalCountries?.filter {$0.countryEn.contains(textField.text!)}.sorted {$0.countryEn < $1.countryEn}
        tableView.reloadData()
        return true
    }

}
