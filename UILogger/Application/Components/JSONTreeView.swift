//
//  JSONTreeView.swift
//  UILogger
//
//  Created by Ömer Hamid Kamışlı on 4/22/23.
//

import SwiftUI

struct JSONTreeView: View {
    @StateObject var rootNode: TreeNode

    var body: some View {
    
        VStack {
            HStack {
                Text("Log Date: \(rootNode.recivingDate)").foregroundColor(.red)
                Spacer()
            }
            
            if let children = rootNode.children, children.count > 0 {
                VStack(alignment: .leading) {
                    ForEach(children) { child in
                        JSONTreeNodeView(node: child)
                    }
                }
            } else {
                HStack {
                    Text(LocalizedStringKey(rootNode.valueDescription)).foregroundColor(.white)
                    Spacer()
                }
            }
            
            
            
            
        }
        .padding(16)
        .background(Color.black)
        .padding(16)
        .shadow(radius: 10)
        Divider().frame(height: 5).background(Color.gray)
        
    }
}

struct JSONTreeNodeView: View {
    @StateObject var node: TreeNode
    @State var isExpanded: Bool = false
    @State var showType: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            if let children = node.children, children.count > 0 {
                DisclosureGroup(isExpanded: $isExpanded) {
                    ForEach(node.children ?? []) { child in
                        JSONTreeNodeView(node: child)
                    }
                } label: {
                    HStack(spacing: 0) {
                        Text(node.key)
                        if !isExpanded {
                            Text("  (\(node.valueType.rawValue))")
                                .foregroundColor(.pink)
                        }
                    }
                    .onTapGesture { withAnimation {
                        isExpanded.toggle()
                    }}
                }
                
            } else {
                if node.valueType == .array, (node.value as! Array<Any>).count == 0 {
                    Text("\(node.key): []")
                } else {
                    HStack(spacing: 0) {
                        Text("\(node.key): ")
                        Text(LocalizedStringKey(node.valueDescription)).foregroundColor(node.valueType.color)
                        
                        if showType {
                            Text("  (\(node.valueType.rawValue))")
                                .foregroundColor(.cyan)
                        }
                        Spacer()
                    }
                    .onHover { val in
                        showType = val
                    }
                }
            }
        }
    }
    
    


}

struct JSONTreeView_Previews: PreviewProvider {
    static var previews: some View {
        JSONTreeView(rootNode: TreeNode(key: "root", value: "Hello World"))
    }
}
