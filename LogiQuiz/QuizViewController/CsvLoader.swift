//
//  CsvLoader.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/10/07.
//

import Foundation

class CsvLoader {

    static func findCSVFiles() -> [String] {
            let fileManager = FileManager.default
            guard let resourcePath = Bundle.main.resourcePath else { return [] }

            do {
                let files = try fileManager.contentsOfDirectory(atPath: resourcePath)
                return files.filter { $0.hasSuffix(".csv") }
            } catch {
                return []
            }
        }
    
    static func loadCSV(part: Int, specificQuizIds: [String]? = nil) throws -> [Quiz] {
        var quizzes: [Quiz] = []

        guard let filePath = Bundle.main.path(forResource: "Quiz\(part)", ofType: "csv") else {
            throw CsvLoaderError.fileNotFound
        }

        let csvData = try String(contentsOfFile: filePath)
        let csvLines = csvData.components(separatedBy: .newlines)

        for (index, line) in csvLines.enumerated() {
            let components = line.components(separatedBy: ",")
            if components.count >= 3 {
                let title = components[0]
                let correctIndex = (Int(components[1]) ?? 1) - 1
                let selections = Array(components[2...])
                let id = "p\(part)q\(index + 1)"

                if let specificIds = specificQuizIds, !specificIds.contains(id) {
                    continue
                }

                let quiz = Quiz(id: id, title: title, selections: selections, correctIndex: correctIndex)
                quizzes.append(quiz)
            }
        }

        return quizzes
    }
}

enum CsvLoaderError: Error {
    case fileNotFound
}
