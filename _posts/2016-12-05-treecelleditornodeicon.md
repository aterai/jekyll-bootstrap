---
layout: post
category: swing
folder: TreeCellEditorNodeIcon
title: JTreeのノードを編集中に表示するアイコンを変更する
tags: [JTree, Icon, DefaultTreeCellEditor, DefaultTreeCellRenderer]
author: aterai
pubdate: 2016-12-05T02:23:19+09:00
description: JTreeのノードが編集開始されたときに表示するノードアイコンを変更します。
image: https://drive.google.com/uc?export=view&id=1bjb1mUD5NQcTmyA9lBFKu1Zu5gPs9po_sw
comments: true
---
## 概要
`JTree`のノードが編集開始されたときに表示するノードアイコンを変更します。

{% download https://drive.google.com/uc?export=view&id=1bjb1mUD5NQcTmyA9lBFKu1Zu5gPs9po_sw %}

## サンプルコード
<pre class="prettyprint"><code>JTree tree2 = new JTree();
tree2.setEditable(true);
DefaultTreeCellRenderer renderer2 = new DefaultTreeCellRenderer();
renderer2.setOpenIcon(icon);
renderer2.setClosedIcon(icon);
renderer2.setLeafIcon(icon);
tree2.setCellRenderer(renderer2);

JTree tree3 = new JTree();
tree3.setEditable(true);
DefaultTreeCellRenderer renderer3 = new DefaultTreeCellRenderer();
renderer3.setOpenIcon(new ColorIcon(Color.GREEN));
renderer3.setClosedIcon(new ColorIcon(Color.BLUE));
renderer3.setLeafIcon(new ColorIcon(Color.ORANGE));
tree3.setCellRenderer(renderer2);
tree3.setCellEditor(new DefaultTreeCellEditor(tree3, renderer3));
</code></pre>

## 解説
- 左
    - `DefaultTreeCellRenderer#getTreeCellRendererComponent(...)`をオーバーライドし、内部で`setIcon(icon)`メソッドを使用してノードアイコンを変更
    - ノード編集中はデフォルトのアイコンが表示される
- 中
    - `DefaultTreeCellRenderer#setOpenIcon(...)`、`DefaultTreeCellRenderer#setClosedIcon(...)`、`DefaultTreeCellRenderer#setLeafIcon(...)`メソッドを使用してアイコンを変更した`TreeCellRenderer`を`JTree#setCellRenderer(...)`メソッドで設定
    - ノード編集中は`DefaultTreeCellEditor`が上記の`TreeCellRenderer`からアイコンを取得するため、編集中も同じアイコンが表示される
- 右
    - `DefaultTreeCellRenderer#setOpenIcon(...)`、`DefaultTreeCellRenderer#setClosedIcon(...)`、`DefaultTreeCellRenderer#setLeafIcon(...)`メソッドを使用してアイコンを変更した`TreeCellRenderer`を`JTree#setCellRenderer(...)`メソッドで設定
    - `DefaultTreeCellEditor`で使用する`TreeCellRenderer`を表示用とは異なるアイコンを設定し、`JTree#setCellEditor(...)`メソッドで設定ているため、編集中は異なるアイコンが表示される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [DefaultTreeCellEditor (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/tree/DefaultTreeCellEditor.html#DefaultTreeCellEditor-javax.swing.JTree-javax.swing.tree.DefaultTreeCellRenderer-)

<!-- dummy comment line for breaking list -->

## コメント
