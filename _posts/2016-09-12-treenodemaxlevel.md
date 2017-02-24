---
layout: post
category: swing
folder: TreeNodeMaxLevel
title: JTreeでノード階層の深さを取得する
tags: [JTree, TreePath, DefaultMutableTreeNode]
author: aterai
pubdate: 2016-09-12T01:36:56+09:00
description: JTreeでノード階層の深さ(TreePath内の要素数)を取得し、それに応じてノード追加の制限を行います。
image: https://drive.google.com/uc?export=view&amp;id=1ozunqsWtmzdel3isGcmth6R1GRxkSju28Q
comments: true
---
## 概要
`JTree`でノード階層の深さ(`TreePath`内の要素数)を取得し、それに応じてノード追加の制限を行います。

{% download https://drive.google.com/uc?export=view&amp;id=1ozunqsWtmzdel3isGcmth6R1GRxkSju28Q %}

## サンプルコード
<pre class="prettyprint"><code>private void updateLabel(TreePath path) {
  countLabel.setText("PathCount: " + path.getPathCount());
  Object o = path.getLastPathComponent();
  if (o instanceof DefaultMutableTreeNode) {
    DefaultMutableTreeNode n = (DefaultMutableTreeNode) o;
    levelLabel.setText("Level: " + n.getLevel());
  }
}
//...
JTree tree = (JTree) getInvoker();
TreePath path = tree.getSelectionPath();
if (path.getPathCount() &lt; 3) {
  DefaultTreeModel model = (DefaultTreeModel) tree.getModel();
  DefaultMutableTreeNode self  = (DefaultMutableTreeNode) path.getLastPathComponent();
  DefaultMutableTreeNode child = new DefaultMutableTreeNode("New child node");
  self.add(child);
  model.reload(self);
} else {
  JOptionPane.showMessageDialog(tree, "ERROR: Maximum levels of 2 exceeded.");
}
</code></pre>

## 解説
上記のサンプルでは、`TreePath#getPathCount()`、または`DefaultMutableTreeNode#getLevel()`メソッドを使用してノード階層の深さを取得し、指定したレベルを超えるノードを作成できないように制限しています。

- メモ:
    - ルートパスの`TreePath#getPathCount()`は`1`、ルートノードの`DefaultMutableTreeNode#getLevel()`は`0`
    - `TreePath#getPathCount()`、`DefaultMutableTreeNode#getLevel()`の返り値は、ルートノードの可視・不可視には依存しない

<!-- dummy comment line for breaking list -->

## コメント
