import Foundation
import RealmSwift

// 标本
class Specimen: Object {
    @objc dynamic var name = ""
    @objc dynamic var specimenDescription = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var created = Date()
    // 在标本和类别之间建立一对多关系：每个标本只能属于一个类别，但每个类别可以有很多标本
    @objc dynamic var category: Category!
}
