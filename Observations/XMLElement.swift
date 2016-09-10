//
//  XMLElement.swift
//  XMLParsingDemo
//
//  Created by George McDonnell on 05/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class XMLElement: NSObject {

    var name: String?
    var text: String?
    var attributes: Dictionary <String, String>?
    var subElements: Array <XMLElement> = []
    var parent: XMLElement?
}

