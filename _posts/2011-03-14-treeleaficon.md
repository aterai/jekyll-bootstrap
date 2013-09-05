---
layout: post
title: JTreeのOpenIcon、ClosedIcon、LeafIconを変更
category: swing
folder: TreeLeafIcon
tags: [JTree, Icon, TreeCellRenderer]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-03-14

## JTreeのOpenIcon、ClosedIcon、LeafIconを変更
`JTree`の`OpenIcon`、`ClosedIcon`、`LeafIcon`の表示表示を切り替えます。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TX24gbN5bHI/AAAAAAAAA30/l8Pn8nUfJiA/s800/TreeLeafIcon.png)

### サンプルコード
<pre class="prettyprint"><code>folderCheck.addActionListener(new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    DefaultTreeCellRenderer r = (DefaultTreeCellRenderer)tree.getCellRenderer();
    if(((JCheckBox)e.getSource()).isSelected()) {
      r.setOpenIcon(r.getDefaultOpenIcon());
      r.setClosedIcon(r.getDefaultClosedIcon());
    }else{
      r.setOpenIcon(emptyIcon);
      r.setClosedIcon(emptyIcon);
    }
    allNodesChanged(tree);
  }
});
</code></pre>

### 解説
- `DefaultTreeCellRenderer#setOpenIcon(Icon)`
- `DefaultTreeCellRenderer#getDefaultOpenIcon()`
- `DefaultTreeCellRenderer#setClosedIcon(Icon)`
- `DefaultTreeCellRenderer#getDefaultClosedIcon()`
- `DefaultTreeCellRenderer#setLeafIcon(Icon)`
- `DefaultTreeCellRenderer#getDefaultLeafIcon()`

<!-- dummy comment line for breaking list -->

上記のメソッドを使用して、デフォルトアイコンと空アイコンを設定し、表示非表示を切り替えています。

- - - -
各アイコンの幅が変化するので、表示を切り替えた後で、以下のようにすべてのノードを更新しています。
<pre class="prettyprint"><code>private static void allNodesChanged(JTree tree) {
  DefaultTreeModel model = (DefaultTreeModel)tree.getModel();
  DefaultMutableTreeNode root = (DefaultMutableTreeNode)model.getRoot();
  java.util.Enumeration depth = root.depthFirstEnumeration();
  while(depth.hasMoreElements()) {
    model.nodeChanged((TreeNode)depth.nextElement());
  }
  //tree.revalidate();
  //tree.repaint();
}
</code></pre>

### 参考リンク
- [JTreeの展開、折畳みアイコンを非表示にする](http://terai.xrea.jp/Swing/TreeExpandedIcon.html)

<!-- dummy comment line for breaking list -->

### コメント