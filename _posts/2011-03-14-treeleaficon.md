---
layout: post
category: swing
folder: TreeLeafIcon
title: JTreeのOpenIcon、ClosedIcon、LeafIconを変更
tags: [JTree, Icon, TreeCellRenderer]
author: aterai
pubdate: 2011-03-14T15:52:42+09:00
description: JTreeのOpenIcon、ClosedIcon、LeafIconの表示を切り替えます。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TX24gbN5bHI/AAAAAAAAA30/l8Pn8nUfJiA/s800/TreeLeafIcon.png
comments: true
---
## 概要
`JTree`の`OpenIcon`、`ClosedIcon`、`LeafIcon`の表示を切り替えます。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TX24gbN5bHI/AAAAAAAAA30/l8Pn8nUfJiA/s800/TreeLeafIcon.png %}

## サンプルコード
<pre class="prettyprint"><code>folderCheck.addActionListener(new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    DefaultTreeCellRenderer r = (DefaultTreeCellRenderer) tree.getCellRenderer();
    if (((JCheckBox) e.getSource()).isSelected()) {
      r.setOpenIcon(r.getDefaultOpenIcon());
      r.setClosedIcon(r.getDefaultClosedIcon());
    } else {
      r.setOpenIcon(emptyIcon);
      r.setClosedIcon(emptyIcon);
    }
    allNodesChanged(tree);
  }
});
</code></pre>

## 解説
- [DefaultTreeCellRenderer#setOpenIcon(Icon)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/tree/DefaultTreeCellRenderer.html#setOpenIcon-javax.swing.Icon-)
- [DefaultTreeCellRenderer#getDefaultOpenIcon()](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/tree/DefaultTreeCellRenderer.html#getDefaultOpenIcon--)
- [DefaultTreeCellRenderer#setClosedIcon(Icon)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/tree/DefaultTreeCellRenderer.html#setClosedIcon-javax.swing.Icon-)
- [DefaultTreeCellRenderer#getDefaultClosedIcon()](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/tree/DefaultTreeCellRenderer.html#getDefaultClosedIcon--)
- [DefaultTreeCellRenderer#setLeafIcon(Icon)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/tree/DefaultTreeCellRenderer.html#setLeafIcon-javax.swing.Icon-)
- [DefaultTreeCellRenderer#getDefaultLeafIcon()](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/tree/DefaultTreeCellRenderer.html#getDefaultLeafIcon--)

<!-- dummy comment line for breaking list -->

上記のメソッドを使用して、デフォルトアイコンと空アイコンを設定し、表示非表示を切り替えています。

- - - -
各アイコンの幅が変化するので、表示を切り替えた後で、以下のようにすべてのノードを更新しています。
<pre class="prettyprint"><code>private static void allNodesChanged(JTree tree) {
  DefaultTreeModel model = (DefaultTreeModel) tree.getModel();
  DefaultMutableTreeNode root = (DefaultMutableTreeNode) model.getRoot();
  Enumeration depth = root.depthFirstEnumeration();
  while (depth.hasMoreElements()) {
    model.nodeChanged((TreeNode) depth.nextElement());
  }
  //tree.revalidate();
  //tree.repaint();
}
</code></pre>

## 参考リンク
- [JTreeの展開、折畳みアイコンを非表示にする](https://ateraimemo.com/Swing/TreeExpandedIcon.html)

<!-- dummy comment line for breaking list -->

## コメント
