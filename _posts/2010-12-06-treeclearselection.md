---
layout: post
title: JTreeの選択状態を解除する
category: swing
folder: TreeClearSelection
tags: [JTree, MouseListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-12-06

## JTreeの選択状態を解除する
`JTree`でノード以外の領域をマウスでクリックした場合、選択状態を解除します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTWDzni-uI/AAAAAAAAAoo/r6UW4JENwgI/s800/TreeClearSelection.png)

### サンプルコード
<pre class="prettyprint"><code>tree.addMouseListener(new MouseAdapter() {
  @Overridepublic void mousePressed(MouseEvent e) {
    JTree tree = (JTree)e.getSource();
    if(tree.getRowForLocation(e.getX(), e.getY())&lt;0) {
      tree.clearSelection();
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、`JTree#getRowForLocation(...)`メソッドを使用して、`JTree`のノード以外のポイントがクリックされたかどうかを判断しています。ノードの選択解除自体は、`JTree#clearSelection()`が使用できます。

### 参考リンク
- [JTree (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/JTree.html)のサンプルコード

<!-- dummy comment line for breaking list -->

### コメント
