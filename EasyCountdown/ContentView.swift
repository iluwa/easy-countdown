//
//  ContentView.swift
//  EasyCountdown
//
//  Created by Ilia Koliaskin on 19/11/2024.
//

import SwiftUI
import CoreData
import Foundation

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.date, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Your Events").font(.title)
                    .foregroundColor(.primary).bold().padding(.bottom, 10)) {
                        ForEach(items) { item in
                            NavigationLink {
                                Text("Item at \(item.date!, formatter: itemFormatter)")
                            } label: {
                                HStack {
                                    VStack(alignment: .center) {
                                        Text("\(item.date!.days(from: Date()))")
                                            .font(.title)
                                            .foregroundColor(.primary)
                                        Text("days")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .frame(minWidth: 40)
                                    .padding(.trailing, 10)
                                    VStack(alignment: .leading) {
                                        Text(item.name!)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                        Text("\(item.date!, formatter: itemFormatter)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                
                Section{
                    Button(action: {
                        addItem()
                    }) {
                        Label("Add event", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.primary)
                    }
                }.listRowBackground(Color.blue)
                
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.date = Date()
            newItem.name = ""
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

extension Date {
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
