import SwiftUI

struct SigninView: View {
  @Binding var showSignup: Bool
  @State private var email = ""
  @State private var password = ""
  @State private var errorMessage = ""

  var body: some View {
    VStack {
      TextField("Email", text: $email)
      SecureField("Password", text: $password)
      Button("Signin") {
        self.signin()
      }
      .alert(isPresented: .constant(!errorMessage.isEmpty)) {
        Alert(title: Text("Error"), message: Text(errorMessage))
      }
      Button("Create Account") {
        self.showSignup.toggle()
      }
    }
    .padding()
  }

  func signin() {
    guard let url = URL(string: "http://localhost:3000/signin") else {
      print("Invalid URL")
      return
    }

    let body: [String: String] = [
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
          
        } catch {
          print("Error parsing JSON: \(error.localizedDescription)")
          self.errorMessage = error.localizedDescription
        }
      }
    }.resume()
  }
}

struct SigninView_Previews: PreviewProvider {
  @State static var showSignup = false

  static var previews: some View {
    SigninView(showSignup: $showSignup)
      .previewLayout(.sizeThatFits)
      .padding()
  }
}
