//
//  SampleData.swift
//  IndCurriculum
//
//  Created by Akmaral on 3/15/21.
//

import Foundation

struct SampleData: Codable {
    let iupSid, title, documentURL, academicYearID: String
    let academicYear: String
    let semesters: [Semester]

    enum CodingKeys: String, CodingKey {
        case iupSid = "IUPSid"
        case title = "Title"
        case documentURL = "DocumentURL"
        case academicYearID = "AcademicYearId"
        case academicYear = "AcademicYear"
        case semesters = "Semesters"
    }
}

struct Semester: Codable {
    let number: String
    let disciplines: [Discipline]

    enum CodingKeys: String, CodingKey {
        case number = "Number"
        case disciplines = "Disciplines"
    }
}

struct Discipline: Codable {
    let disciplineID: String
    let disciplineName: DisciplineName
    let lesson: [Lesson]

    enum CodingKeys: String, CodingKey {
        case disciplineID = "DisciplineId"
        case disciplineName = "DisciplineName"
        case lesson = "Lesson"
    }
}

// MARK: - DisciplineName
struct DisciplineName: Codable {
    let nameKk, nameRu, nameEn : String?
}

// MARK: - Lesson
struct Lesson: Codable {
    let lessonTypeID, hours, realHours: String

    enum CodingKeys: String, CodingKey {
        case lessonTypeID = "LessonTypeId"
        case hours = "Hours"
        case realHours = "RealHours"
    }
}

