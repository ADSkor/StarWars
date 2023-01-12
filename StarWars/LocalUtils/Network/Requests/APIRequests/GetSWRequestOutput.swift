//
//  GetSWRequestOutput.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.01.2023.
//

import Foundation
import Miji
import SwiftyJSON

class GetSWRequestOutput: SerializedData {
    var json: JSON = JSON("")

    public required init(serializedData: Any) {
        super.init(serializedData: serializedData)
        guard let json = serializedData as? JSON else { return }
        self.json = json
    }
}
