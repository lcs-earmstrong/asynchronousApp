//
//  ContentView.swift
//  asynchronousApp
//
//  Created by Evan Armstrong on 2021-02-19.
//

import SwiftUI

struct ContentView: View {
    
    //Mark: Stored propertie
   @State var SomeText = "Hello, World!"
    
    var body: some View {
        
        VStack {
            
        Text(SomeText)
            .padding()
            .onAppear(){
    
    fetchQuote ()
            }
            }
    }
}

    func fetchQuote() {
        
        let url = URL (string: "https://forismatic.com/en/")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let Quote = data else {
                
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")

                // Don't continue past this point
                return

            }
            if let DecodedAsynchronousQuote = try? JSONDecoder().decode(AsynchronousQuote.self, from: Quote) {

                // DEBUG:
                print("Quote data decoded from JSON successfully")
                
                print("""
                    The Quote is:
                    \(DecodedAsynchronousQuote.quote)
                    """)

                // Now, update the UI on the main thread
                DispatchQueue.main.async {
                    
                    SomeText = DecodedAsynchronousQuote.quote
                
                }

            } else {

                print("Could not decode JSON into an instance of the DadJoke structure.")

            }

        }.resume()
        // NOTE: Invoking the resume() function
        // on the dataTask closure is key. The request will not
        // run, otherwise.

    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
