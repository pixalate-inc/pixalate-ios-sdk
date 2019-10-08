//
//  MySwiftObject.swift
//  sample-app-objc
//
//  Created by Nate Tessman on 8/26/19.
//  Copyright © 2019 Pixalate. All rights reserved.
//

import Foundation;

class MySwiftObject : NSObject {
    var myString : String = "Some String"
    
    public subscript(key: String) -> String! {
        get {
            return "foo";
        }
        set(newValue) {
            myString = newValue
        }
    }
}
