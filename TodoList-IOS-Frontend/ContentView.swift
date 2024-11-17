import SwiftUI


struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var showSignup = false

    var body: some View {
        ZStack {
     
          
            
            VStack {
                if isLoggedIn {
                    
                    Text("Welcome!")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                        .transition(.scale)
                } else {
                
                    if showSignup {
                        SignupView(showSignup: $showSignup)
                            .transition(.move(edge: .bottom))
                    } else {
                        SigninView(showSignup: $showSignup)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
            .padding()
            
        }
        .animation(.bouncy, value: showSignup)
        
    }
}


#Preview {
    ContentView()
}
