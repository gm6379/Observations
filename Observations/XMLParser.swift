//
//  XMLParser.swift
//  XMLParsingDemo
//
//  Created by George McDonnell on 05/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class XMLParser: NSObject, NSXMLParserDelegate {
    
    var xmlParser: NSXMLParser?
    
    // root of XML tree
    var rootElement: XMLElement?
    
    // current element being parsed
    var currentElement: XMLElement?
    
    init(data: NSData) {
        super.init()
        xmlParser = NSXMLParser.init(data: data)
        xmlParser?.delegate = self
    }
    
    func parse() -> Bool {
        return (xmlParser?.parse())!
    }

    func parserDidStartDocument(parser: NSXMLParser) {
        rootElement = nil;
        currentElement = nil;
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if (rootElement == nil) {
            // Create a root element
            rootElement = XMLElement()
            currentElement = rootElement
        } else {
            /* Root exists. Create a new element and add it 
            as one of the sub elements of the current element */
            let newElement = XMLElement()
            newElement.parent = currentElement
            currentElement?.subElements.append(newElement)
            currentElement = newElement
        }
        
        currentElement?.name = elementName
        currentElement?.attributes = attributeDict
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if (currentElement?.text?.characters.count > 0) {
            currentElement?.text = currentElement?.text?.stringByAppendingString(string)
        } else {
            currentElement?.text = string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = currentElement?.parent
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        currentElement = nil
    }
    
}
