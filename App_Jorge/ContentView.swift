//
//  ContentView.swift
//  trial_1
//
//  Created by Valeria Bladinieres on 12/12/22.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers
import Combine


var imagesArr = ["logo_1","logo_2","logo_3","logo_4","logo_5","logo_6"]

var p_buttons = ["p1","p2","p3","p4","p5","p6"]
var m_buttons = ["m1","m2","m3","m4","m5","m6"]
var precios = [50,45,30,25,20,15]

var historial = [0,0,0,0,0,0]
var t_global = 0

private var gridItemLayout = [ GridItem(.flexible())
                               ,GridItem(.flexible())
                               ,GridItem(.flexible())
                               ,GridItem(.flexible())]
private var gridItemLayout_2 = [ GridItem(.flexible(),  alignment: .trailing)
                                 ,GridItem(.flexible(), alignment: .leading)]
                                          

struct ContentView: View {
    @State private var v_label = [0,0,0,0,0,0]
    @State private var showingPopover = false
    @State private var document: MessageDocument = MessageDocument(message: "")
    @State var isExporting = false
    @State var date_t = ""
    @State var t_local = 0
    @State var change = ""
    @State var t_change = 0
    @State var showingAlert: Bool = false
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 10) {
                ForEach((0...5), id: \.self) {
                    Image(imagesArr[$0 % imagesArr.count])
                    let p = p_buttons[$0 % p_buttons.count]
                    let m = m_buttons[$0 % m_buttons.count]
                    Text(" - ").onTapGesture {
                        t_local = calculations(value: m)}
                    .bold()
                    .font(.system(size: 45))
                    .background(.yellow)
                    Text("\(v_label[$0 % v_label.count])")
                        .bold()
                        .font(.system(size: 35))
                        //.background(.gray)
                    Text(" + ").onTapGesture {
                        t_local = calculations(value: p)}
                    .bold()
                    .font(.system(size: 45))
                    .background(.yellow)
                }
            }
            LazyVGrid(columns: gridItemLayout_2, spacing: 10) {
                Text("    Total ")
                    //.bold()
                    .font(.system(size: 40))
                    //.background(.blue)
                Text("\(t_local)")
                    //.bold()
                    .font(.system(size: 30))
                    .foregroundColor(.red)
                    //.background(.blue)
                Text(" Billetes ")
                    //.bold()
                    .font(.system(size: 30))
                    //.background(.orange)
                TextField("billetes", text: $change)
                    .keyboardType(.numberPad)
                    .font(.system(size: 30))
                    //.background(.gray)
                    .onReceive(Just(change)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            change = filtered
                        }
                    }
            }
                Text(" Cambio ").onTapGesture {
                    t_change = 0 //change
                    t_change = Int(change) ?? 0
                    t_change = t_change - t_local
                    print (t_change)
                }
                    .bold()
                    .font(.system(size: 40))
                    .background(.blue)
                    .foregroundColor(.white)
                Text("   \(t_change)   ")
                    .bold()
                    .font(.system(size: 30))
                    //.background(.gray)
            LazyVGrid(columns: gridItemLayout_2, spacing: 10) {
                Text("  Pagar  ").onTapGesture {
                    showingAlert = true
                    t_global = t_global + t_local
                    historial = zip(v_label,historial).map(+)
                    
                }.alert(isPresented: $showingAlert, content: {
                    Alert(title: Text("Pagado"), message: Text("Total: \(t_local), Billetes: \(change), Cambio: \(t_change)"), dismissButton: .default(Text("OK")){
                            v_label = [0,0,0,0,0,0]
                            t_local = 0
                            change = ""
                            t_change = 0})
                })
                    .bold()
                    .font(.system(size: 40))
                    .background(.green)
                Text("  Borrar  ").onTapGesture {
                        v_label = [0,0,0,0,0,0]
                        t_local = 0
                        change = ""
                        t_change = 0
                }
                    .bold()
                    .font(.system(size: 40))
                    .background(.red)
            }
                Button("  Exportar  ") {
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    date_t = dateFormatter.string(from: date)
                    document.message =  "\(date_t), \(historial[0]), \(historial[1]), \(historial[2]), \(historial[3]), \(historial[4]), \(historial[5]), \(t_global)"
                    print (date_t)
                    print (document.message)
                    isExporting = true
                }
                .bold()
                .font(.system(size: 40))
                .background(.blue)
                .foregroundColor(.white)
                .fileExporter(
                    isPresented: $isExporting,
                    document: document,
                    contentType: .plainText,
                    defaultFilename: "ventas_jorge" )
                {result in
                    if case .success = result {
                        historial = [0,0,0,0,0,0]
                        t_global = 0
                        change = ""
                        t_change = 0
                    } else {
                        // Handle failure.
                    }
                }
        }
        .padding(4)
    }
    
    func calculations(value: String) -> Int{
        if value == "m1" {
            v_label[0] = v_label[0]-1
        }
        if value == "m2" {
            v_label[1] = v_label[1]-1
        }
        if value == "m3" {
            v_label[2] = v_label[2]-1
        }
        if value == "m4" {
            v_label[3] = v_label[3]-1
        }
        if value == "m5" {
            v_label[4] = v_label[4]-1
        }
        if value == "m6" {
            v_label[5] = v_label[5]-1
        }
        if value == "p1" {
            v_label[0] = v_label[0]+1
        }
        if value == "p2" {
            v_label[1] = v_label[1]+1
        }
        if value == "p3" {
            v_label[2] = v_label[2]+1
        }
        if value == "p4" {
            v_label[3] = v_label[3]+1
        }
        if value == "p5" {
            v_label[4] = v_label[4]+1
        }
        if value == "p6" {
            v_label[5] = v_label[5]+1
        }
        
        var t_total = 0
        for i in 0...v_label.count-1 {
            if v_label[i]<0{
                v_label[i]=0
            }
            else{
                t_total = t_total+precios[i]*v_label[i]
            }
            
        }
        print (value,v_label,t_total)
        return t_total
    }
}

struct MessageDocument: FileDocument {
    
    static var readableContentTypes: [UTType] { [.plainText] }

    var message: String

    init(message: String) {
        self.message = message
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        message = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: message.data(using: .utf8)!)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

