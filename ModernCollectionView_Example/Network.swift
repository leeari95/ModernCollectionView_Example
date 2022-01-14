//
//  Network.swift
//  ModernCollectionView_Example
//
//  Created by Ari on 2022/01/14.
//

import Foundation

final class Network {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func execute(url: URL, completion: @escaping (Result<Data?, Error>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.responseCasting))
                return
            }
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(NetworkError.statusCode(response.statusCode)))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
}

enum NetworkError: LocalizedError {
    case responseCasting
    case statusCode(Int)
    case notFoundURL
    
    var errorDescription: String? {
        switch self {
        case .responseCasting:
            return "캐스팅에 실패하였습니다."
        case .statusCode(let code):
            return "상태 코드 에러 : \(code)"
        case .notFoundURL:
            return "URL을 찾을 수 없습니다."
        }
    }
}

