---
layout: post
category: swing
folder: ExpandAllNodes
title: JTreeのノードを展開・折り畳み
tags: [JTree, TreeNode, TreePath]
author: aterai
pubdate: 2007-05-07T17:11:21+09:00
description: JTreeのすべてのノードに対して、展開、折り畳みを行います。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMS3T9nvI/AAAAAAAAAY8/ooi4QMbp6fA/s800/ExpandAllNodes.png
comments: true
---
## 概要
`JTree`のすべてのノードに対して、展開、折り畳みを行います。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMS3T9nvI/AAAAAAAAAY8/ooi4QMbp6fA/s800/ExpandAllNodes.png %}

## サンプルコード
<pre class="prettyprint"><code>// @see http://www.rgagnon.com/javadetails/java-0210.html
// Expand or collapse a JTree - Real's Java How-to
private void expandAll(JTree tree) {
  int row = 0;
  while (row &lt; tree.getRowCount()) {
    tree.expandRow(row);
    row++;
  }
}
private void collapseAll(JTree tree) {
  int row = tree.getRowCount() - 1;
  while (row &gt;= 0) {
    tree.collapseRow(row);
    row--;
  }
}

private void visitAll(JTree tree, TreePath parent, boolean expand) {
  TreeNode node = (TreeNode) parent.getLastPathComponent();
  // children(node).forEach(n -&gt; visitAll(tree, parent.pathByAddingChild(n), expand));
  if (!node.isLeaf()) {
    // Java 9: Enumeration&lt;TreeNode&gt; e = node.children();
    Enumeration&lt;?&gt; e = node.children();
    while (e.hasMoreElements()) {
      visitAll(tree, parent.pathByAddingChild(e.nextElement()), expand);
    }
  }
  if (expand) {
    tree.expandPath(parent);
  } else {
    tree.collapsePath(parent);
  }
}

// private static Stream&lt;TreeNode&gt; children(TreeNode node) {
//   // Java 9:
//   // return Collections.list(node.children()).stream();
//   // Java 8:
//   return Collections.list((Enumeration&lt;?&gt;) node.children())
//     .stream().filter(TreeNode.class::isInstance).map(TreeNode.class::cast);
// }
</code></pre>

## 解説
- `expandAll(A)`
    - `JTree`をリストとみなして`expandAll`では先頭から順番に`JTree#expandRow(int)`メソッドを実行
    - ループは全展開された時の`JTree`の行数だけ繰り返す
- `collapseAll(A)`
    - 末尾から順番に`JTree#collapseRow(int)`メソッドを実行し、表示されているすべてのノードを折り畳む
    - 子ノードは展開されているが、親ノードが折り畳まれている場合、その非表示となっている子ノードに対しては折り畳みを実行しない
- `expandAll(B)`
    - `visitAll(tree, new TreePath(root), true);`
    - 再帰的に`TreePath`を辿って、展開(`JTree#expandPath(TreePath)`メソッド)を実行
- `collapseAll(B)`
    - `visitAll(tree, new TreePath(root), false);`
    - 再帰的に`TreePath`を辿って、折り畳み(`JTree#collapsePath(TreePath)`メソッド)を実行

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Expand or collapse a JTree - Real's Java How-to](http://www.rgagnon.com/javadetails/java-0210.html)
- [JTreeのノードを検索する](https://ateraimemo.com/Swing/SearchBox.html)

<!-- dummy comment line for breaking list -->

## コメント
- 解説中のラベル`A`と`B`が、ソースコードとは逆になっていたので、これをソースコードと同じになるよう修正。 -- *aterai* 2008-02-05 (火) 19:31:53

<!-- dummy comment line for breaking list -->
