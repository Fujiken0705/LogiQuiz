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

    // Quiz1からQuiz8までのCSVファイルが存在するかを確認
    func testFindCSVFiles() {
        let csvFiles = CsvLoader.findCSVFiles()
        XCTAssertNotNil(csvFiles) // 結果がnilでないことを確認
        for i in 1...8 {
            XCTAssertTrue(csvFiles.contains("Quiz\(i).csv"))
        }
    }

//  読み込んだ問題数が正しいかテスト
    func testLoadCSV() {
        let expectedQuizCounts: [Int: Int] = [
            1: 12,
            2: 10,
            3: 10,
            4: 10,
            5: 9,
            6: 9,
            7: 10,
            8: 10,
        ]

        for (part, expectedCount) in expectedQuizCounts {
            do {
                let quizzes = try CsvLoader.loadCSVFromFile(part: part)
                //Nil消す
                XCTAssertNotNil(quizzes)
                XCTAssertEqual(quizzes.count, expectedCount, "Expected \(expectedCount) quizzes for Quiz\(part), but got \(quizzes.count).")
            } catch {
                XCTFail("Failed to load CSV for Quiz\(part): \(error)")
            }
        }
    }
    //throwの場合はnil不要？？

    // エラー処理のテスト
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

    //TODO:Mockを作成してRealmでの保存や削除がうまく行われているかテストする
}
