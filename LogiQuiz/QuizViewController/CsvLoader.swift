//
//  CsvLoader.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/10/07.
//

import Foundation

class CsvLoader {

    // CSVファイルの検索
    static func findCSVFiles() -> [String] {
        guard let resourcePath = Bundle.main.resourcePath else { return [] }
        return (try? FileManager.default.contentsOfDirectory(atPath: resourcePath).filter { $0.hasSuffix(".csv") }) ?? []
    }

    // 指定されたモードに基づいてCSVファイルからクイズを読み込む
    static func loadCSV(mode: QuizMode, specificQuizIds: [String]? = nil) throws -> [Quiz] {
        switch mode {
        case .normal(let part):
            return try loadCSVFromFile(part: part, specificQuizIds: specificQuizIds)
        case .review:
            return try findCSVFiles().flatMap { file -> [Quiz] in
                guard let partNumber = Int(file.replacingOccurrences(of: "Quiz", with: "").replacingOccurrences(of: ".csv", with: "")) else { return [] }
                return try loadCSVFromFile(part: partNumber, specificQuizIds: specificQuizIds)
            }
        }
    }

    // ファイルからCSVデータを読み込んでクイズオブジェクトを生成する
    static func loadCSVFromFile(part: Int, specificQuizIds: [String]? = nil) throws -> [Quiz] {
        guard let filePath = Bundle.main.path(forResource: "Quiz\(part)", ofType: "csv") else {
            throw CsvLoaderError.fileNotFound
        }

        let csvData = try String(contentsOfFile: filePath)
        return csvData.components(separatedBy: .newlines).enumerated().compactMap { index, line in
            processCsvLine(line: line, part: part, index: index + 1, specificQuizIds: specificQuizIds)
        }
    }

    // CSVの各行を処理してQuizオブジェクトを生成する
    private static func processCsvLine(line: String, part: Int, index: Int, specificQuizIds: [String]?) -> Quiz? {
        let components = line.components(separatedBy: ",")
        guard components.count >= 3 else { return nil }
        let id = "p\(part)q\(index)"
        guard specificQuizIds?.contains(id) ?? true else { return nil }

        let title = components[0]
        let correctIndex = (Int(components[1]) ?? 1) - 1
        let selections = Array(components[2...])
        return Quiz(id: id, title: title, selections: selections, correctIndex: correctIndex)
    }
}

enum CsvLoaderError: Error {
    case fileNotFound
}

enum QuizMode {
    case normal(part: Int)
    case review
}
