import XCTest
import Combine
import Foundation
@testable import Books

let decoder = JSONDecoder()
let encoder = JSONEncoder()

let jsonFile = File(name: "ReadingList_Test",
                    type: "json",
                    bundle: Bundle(for: ReadingListTests.self))

let bookJson1 = """
{
    "id": "6338E8F7-10E8-4B68-AF66-200E6430638F",
    "title": "The Tempest",
    "year": 1601
}
"""

let authorJson1 = """
{
    "id": "6338E8F7-10E8-4B68-AF66-200E6430638E",
    "name": "William Shakespeare",
    "books": [{
        "id": "6338E8F7-10E8-4B68-AF66-200E6430638D",
        "title": "The Tempest",
        "year": 1601
    }]
}
"""

let authorJson2 = """
{
    "id": "6338E8F7-10E8-4B68-AF66-200E643063EE",
    "name": "Unitia McTest",
    "books": [{
        "id": "6338E8F7-10E8-4B68-AF66-200E643063DD",
        "title": "The Test",
        "year": 2022
    }]
}
"""

let readingList1 = """
{
    "id": "5228E8F7-10E8-4B68-AF66-200E6430635A",
    "title": "Summer Reading",
    "authors": [{
        "id": "6338E8F7-10E8-4B68-AF66-200E6430638F",
        "name": "William Shakespeare",
        "books": [{
            "id": "6338E8F7-10E8-4B68-AF66-200E6430638D",
            "title": "The Tempest",
            "year": 1601
            }, {
            "id": "F345D178-F31B-4D71-9FBD-A684A974A68B",
            "title": "Romeo and Juliet",
            "year": 1599
        }]
    }]
}
"""

final class ReadingListTests: XCTestCase
{
    override class func setUp() {
        jsonFile.copyFromMainBundleToDocumentsDirectory()
    }
    
    override class func tearDown() {
        jsonFile.remove()
    }
    
    func testDecodeBook() {
        let data = bookJson1.data(using: .utf8)
        let book = try! decoder.decode(Book.self, from: data!)
        XCTAssertEqual(book.title, "The Tempest")
        XCTAssertEqual(book.year!, 1601)
        print(book)
    }
    
    func testEncodeBook() {
        let book = Book(id: UUID(), title: "The Tempest", year: 1601)
        let data = try! encoder.encode(book)
        print(String(data: data, encoding: .utf8)!)
    }
    
    func testDecodeAuthor() {
        let data = authorJson1.data(using: .utf8)
        let author = try! decoder.decode(Author.self, from: data!)
        XCTAssertEqual(author.name, "William Shakespeare")
        let book = author.books.first!
        XCTAssertEqual(book.title, "The Tempest")
        XCTAssertEqual(book.year!, 1601)
        print(author)
    }
    
    func testDecodeReadingList() {
        let data = readingList1.data(using: .utf8)
        let readingList = try! decoder.decode(ReadingList.self, from: data!)
        XCTAssertEqual(readingList.title, "Summer Reading")
        let book = readingList.authors.first!.books.first!
        XCTAssertEqual(book.title, "The Tempest")
        XCTAssertEqual(book.year!, 1601)
        print(readingList)
    }
    
    func testDecodeJsonFile() {
        let data = try! Data(contentsOf: jsonFile.bundleUrl!)
        let readingList = try! decoder.decode(ReadingList.self, from: data)
        XCTAssert(readingList.authors.count > 0)
        XCTAssert(readingList.authors.first!.books.count > 0)
        XCTAssert(readingList.authors.last!.books.count > 0)
        print(readingList)
    }
    
    func testEncodeJsonFile() {
        let data = try! Data(contentsOf: jsonFile.bundleUrl!)
        let readingList = try! decoder.decode(ReadingList.self, from: data)
        let encodedReadingList = try! encoder.encode(readingList)
        print(String(data: data, encoding: .utf8)!)
        print(String(data: encodedReadingList, encoding: .utf8)!)
        
        let readingListClone = try! decoder.decode(ReadingList.self, from: encodedReadingList)
        XCTAssertEqual(readingListClone.id, readingList.id)
        XCTAssertEqual(readingListClone.authors.first!.books.count, readingList.authors.first!.books.count)
    }
    
    func testFlattenedBooks() {
        let data = try! Data(contentsOf: jsonFile.bundleUrl!)
        let readingList = try! decoder.decode(ReadingList.self, from: data)
        let books = readingList.authors.flatMap { $0.books }
        print(books)
        print()
    }
    
    func testBooksStore() {
        let store = ReadingListStore(jsonFile: jsonFile)
        print(store.allBooks)
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
        print(store.allBooks)
        XCTAssert(!store.allBooks.isEmpty)
    }
    
    func testSave() {
        var store = ReadingListStore(jsonFile: jsonFile)
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
        let initialCount = store.authors.count
        print(store.readingList!)
        print("Initial count: \(initialCount)")
        
        let data = authorJson2.data(using: .utf8)
        let author = try! decoder.decode(Author.self, from: data!)
        store.addAuthor(author)
        print("Updated count: \(store.authors.count)")
        store.save()

        store = ReadingListStore(jsonFile: jsonFile)
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
        print(store.readingList!)
        print("Saved count: \(store.authors.count)")
        XCTAssertEqual(store.authors.count, initialCount + 1)
    }
    
    func testFutureData() {
        let expectation = XCTestExpectation()
        
        let future = Future<Data, String> { promise in
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: jsonFile.documentUrl) {
                    promise(.success(data))
                } else {
                    promise(.failure("Unable to read data at url \(jsonFile.documentUrl)"))
                    XCTFail()
                }
            }
        }
        
        let cancellable = future
            .receive(on: DispatchQueue.main)
            .sink {
                print($0) // error
                expectation.fulfill()
            } receiveValue: {
                print($0) // data
                expectation.fulfill()
            }
        
        print("Cancellable is \(cancellable)")
        wait(for: [expectation], timeout: 1)
    }


    func testFutureAuthors() {
        let expectation = XCTestExpectation()
        
        let future = Future<Data, String> { promise in
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: jsonFile.documentUrl) {
                    promise(.success(data))
                } else {
                    promise(.failure("Unable to load author data at url \(jsonFile.documentUrl)"))
                    XCTFail()
                }
            }
        }
        
        let cancellable = future
            .receive(on: DispatchQueue.main)
            .decode(type: [Author].self, decoder: JSONDecoder())
            .sink {
                print($0) // fatalError($0)
                expectation.fulfill()
            } receiveValue: {
                $0.forEach {
                    print($0.name)
                }
                print($0) // authors = $0
                expectation.fulfill()
            }
        
        print("Cancellable is \(cancellable)")
        wait(for: [expectation], timeout: 1)
    }
}
