---
layout: post
category: swing
folder: TreeNodeCollapseVeto
title: JTreeのノードを折り畳み不可に設定する
tags: [JTree]
author: aterai
pubdate: 2014-11-03T00:09:16+09:00
description: JTreeのノードをマウスでクリックしても折り畳まれないように設定します。
image: https://lh3.googleusercontent.com/-lmIva1c-vxw/VFZHTSmTigI/AAAAAAAANo0/jeRoJW178as/s800/TreeNodeCollapseVeto.png
comments: true
---
## 概要
`JTree`のノードをマウスでクリックしても折り畳まれないように設定します。

{% download https://lh3.googleusercontent.com/-lmIva1c-vxw/VFZHTSmTigI/AAAAAAAANo0/jeRoJW178as/s800/TreeNodeCollapseVeto.png %}

## サンプルコード
<pre class="prettyprint"><code>tree.addTreeWillExpandListener(new TreeWillExpandListener() {
  @Override public void treeWillExpand(TreeExpansionEvent e) throws ExpandVetoException {
    //throw new ExpandVetoException(e, "Tree expansion cancelled");
  }
  @Override public void treeWillCollapse(TreeExpansionEvent e) throws ExpandVetoException {
    throw new ExpandVetoException(e, "Tree collapse cancelled");
  }
});
</code></pre>

## 解説
- 左: デフォルト
- 右: ノードの折り畳み不可
    - `TreeWillExpandListener#treeWillCollapse()`で、`ExpandVetoException`を発生させることで、マウスやキー入力によるノードの折り畳みを不可に設定
    - ノードの展開、編集、選択などは可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TreeWillExpandListener (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/event/TreeWillExpandListener.html)
- [JTreeで展開不可のノードを設定する](http://ateraimemo.com/Swing/PreventNodeExpanding.html)

<!-- dummy comment line for breaking list -->

## コメント
