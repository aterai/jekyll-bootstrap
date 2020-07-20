---
layout: post
category: swing
folder: TreeSelection
title: JTreeの選択モードを切り替える
tags: [JTree, TreeSelectionModel, TreePath]
author: aterai
pubdate: 2011-08-01T15:39:38+09:00
description: JTreeからSelectionModelを取得し、ノードの選択モードを切り替えます。
image: https://lh6.googleusercontent.com/-bPltus2wD6w/TjZCCGnH40I/AAAAAAAABAE/tgmolSg-2Ys/s800/TreeSelection.png
comments: true
---
## 概要
`JTree`から`SelectionModel`を取得し、ノードの選択モードを切り替えます。

{% download https://lh6.googleusercontent.com/-bPltus2wD6w/TjZCCGnH40I/AAAAAAAABAE/tgmolSg-2Ys/s800/TreeSelection.png %}

## サンプルコード
<pre class="prettyprint"><code>JRadioButton r0 = new JRadioButton("DISCONTIGUOUS_TREE_SELECTION", true);
r0.addItemListener(e -&gt; {
  if (e.getStateChange() == ItemEvent.SELECTED) {
    tree.getSelectionModel().setSelectionMode(
      TreeSelectionModel.DISCONTIGUOUS_TREE_SELECTION);
  }
});

JRadioButton r1 = new JRadioButton("SINGLE_TREE_SELECTION");
r1.addItemListener(e -&gt; {
  if (e.getStateChange() == ItemEvent.SELECTED) {
    tree.getSelectionModel().setSelectionMode(
      TreeSelectionModel.SINGLE_TREE_SELECTION);
  }
});

JRadioButton r2 = new JRadioButton("CONTIGUOUS_TREE_SELECTION");
r2.addItemListener(e -&gt; {
  if (e.getStateChange() == ItemEvent.SELECTED) {
    tree.getSelectionModel().setSelectionMode(
      TreeSelectionModel.CONTIGUOUS_TREE_SELECTION);
  }
});
</code></pre>

## 解説
上記のサンプルでは、`tree.getSelectionModel().setSelectionMode(...)`メソッドを使用して、選択モードを設定しています。

- `TreeSelectionModel.DISCONTIGUOUS_TREE_SELECTION`
    - <kbd>Ctrl+Click</kbd>、<kbd>Shift+Click</kbd>などで、自由に`TreePath`を選択可能
- `TreeSelectionModel.SINGLE_TREE_SELECTION`
    - `TreePath`をひとつだけ選択可能
- `TreeSelectionModel.CONTIGUOUS_TREE_SELECTION`
    - `TreePath`が連続している場合は、複数選択が可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TreeSelectionModel#setSelectionMode(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/tree/TreeSelectionModel.html#setSelectionMode-int-)

<!-- dummy comment line for breaking list -->

## コメント
