//
//  ContentView.swift
//  asynchronousApp
//
//  Created by Evan Armstrong on 2021-02-19.
//

import SwiftUI

struct ContentView: View {
    
    //Mark: Stored propertie
    @State var someText = "Hello"
    
    var body: some View {
        
        VStack {
            
        Text(someText)
            .padding()
            .onAppear(){
    
    fetchQuote ()
            }
            Button("Get another quote"){
                fetchQuote()
            }
            }
        
    }


    func fetchQuote() {
        
        let url = URL (string: "https://api.forismatic.com/api/1.0/?method=getQuote&key=457653&format=json&lang=en")!
        
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
            if let DecodedAsynchronousQuote = try? JSONDecoder().decode(AsynchronousQuote.self, from:  Quote) {

                // DEBUG:
                print("Quote data decoded from JSON successfully")
                
                print("""
                    The Quote is:
                    \(DecodedAsynchronousQuote.quoteText)
                    """)

                // Now, update the UI on the main thread
                DispatchQueue.main.async {
                    
                    someText = DecodedAsynchronousQuote.quoteText
                
                }

            } else {

                print("Could not decode JSON into an instance of the fetchQuote structure.")

            }

        }.resume()
        // NOTE: Invoking the resume() function
        // on the dataTask closure is key. The request will not
        // run, otherwise.

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
