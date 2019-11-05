---
layout: post
category: swing
folder: TreeClearSelection
title: JTreeの選択状態を解除する
tags: [JTree, MouseListener]
author: aterai
pubdate: 2010-12-06T14:44:47+09:00
description: JTreeでノード以外の領域をマウスでクリックした場合、選択状態を解除します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTWDzni-uI/AAAAAAAAAoo/r6UW4JENwgI/s800/TreeClearSelection.png
comments: true
---
## 概要
`JTree`でノード以外の領域をマウスでクリックした場合、選択状態を解除します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTWDzni-uI/AAAAAAAAAoo/r6UW4JENwgI/s800/TreeClearSelection.png %}

## サンプルコード
<pre class="prettyprint"><code>tree.addMouseListener(new MouseAdapter() {
  @Override public void mousePressed(MouseEvent e) {
    JTree tree = (JTree) e.getComponent();
    if (tree.getRowForLocation(e.getX(), e.getY()) &lt; 0) {
      tree.clearSelection();
    }
    // or:
    // if (tree.getPathForLocation(e.getX(), e.getY()) == null) {
    //   tree.clearSelection();
    // }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JTree#getRowForLocation(...)`メソッドを使用して`JTree`のノード以外の場所がクリックされたかどうかを判断しています。ノードの選択解除自体は`JTree#clearSelection()`メソッドを使用しています。

- [JTree#getRowForLocation(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTree.html#getRowForLocation-int-int-)
    - 指定された位置に対応する行を返す
    - 指定された位置が表示セルの境界外にある場合は`-1`
- [JTree#getPathForLocation(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTree.html#getPathForLocation-int-int-)
    - 指定された位置にあるノードの`TreePath`を返す
    - 指定された位置が表示セルの境界外にある場合は`null`を返す

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTree (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTree.html)のサンプルコード

<!-- dummy comment line for breaking list -->

## コメント
