---
layout: post
title: JTreeの選択モードを切り替える
category: swing
folder: TreeSelection
tags: [JTree, TreePath]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-08-01

## JTreeの選択モードを切り替える
`JTree`の選択モードを切り替えます。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/-bPltus2wD6w/TjZCCGnH40I/AAAAAAAABAE/tgmolSg-2Ys/s800/TreeSelection.png)

### サンプルコード
<pre class="prettyprint"><code>tree.getSelectionModel().setSelectionMode(TreeSelectionModel.CONTIGUOUS_TREE_SELECTION);
</code></pre>

### 解説
上記のサンプルでは、`tree.getSelectionModel().setSelectionMode(...)`メソッドを使用して、選択モードを設定しています。

- `TreeSelectionModel.DISCONTIGUOUS_TREE_SELECTION`
    - Ctrl-クリック、Shift-クリックなどで、自由に`TreePath`を選択状態にすることができます。
- `TreeSelectionModel.SINGLE_TREE_SELECTION`
    - `TreePath`をひとつだけ選択状態にすることができます。
- `TreeSelectionModel.CONTIGUOUS_TREE_SELECTION`
    - `TreePath`が連続している場合は、複数選択できます。

<!-- dummy comment line for breaking list -->

### コメント
