/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

// A simple application storage class for our app.
class Database {
  static var sharedInstance = Database()
  lazy var contacts: [Contact] =
    [("Marc", "Jackson", "0032", "654321", "boy"),
     ("Jef", "Le Roy", "0052", "123456", "boy"),
     ("Phill", "Ivry", "0088", "098765", "boy"),
     ("Oscar", "O'Neil", "0032", "567890", "boy"),
     ("Penny", "Le Roy", "0052", "135792", "girl"),
     ("Maxime", "Defauw", "0088", "246801", "boy"),
     ("Ray", "Wenderlich", "0032", "114527", "boy"),
     ("Violette", "Le Roy", "0052", "562283", "girl"),
     ("", "Bentham", "0088", "778467", "unknown"),
     ("Sebastian", "Bommer", "0043", "978786", "boy"),
     ("Charlotte", "Sky", "0052", "123444", "girl"),
     ("Thomas", "Valette", "0088", "946733", "boy"),
     ("Claire", "Graham", "0088", "090987", "girl"),
     ("Valeria", "Flower", "0088", "655473", "girl"),
     ("Jullie", "Closs", "0074", "128876", "girl"),
     ("Junior", "Resp", "0074", "145836", "boy"),
     ("Eddie", "Broe", "0022", "673698", "boy"),
     ("Charise", "Ivry", "0022", "0936798", "girl"),
     ("Sal", "Addis", "0022", "783940", "boy"),
     ("Bebe", "Cashwell", "0032", "264826", "girl"),
     ("Allan", "Germaine", "0038", "936627", "boy"),
     ("Hipolito", "Churchill", "0032", "115468", "boy"),
     ("Danita", "Tseng", "0032", "904728", "girl"),
     ("Shelia", "Musson", "0083", "367289", "girl"),
     ("Arnold", "Nail", "0033", "647830", "boy"),
     ("Kimiko", "Patin", "0052", "543794", "girl"),
     ("Hattie", "Steffes", "0078", "647730", "girl"),
     ("Evia", "Harkleroad", "0078", "894003", "girl"),
     ("Murray", "Marasco", "0078", "667468", "boy"),
     ("Albertina", "Landy", "0065", "478204", "girl"),
     ("Efren", "Earle", "0089", "647390", "boy") ]
        .map { (firstName, lastName, countryCode, numberString, avatar) -> Contact in

      let contact = Contact(firstName: firstName, lastName: lastName, avatar: avatar)
      let number = Number(countryCode: countryCode, numberString: numberString, contact: contact)

      contact.number = number
      return contact
    }

  private init() {}
}
