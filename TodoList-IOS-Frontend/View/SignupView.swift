import SwiftUI

struct SignupView: View {
  @Binding var showSignup: Bool
  @State private var name = ""
  @State private var email = ""
  @State private var password = ""
  @State private var errorMessage = ""

  var body: some View {
    VStack {
      TextField("Name", text: $name)
      TextField("Email", text: $email)
      SecureField("Password", text: $password)
      Button("Signup") {
        self.signup()
      }
      .alert(isPresented: .constant(!errorMessage.isEmpty)) {
        Alert(title: Text("Error"), message: Text(errorMessage))
      }
      Button("Back to Signin") {
        self.showSignup.toggle()
      }
    }
    .padding()
  }

  func signup() {
    guard let url = URL(string: "http://localhost:3000/signup") else {
      print("Invalid URL")
      return
    }

    let body: [String: String] = [
      "name": name,
      "email": email,
      "password": password
    ]

    var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
        self.errorMessage = error.localizedDescription
      } else if let data = data {
        do {
          let json = try JSONSerialization.jsonObject(with: data)
          print("Response: \(json)")
          // Signup successful, update showSignup state
          self.showSignup.toggle()
        } catch {
          print("Error parsing JSON: \(error.localizedDescription)")
          self.errorMessage = error.localizedDescription
        }
      }
    }.resume()
  }
}

struct SignupView_Previews: PreviewProvider {
  @State static var showSignup = true

  static var previews: some View {
    SignupView(showSignup: $showSignup)
      .previewLayout(.sizeThatFits)
      .padding()
  }
}
