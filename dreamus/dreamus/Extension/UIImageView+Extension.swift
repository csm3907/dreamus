//
//  UIImageView+Extension.swift
//  dreamus
//
//  Created by USER on 2023/10/08.
//

import UIKit

extension UIImageView {
    func setImage(fromURL urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("이미지를 다운로드할 수 없습니다: \(error!.localizedDescription)")
                    return
                }
                
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    } else {
                        print("데이터를 이미지로 변환할 수 없습니다.")
                    }
                }
            }.resume()
        } else {
            print("잘못된 URL입니다.")
        }
    }
}
