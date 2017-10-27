---
layout: post
category: swing
folder: AutoChapterNumberingTreeNode
title: JTreeの各ノードタイトルに章番号を自動追加して表示する
tags: [JTree, TreeNode, TreeCellRenderer]
author: aterai
pubdate: 2017-03-06T15:12:27+09:00
description: JTreeの各ノードに章番号を自動的に追加し、タイトル先頭にそれを表示するTreeCellRendererを作成します。
image: https://drive.google.com/uc?export=view&id=1sr9avobwqRpWX2bNvLVutxduLQa66KvKTg
comments: true
---
## 概要
`JTree`の各ノードに章番号を自動的に追加し、タイトル先頭にそれを表示する`TreeCellRenderer`を作成します。

{% download https://drive.google.com/uc?export=view&id=1sr9avobwqRpWX2bNvLVutxduLQa66KvKTg %}

## サンプルコード
<pre class="prettyprint"><code>class ChapterNumberingTreeCellRenderer extends DefaultTreeCellRenderer {
  private static final String MARK = "\u00a7"; //"§";
  @Override public Component getTreeCellRendererComponent(
      JTree tree, Object value, boolean selected, boolean expanded,
      boolean leaf, int row, boolean hasFocus) {
    JLabel l = (JLabel) super.getTreeCellRendererComponent(
        tree, value, selected, expanded, leaf, row, hasFocus);
    if (value instanceof DefaultMutableTreeNode) {
      TreeNode[] tn = ((DefaultMutableTreeNode) value).getPath();
      String s = IntStream.range(1, tn.length).mapToObj(i -&gt; {
        TreeNode n = tn[i];
        TreeNode p = n.getParent();
        return String.valueOf(1 + p.getIndex(n));
      }).collect(Collectors.joining("."));
      l.setText(String.format("%s%s %s", MARK, s, value));
    }
    return l;
  }
}
</code></pre>

## 解説
上記のサンプルでは、ルートノードを除く各ノードに章番号を付加する`TreeCellRenderer`を作成して、`JTree`に設定しています。

- `JTree#setRootVisible(false)`でルートノードを非表示に設定
- `DefaultTreeCellRenderer#getTreeCellRendererComponent(...)`をオーバーライド
    - `DefaultMutableTreeNode#getPath()`で、ルートノードから自ノードまでのノード配列を取得
    - ルートノードを除く各ノードで、自ノードが何番目のノードかを`TreeNode#getIndex()`で取得し、文字列に変換
    - 変換した各番号文字列を`.`で結合し、ノードタイトルの先頭に追加

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTreeで目次を作成する](https://ateraimemo.com/Swing/TableOfContentsTree.html)

<!-- dummy comment line for breaking list -->

## コメント
