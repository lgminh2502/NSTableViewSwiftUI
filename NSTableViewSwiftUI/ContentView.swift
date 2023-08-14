//
//  ContentView.swift
//  NSTableViewSwiftUI
//
//  Created by Admin on 14/08/2023.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var viewModel = NotListViewModel<ListItem>()
    
    func onViewAppear() {
        viewModel.elements = [
            ListItem(title: "Item 1", action: { [weak self] in
                self?.onClick(text: "item 1")
            }),
            ListItem(title: "Item 2", action: { [weak self] in
                self?.onClick(text: "item 2")
            }),
            ListItem(title: "Item 3", action: { [weak self] in
                self?.onClick(text: "item 3")
            }),
        ]
    }
    
    private func onClick(text: String) {
        print("onClick \(text)")
    }
}

struct ContentView: View {
    
    @StateObject var model: ViewModel = ViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            let factory = ConsoleRowFactory(showInConsole: nil)
            NotList(model: model.viewModel, makeRowView: factory.makeRowView, onSelectRow: { index in
                
            }, onDoubleClickRow: {_ in
                
            }, isEmphasizedRow: {_ in
                return true
            })
        }
        .onAppear {
            model.onViewAppear()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private let messageViewId = NSUserInterfaceItemIdentifier(rawValue: "messageViewId")
private let requestViewId = NSUserInterfaceItemIdentifier(rawValue: "requestViewId")

struct ConsoleRowFactory {
//    let context: AppContext
    var showInConsole: ((ListItem) -> Void)?

    func makeRowView(_ item: ListItem, _ tableView: NSTableView) -> NSView? {
        var show: (() -> Void)?
        if let showInConsole = showInConsole {
            show = { showInConsole(item) }
        }
        
        let view = tableView.makeView(withIdentifier: requestViewId, owner: nil) as? ItemCellView ?? ItemCellView()
        view.identifier = requestViewId
        view.display(item: item)
        return view
//
//        if let request = message.request {
//            var view = tableView.makeView(withIdentifier: requestViewId, owner: nil) as? ConsoleNetworkRequestView
//            if view == nil {
//                view = ConsoleNetworkRequestView()
//                view!.identifier = requestViewId
//            }
//
//            view!.display(.init(message: message, request: request, context: context, showInConsole: show))
//            return view
//        } else {
//            var view = tableView.makeView(withIdentifier: messageViewId, owner: nil) as? ConsoleMessageView
//            if view == nil {
//                view = ConsoleMessageView()
//                view!.identifier = messageViewId
//            }
//
//            view!.display(.init(message: message, context: context, showInConsole: show))
//            return view
//        }
    }
}

class ItemCellView: NSView {
    private let title = NSTextField.label()
    private let details = NSTextField.label()
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        createView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createView()
    }

    private func createView() {
        addSubview(title)
        addSubview(details)

        title.font = .preferredFont(forTextStyle: .caption1, options: [:])
        title.textColor = NSColor.black
    }

    override func layout() {
        super.layout()
        title.sizeToFit()
        title.frame = CGRect(x: 15, y: 30, width: title.bounds.size.width, height: title.bounds.size.height)

        details.frame = CGRect(x: 0, y: 5, width: bounds.width, height: 20)
    }
    
    func display(item: ListItem) {
        title.stringValue = item.title
        details.stringValue = item.id.uuidString
    }
}

extension NSTextField {
    static func label() -> NSTextField {
        let label = NSTextField()
        label.isBezeled = false
        label.drawsBackground = false
        label.isEditable = false
        label.isSelectable = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }
}
