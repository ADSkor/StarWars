//
//  TextCellData.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 09.01.2023.
//  Copyright © 2022 ADSkor. All rights reserved.
//

import Miji
import UIKit

class TextCellData: TableViewAdapterItemData {
    private(set) var text: String
    let numberOfLines: Int
    let image: UIImage?
    let leftImage: UIImage?
    let leftImageHeight: CGFloat
    let leftImageWidth: CGFloat
    let attributedText: NSAttributedString?
    let font: UIFont
    let textAlign: NSTextAlignment
    let textColor: UIColor
    let topSpace: CGFloat
    let leftSpace: CGFloat
    let rightSpace: CGFloat
    let bottomSpace: CGFloat
    let backViewLeftConstraint: CGFloat
    let backViewRightConstraint: CGFloat
    let backViewTopConstraint: CGFloat
    let backViewBottomConstraint: CGFloat
    let backViewCornerRadius: CGFloat
    let cellBackgroundColor: UIColor
    let backgroundColor: UIColor
    let doNotApplyTextColor: Bool
    let uppermostViewIsHidden: Bool
    let payload: AnyObject?

    init(
        text: String,
        numberOfLines: Int = 0,
        image: UIImage? = nil,
        leftImage: UIImage? = nil,
        leftImageHeight: CGFloat,
        leftImageWidth: CGFloat,
        attributedText: NSAttributedString?,
        font: UIFont,
        textAlign: NSTextAlignment,
        textColor: UIColor,
        topSpace: CGFloat,
        leftSpace: CGFloat,
        rightSpace: CGFloat,
        bottomSpace: CGFloat,
        backViewLeftConstraint: CGFloat,
        backViewRightConstraint: CGFloat,
        backViewTopConstraint: CGFloat,
        backViewBottomConstraint: CGFloat,
        backViewCornerRadius: CGFloat,
        cellBackgroundColor: UIColor,
        backgroundColor: UIColor,
        doNotApplyTextColor: Bool,
        uppermostViewIsHidden: Bool,
        payload: AnyObject? = nil
    ) {
        self.text = text
        self.numberOfLines = numberOfLines
        self.image = image
        self.leftImage = leftImage
        self.leftImageHeight = leftImageHeight
        self.leftImageWidth = leftImageWidth
        self.attributedText = attributedText
        self.font = font
        self.textAlign = textAlign
        self.textColor = textColor
        self.topSpace = topSpace
        self.leftSpace = leftSpace
        self.rightSpace = rightSpace
        self.bottomSpace = bottomSpace
        self.backViewLeftConstraint = backViewLeftConstraint
        self.backViewRightConstraint = backViewRightConstraint
        self.backViewTopConstraint = backViewTopConstraint
        self.backViewBottomConstraint = backViewBottomConstraint
        self.backViewCornerRadius = backViewCornerRadius
        self.cellBackgroundColor = cellBackgroundColor
        self.backgroundColor = backgroundColor
        self.doNotApplyTextColor = doNotApplyTextColor
        self.uppermostViewIsHidden = uppermostViewIsHidden
        self.payload = payload
    }

    func set(text: String) {
        self.text = text
    }
}

extension TextCellData: Searchable {
    func contains(_ text: String) -> Bool {
        return self.text.uppercased().contains(text.uppercased())
    }
}
