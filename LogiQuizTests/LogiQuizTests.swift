//
//  LogiQuizTests.swift
//  LogiQuizTests
//
//  Created by KentoFujita on 2023/10/10.
//

import XCTest
@testable import LogiQuiz


final class LogiQuizTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    // CSVファイルの名前を取得するテスト
    func testFindCSVFiles() {
        let csvFiles = CsvLoader.findCSVFiles()
        XCTAssertNotNil(csvFiles) // 結果がnilでないことを確認
        XCTAssertTrue(csvFiles.contains("Quiz1.csv")) // "Quiz1.csv"という名前のファイルが存在するかを確認
        // TODO:追加しよう
    }

//     CSVファイルの内容を正しく読み込むテスト
    func testLoadCSV() {
        do {
            let quizzes = try CsvLoader.loadCSVFromFile(part: 1)
            XCTAssertNotNil(quizzes)
            XCTAssertEqual(quizzes.count,12)
        } catch {
            XCTFail("Failed to load CSV: \(error)")
        }
    }

    // 3. エラー処理のテスト
    func testLoadCSVFileNotFound() {
        do {
            _ = try CsvLoader.loadCSVFromFile(part: 9999) // 存在しないパート番号を指定
            XCTFail("Expected error but got no error")
        } catch CsvLoaderError.fileNotFound {
            // 期待したエラーがスローされた
        } catch {
            XCTFail("Expected fileNotFound error but got \(error)")
        }
    }


}
