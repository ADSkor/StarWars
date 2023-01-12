//
//  TextCell.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 09.01.2023.
//  Copyright © 2022 ADSkor. All rights reserved.
//

import Miji
import UIKit

class TextCell: TableViewAdapterCell {
    @IBOutlet private weak var label: UILabel?
    @IBOutlet private weak var iconView: UIImageView?
    @IBOutlet private weak var leftImageView: UIImageView?
    @IBOutlet private weak var leftImageHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var leftImageWidthConstraint: NSLayoutConstraint?
    @IBOutlet private weak var topConstraint: NSLayoutConstraint?
    @IBOutlet private weak var leftConstraint: NSLayoutConstraint?
    @IBOutlet private weak var rightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint?
    @IBOutlet private weak var backView: UIView?
    @IBOutlet private weak var backViewLeftConstraint: NSLayoutConstraint?
    @IBOutlet private weak var backViewRightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var backViewTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var backViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet private weak var uppermostView: UIView?

    private weak var data: TextCellData?

    static func item(
        identifier: String = UUID().uuidString,
        text: String,
        numberOfLines: Int = 0,
        image: UIImage? = nil,
        leftImage: UIImage? = nil,
        leftImageHeight: CGFloat = 24,
        leftImageWidth: CGFloat = 24,
        attributedText: NSAttributedString? = nil,
        attributedString: NSAttributedString? = nil,
        font: UIFont = .systemFont(ofSize: 18),
        textAlign: NSTextAlignment = .left,
        textColor: UIColor = .black,
        topSpace: CGFloat = 8,
        leftSpace: CGFloat = 16,
        rightSpace: CGFloat = 16,
        bottomSpace: CGFloat = 8,
        backViewLeftConstraint: CGFloat = 0,
        backViewRightConstraint: CGFloat = 0,
        backViewTopConstraint: CGFloat = 0,
        backViewBottomConstraint: CGFloat = 0,
        backViewCornerRadius: CGFloat = 0,
        cellBackgroundColor: UIColor = .clear,
        backgroundColor: UIColor = .clear,
        doNotApplyTextColor: Bool = false,
        uppermostViewIsHidden: Bool = true,
        payload: AnyObject? = nil
    ) -> CellItem {
        return CellItem(
            identifier: identifier,
            cellClass: TextCell.self,
            data: TextCellData(
                text: text,
                numberOfLines: numberOfLines,
                image: image,
                leftImage: leftImage,
                leftImageHeight: leftImageHeight,
                leftImageWidth: leftImageWidth,
                attributedText: attributedText ?? attributedString,
                font: font,
                textAlign: textAlign,
                textColor: textColor,
                topSpace: topSpace,
                leftSpace: leftSpace,
                rightSpace: rightSpace,
                bottomSpace: bottomSpace,
                backViewLeftConstraint: backViewLeftConstraint,
                backViewRightConstraint: backViewRightConstraint,
                backViewTopConstraint: backViewTopConstraint,
                backViewBottomConstraint: backViewBottomConstraint,
                backViewCornerRadius: backViewCornerRadius,
                cellBackgroundColor: cellBackgroundColor,
                backgroundColor: backgroundColor,
                doNotApplyTextColor: doNotApplyTextColor,
                uppermostViewIsHidden: uppermostViewIsHidden,
                payload: payload
            )
        )
    }

    @IBAction private func didTap(button _: UIButton?) {
        delegate?.tableViewAdapterCellDidTap(cell: self)
    }

    func set(text: String) {
        guard let data else { return }
        data.set(text: text)
        fill(data: data)
    }

    override func fill(data: TableViewAdapterItemData) {
        guard let data = data as? TextCellData else { return }
        self.data = data
        selectionStyle = .none

        leftImageView?.image = data.leftImage
        leftImageHeightConstraint?.constant = data.leftImageHeight
        leftImageWidthConstraint?.constant = data.leftImageWidth
        iconView?.image = data.image
        label?.text = data.text
        if let attributedText = data.attributedText {
            label?.attributedText = attributedText
        }
        label?.numberOfLines = data.numberOfLines
        label?.font = data.font
        label?.textAlignment = data.textAlign
        if data.doNotApplyTextColor == false {
            label?.textColor = data.textColor
        }

        topConstraint?.constant = data.topSpace
        leftConstraint?.constant = data.leftSpace
        rightConstraint?.constant = data.rightSpace
        bottomConstraint?.constant = data.bottomSpace

        backViewLeftConstraint?.constant = data.backViewLeftConstraint
        backViewRightConstraint?.constant = data.backViewRightConstraint
        backViewTopConstraint?.constant = data.backViewTopConstraint
        backViewBottomConstraint?.constant = data.backViewBottomConstraint

        uppermostView?.isHidden = data.uppermostViewIsHidden

        backView?.layer.cornerRadius = data.backViewCornerRadius

        backView?.backgroundColor = data.backgroundColor
        backgroundColor = data.cellBackgroundColor
    }
}
