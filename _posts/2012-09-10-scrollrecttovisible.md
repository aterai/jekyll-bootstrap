---
layout: post
category: swing
folder: ScrollRectToVisible
title: JScrollPane内にあるJTableなどで追加した行が可視化されるようにスクロールする
tags: [JScrollPane, JViewport, JTable, JList, JTree]
author: aterai
pubdate: 2012-09-10T16:06:04+09:00
description: JScrollPaneのJViewport内にあるJTable、JList、JTreeで、それぞれ追加された最終行が可視化されるようにスクロールします。
image: https://lh3.googleusercontent.com/-t_4BD1mGUGk/UE1eF0Ead3I/AAAAAAAABSM/4a4aPSpMDM4/s800/ScrollRectToVisible.png
comments: true
---
## 概要
`JScrollPane`の`JViewport`内にある`JTable`、`JList`、`JTree`で、それぞれ追加された最終行が可視化されるようにスクロールします。

{% download https://lh3.googleusercontent.com/-t_4BD1mGUGk/UE1eF0Ead3I/AAAAAAAABSM/4a4aPSpMDM4/s800/ScrollRectToVisible.png %}

## サンプルコード
<pre class="prettyprint"><code>model.addRow(new Object[] {date.toString(), model.getRowCount(), false});
int i = table.convertRowIndexToView(model.getRowCount() - 1);
Rectangle r = table.getCellRect(i, 0, true);
table.scrollRectToVisible(r);
</code></pre>

## 解説
- `JTable`
    - `JTable#scrollRectToVisible(Rectangle)`を使用して追加した行の`0`列目のセル領域までスクロール
    - ソートやフィルタが使用されている場合を考慮して追加した行のインデックスを`JTable#convertRowIndexToView(int)`で変換してからセル領域を取得

<!-- dummy comment line for breaking list -->

- `JList`
    - [JList#ensureIndexIsVisible(int)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JList.html#ensureIndexIsVisible-int-)を使って、追加した最終行を可視化(このメソッド内部で`scrollRectToVisible`を使用)
        
        <pre class="prettyprint"><code>Rectangle cellBounds = list.getCellBounds(index, index);
        if (cellBounds != null) {
          list.scrollRectToVisible(cellBounds);
        }
</code></pre>
- `JTree`
    - [JTree#scrollRowToVisible(int)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTree.html#scrollRowToVisible-int-)、または[JTree#scrollPathToVisible(TreePath)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTree.html#scrollPathToVisible-javax.swing.tree.TreePath-)で追加した最終行を可視化
    - `tree.scrollRowToVisible(row)`は`tree.scrollPathToVisible(tree.getPathForRow(row))`と同等
    - `JTree#scrollPathToVisible(TreePath)`は内部で`tree.scrollRectToVisible(tree.getPathBounds(path))`を使用している
        
        <pre class="prettyprint"><code>DefaultTreeModel treeModel = (DefaultTreeModel) tree.getModel();
        DefaultMutableTreeNode parent = (DefaultMutableTreeNode) treeModel.getRoot();
        DefaultMutableTreeNode newChild = new DefaultMutableTreeNode(date);
        treeModel.insertNodeInto(newChild, parent, parent.getChildCount());
        /* //tree.scrollRowToVisible(row) == tree.scrollPathToVisible(tree.getPathForRow(row))
        tree.scrollRowToVisible(tree.getRowCount() - 1);
        /*/
        tree.scrollPathToVisible(new TreePath(newChild.getPath()));
        //*/
</code></pre>
    - * 参考リンク [#reference]
- [JScrollPaneのViewportをマウスで掴んでスクロール](https://ateraimemo.com/Swing/HandScroll.html)
    - `JComponent#scrollRectToVisible(...)`を使用してスクロール
- [JTextPaneで最終行に移動](https://ateraimemo.com/Swing/CaretPosition.html)
    - キャレットの移動でスクロール

<!-- dummy comment line for breaking list -->

## コメント
