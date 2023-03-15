//
//  Book.swift
//  complex-animation
//
//  Created by Nguyen Van Thuan on 13/03/2023.
//

import SwiftUI

struct Book: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var imageName: String
    var author: String
    var rating: Int
    var bookView: Int
}

var sampleBooks: [Book] = [
    .init(title: "Booking One", imageName: "book_1", author: "Van Thuan", rating: 4, bookView: 200),
    .init(title: "Booking Two", imageName: "book_2", author: "Van Thuan", rating: 3, bookView: 250),
    .init(title: "Booking Three", imageName: "book_3", author: "Van Thuan", rating: 4, bookView: 99),
    .init(title: "Booking Four", imageName: "book_4", author: "Van Thuan", rating: 5, bookView: 399),
    .init(title: "Booking Five", imageName: "book_5", author: "Van Thuan", rating: 2, bookView: 410),
]
