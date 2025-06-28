//
//  JSONDecoder+ISO8601.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 28/6/25.
//
import Foundation

extension JSONDecoder {
    static func withISO8601Milliseconds() -> JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = formatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ISO8601 date")
            }
            return date
        }
        return decoder
    }
}
