//
//  LogiQuizUITests.swift
//  LogiQuizUITests
//
//  Created by KentoFujita on 2023/10/10.
//

import XCTest

final class LogiQuizUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    //　パート1一問目のテキストが正しく表示されているか確認するテスト
    func testQuiz1Question1IsDisplayed() {
        // アプリの起動
        let app = XCUIApplication()
        app.launch()

        // スタートボタンをタップして遷移
        let startButton = app.buttons["startButton"]
        XCTAssert(startButton.exists, "Start button does not exist.")
        startButton.tap()

        // パート1の問題を表示する
        let part1Button = app.buttons["part1Button"]
        XCTAssert(part1Button.exists, "Part1 button does not exist.")
        part1Button.tap()

        // 確認
        let expectedQuestionText = "直接貿易には、代理店契約や販売店契約を結び、現地での買い付けや販売を現地の企業に代行してもらう形態もある。"
        let quizTextView = app.textViews["quizTextView"]
        XCTAssert(quizTextView.exists, "Quiz TextView does not exist.")
        XCTAssert(quizTextView.value as! String == expectedQuestionText, "Displayed question text does not match expected text.")
    }
    //これでいいのかな


    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
