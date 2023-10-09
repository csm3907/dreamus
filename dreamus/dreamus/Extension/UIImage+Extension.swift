//
//  UIImage+Extension.swift
//  dreamus
//
//  Created by USER on 2023/10/08.
//

import UIKit

extension UIImage {
    static func loadImage(fromURL imageURL: URL, completion: @escaping (UIImage?) -> Void) {
        // 이미지 다운로드를 시작
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                print("이미지 다운로드 오류: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                // 다운로드 완료 후 이미지를 수정
                //let modifiedImage = image.resizeLeft1px()
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

