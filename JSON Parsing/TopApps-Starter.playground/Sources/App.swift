/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

enum SerializationError: Error {
    case missing(String)
}

public struct App {

    // MARK: - Properties
    public let name: String
    public let link: String

    // MARK: - Initializers
    public init(name: String, link: String) {
        self.name = name
        self.link = link
    }
    
    //This initializer takes a dictionary of type [String: Any] which has been constructed from the JSON data. While this is correct; valid JSON can also be an array or just a plain value, however we know ours follows this dictionary pattern.
    public init?(json: [String: Any]) throws {
        //We use guard-let to dig into the JSON a little bit and pull out the name and link values.
        guard let container = json["im:name"] as? [String: Any],
            let name = container["label"] as? String else {
                throw SerializationError.missing("name")
        }
        
        guard let id = json["id"] as? [String: Any],
            let link = id["label"] as? String else {
                throw SerializationError.missing("link")
        }
        //Finally, if none of the values were nil, the values are set on the model object’s properties and the model is successfully returned.
        self.name = name
        self.link = link
    }
}
