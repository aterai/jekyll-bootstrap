---
layout: post
category: swing
folder: InsertSiblingNode
title: JTreeの選択されたノードの前後に新規ノードを挿入する
tags: [JTree, JPopupMenu, DefaultMutableTreeNode, TreeNode, TreeModel]
author: aterai
pubdate: 2016-07-04T00:56:54+09:00
description: JTreeのノードを選択してポップアップメニューを開き、その前または後ろに新規ノードを挿入します。
comments: true
---
## 概要
`JTree`のノードを選択してポップアップメニューを開き、その前または後ろに新規ノードを挿入します。

{% download https://lh3.googleusercontent.com/-P_GnYongQ64/V3kweryY25I/AAAAAAAAOdI/CqWS6tum8402qaWo1130iBF5r1tVPkJCwCCo/s800/InsertSiblingNode.png %}

## サンプルコード
<pre class="prettyprint"><code>Action addAboveAction = new AbstractAction("insert preceding sibling node") {
  @Override public void actionPerformed(ActionEvent e) {
    JTree tree = (JTree) getInvoker();
    DefaultTreeModel model = (DefaultTreeModel) tree.getModel();
    MutableTreeNode self   = (MutableTreeNode) path.getLastPathComponent();
    MutableTreeNode parent = (MutableTreeNode) self.getParent();
    MutableTreeNode child  = new DefaultMutableTreeNode("New preceding sibling");
    int index = model.getIndexOfChild(parent, self);
    parent.insert(child, index);
    model.reload(parent);
    //or: model.insertNodeInto(child, parent, index);
  }
};
Action addBelowAction = new AbstractAction("insert following sibling node") {
  @Override public void actionPerformed(ActionEvent e) {
    JTree tree = (JTree) getInvoker();
    DefaultTreeModel model = (DefaultTreeModel) tree.getModel();
    MutableTreeNode self   = (MutableTreeNode) path.getLastPathComponent();
    MutableTreeNode parent = (MutableTreeNode) self.getParent();
    MutableTreeNode child  = new DefaultMutableTreeNode("New following sibling");
    int index = model.getIndexOfChild(parent, self);
    parent.insert(child, index + 1);
    model.reload(parent);
    //or: model.insertNodeInto(child, parent, index + 1);
  }
};
</code></pre>

## 解説
- `add child node`
    - 選択されたノードの子ノードとして新規ノードを追加
    - [JTreeのノード追加、削除](http://ateraimemo.com/Swing/AddNode.html)
- `insert preceding sibling node`
    - 選択されたノードの兄ノードとして新規ノードを追加
- `insert following sibling node`
    - 選択されたノードの弟ノードとして新規ノードを追加

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTreeのノード追加、削除](http://ateraimemo.com/Swing/AddNode.html)

<!-- dummy comment line for breaking list -->

## コメント
