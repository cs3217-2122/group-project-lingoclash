//
//  Logger.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import Foundation

class Logger {
    private enum LogLevel {
        case info
        case warning
        case error

        var prefix: String {
            switch self {
            case .info:
                return "INFO"
            case .warning:
                return "WARN ⚠️"
            case .error:
                return "ALERT ❌"
            }
        }
    }

    private struct Context {
        let file: String
        let function: String
        let line: Int
        var description: String {
            "\((file as NSString).lastPathComponent):\(line) \(function)"
        }
    }

    static func info(
        _ str: String,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .info, str: str, shouldLogContext: shouldLogContext, context: context)
    }

    static func warning(
        _ str: String,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .warning, str: str, shouldLogContext: shouldLogContext, context: context)
    }

    static func error(
        _ str: String,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .error, str: str, shouldLogContext: shouldLogContext, context: context)
    }

    private static func handleLog(level: LogLevel, str: String, shouldLogContext: Bool, context: Context) {
        let logComponents = ["[\(level.prefix)]", str]

        var fullString = logComponents.joined(separator: " ")
        if shouldLogContext {
            fullString += " → \(context.description)"
        }

        #if DEBUG
        print(fullString)
        #endif
    }
}
