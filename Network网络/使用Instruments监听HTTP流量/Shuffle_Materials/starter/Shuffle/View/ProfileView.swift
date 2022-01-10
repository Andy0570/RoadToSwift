/// Copyright (c) 2021 Razeware LLC
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct ProfileView: View {
  @ObservedObject var viewModel = ProfileViewModel()
  @State private var currentUser: User? = User.currentUser
  @State private var username: String = ""
  @State private var password: String = ""

  var body: some View {
    NavigationView {
      VStack {
        VStack {
          if let currentUser = currentUser {
            Text("Welcome back, " + currentUser.loginId + "!")
          } else {
            TextField("Enter Username", text: $username)
              .textContentType(.username)
              .textFieldStyle(.roundedBorder)
            SecureField("Enter Password", text: $password)
              .textContentType(.password)
              .textFieldStyle(.roundedBorder)
            Button("Login") {
              DataProvider.sharedInstance.login(userName: username, password: password) { user in
                User.currentUser = user
                currentUser = user
                viewModel.loadData()
              }
            }
          }
        }
        .padding()
        List(viewModel.activities) { activity in
          Text(activity.message)
            .padding(8)
        }
      }
      .navigationTitle("My Activity")
      .navigationBarTitleDisplayMode(.inline)
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .onAppear {
      if User.currentUser != nil {
        viewModel.loadData()
      }
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    let sampleData = ProfileViewModel(withActivities: [Activity.sample])
    return ProfileView(viewModel: sampleData)
  }
}
