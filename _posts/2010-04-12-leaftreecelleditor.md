---
layout: post
category: swing
folder: LeafTreeCellEditor
title: JTreeの葉ノードだけ編集可能にする
tags: [JTree, TreeCellEditor, TreeNode]
author: aterai
pubdate: 2010-04-12T18:23:41+09:00
description: JTreeのノードラベル編集が、葉ノードの場合だけ可能になるよう設定します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTPB-TVk9I/AAAAAAAAAdU/Aq5YDSMvqaY/s800/LeafTreeCellEditor.png
comments: true
---
## 概要
`JTree`のノードラベル編集が、葉ノードの場合だけ可能になるよう設定します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTPB-TVk9I/AAAAAAAAAdU/Aq5YDSMvqaY/s800/LeafTreeCellEditor.png %}

## サンプルコード
<pre class="prettyprint"><code>class LeafTreeCellEditor extends DefaultTreeCellEditor {
  protected LeafTreeCellEditor(JTree tree, DefaultTreeCellRenderer renderer) {
    super(tree, renderer);
  }
  @Override public boolean isCellEditable(EventObject e) {
    Object o = tree.getLastSelectedPathComponent();
    if (super.isCellEditable(e) &amp;&amp; o instanceof TreeNode) {
      return ((TreeNode) o).isLeaf();
    } else {
      return false;
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`CellEditor#isCellEditable(...)`メソッドをオーバーライドし、葉ノードのみ編集が可能にしたセルエディタを作成し、これを`JTree#setCellEditor(...)`メソッドで設定しています。

<pre class="prettyprint"><code>tree.setCellEditor(
  new LeafTreeCellEditor(tree, (DefaultTreeCellRenderer) tree.getCellRenderer()));
</code></pre>

## 参考リンク
- [CellEditor#isCellEditable(EventObject) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/CellEditor.html#isCellEditable-java.util.EventObject-)
- [Swing - How can I persist all changes I made to these edited leaves and nodes??](https://community.oracle.com/thread/1371600)

<!-- dummy comment line for breaking list -->

## コメント
