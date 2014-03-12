---
layout: post
title: JTreeの葉ノードだけ編集可能にする
category: swing
folder: LeafTreeCellEditor
tags: [JTree, TreeCellEditor, TreeNode]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-04-12

## JTreeの葉ノードだけ編集可能にする
`JTree`の葉ノードだけ編集可能にします。

{% download %}

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTPB-TVk9I/AAAAAAAAAdU/Aq5YDSMvqaY/s800/LeafTreeCellEditor.png)

### サンプルコード
<pre class="prettyprint"><code>class LeafTreeCellEditor extends DefaultTreeCellEditor {
  public LeafTreeCellEditor(JTree tree, DefaultTreeCellRenderer renderer) {
    super(tree, renderer);
  }
  @Override public boolean isCellEditable(java.util.EventObject e) {
    boolean b = super.isCellEditable(e);
    Object o = tree.getLastSelectedPathComponent();
    if(b &amp;&amp; o instanceof TreeNode) {
      return ((TreeNode)o).isLeaf();
    }else{
      return b;
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、`CellEditor#isCellEditable`メソッドを葉ノードの場合だけ、編集を開始できるようにオーバーライドしたセルエディタを作成、設定しています。

<pre class="prettyprint"><code>tree.setCellEditor(new LeafTreeCellEditor(tree, (DefaultTreeCellRenderer)tree.getCellRenderer()));
</code></pre>

ルートノードなどの枝ノードは、トリプルクリックしても編集不可になっています。

### 参考リンク
- [Swing - How can I persist all changes I made to these edited leaves and nodes??](https://forums.oracle.com/thread/1371600)

<!-- dummy comment line for breaking list -->

### コメント
