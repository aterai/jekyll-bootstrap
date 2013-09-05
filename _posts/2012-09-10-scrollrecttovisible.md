---
layout: post
title: JScrollPane内にあるJTableなどで追加した行が可視化されるようにスクロールする
category: swing
folder: ScrollRectToVisible
tags: [JScrollPane, JViewport, JTable, JList, JTree]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-09-10

## JScrollPane内にあるJTableなどで追加した行が可視化されるようにスクロールする
`JScrollPane`の`JViewport`内にある`JTable`、`JList`、`JTree`で、それぞれ追加された最終行が可視化されるようにスクロールします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/-t_4BD1mGUGk/UE1eF0Ead3I/AAAAAAAABSM/4a4aPSpMDM4/s800/ScrollRectToVisible.png)

### サンプルコード
<pre class="prettyprint"><code>model.addRow(new Object[] {date.toString(), model.getRowCount(), false});
int i = table.convertRowIndexToView(model.getRowCount()-1);
Rectangle r = table.getCellRect(i, 0, true);
table.scrollRectToVisible(r);
</code></pre>

### 解説
- `JTable`
    - 追加した行の`0`列目のセル領域を取得して、`scrollRectToVisible`で可視化
    - ソートやフィルターが使用されている場合を考慮して、追加した行のインデックスを`JTable#convertRowIndexToView(int)`で変換してから、セル領域を取得

<!-- dummy comment line for breaking list -->

- `JList`
    - [JList#ensureIndexIsVisible(int)](http://docs.oracle.com/javase/jp/6/api/javax/swing/JList.html#ensureIndexIsVisible%28int%29)を使って、追加した最終行を可視化(このメソッド内部で`scrollRectToVisible`を使用)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>Rectangle cellBounds = list.getCellBounds(index, index);
if(cellBounds != null) {
  list.scrollRectToVisible(cellBounds);
}
</code></pre>

- `JTree`
    - [JTree#scrollRowToVisible(int)](http://docs.oracle.com/javase/jp/6/api/javax/swing/JTree.html#scrollRowToVisible%28int%29)、または[JTree#scrollPathToVisible(TreePath)](http://docs.oracle.com/javase/jp/6/api/javax/swing/JTree.html#scrollPathToVisible%28javax.swing.tree.TreePath%29)で追加した最終行を可視化
    - `tree.scrollRowToVisible(row)`は `tree.scrollPathToVisible(tree.getPathForRow(row))`と同等
    - `JTree#scrollPathToVisible(TreePath)`は内部で、`tree.scrollRectToVisible(tree.getPathBounds(path))`を使用

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>DefaultTreeModel treeModel = (DefaultTreeModel)tree.getModel();
DefaultMutableTreeNode parent   = (DefaultMutableTreeNode)treeModel.getRoot();
DefaultMutableTreeNode newChild = new DefaultMutableTreeNode(date);
treeModel.insertNodeInto(newChild, parent, parent.getChildCount());
/* //tree.scrollRowToVisible(row) == tree.scrollPathToVisible(tree.getPathForRow(row))
tree.scrollRowToVisible(tree.getRowCount()-1);
/*/
tree.scrollPathToVisible(new TreePath(newChild.getPath()));
//*/
</code></pre>

### 参考リンク
- [JScrollPaneのViewportをマウスで掴んでスクロール](http://terai.xrea.jp/Swing/HandScroll.html)
    - `JComponent#scrollRectToVisible(...)`を使用してスクロール
- [JTextPaneで最終行に移動](http://terai.xrea.jp/Swing/CaretPosition.html)
    - キャレットの移動でスクロール

<!-- dummy comment line for breaking list -->

### コメント