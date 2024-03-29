/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

struct Book: Codable {
  var id = UUID()
  var name = "New Book"
  var rating = 1
  var imageData: Data?
  var note: String?
  
  func getImage() -> UIImage? {
    if let data = imageData {
      return UIImage(data: data)
    }
    return nil
  }
  
  mutating func set(image: UIImage?) {
    imageData = image?.jpegData(compressionQuality: 0.5)
  }
}

// MARK: - Exporting/Importing
extension Book {
  func exportToURL() -> URL? {
    // Exporting app data
    guard let encoded = try? JSONEncoder().encode(self) else {
      return nil
    }
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    guard let path = documents?.appendingPathComponent("/\(name).btkr") else {
      return nil
    }
    
    do {
      try encoded.write(to: path, options: .atomicWrite)
      return path
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
  
  static func importData(from url: URL) {
    
    guard
      let data = try? Data(contentsOf: url),
      let book = try? JSONDecoder().decode(Book.self, from: data)
      else {
        return
    }
    BookManager.shared.add(book: book)
    
    try? FileManager.default.removeItem(at: url)
  }
}
