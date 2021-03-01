//
//  datamodel.swift
//  Research Papers
//
//  Created by 康景炫 on 2020/12/17.
//

import Foundation

struct techReport: Decodable {
    let year: String
    let id: String
    let owner: String?
    let email: String?
    let authors: String
    let title: String
    let abstract: String?
    let pdf: URL?
    let comment: String?
    let lastModified: String
}
struct technicalReports: Decodable {
    let techreports2: [techReport]
}
