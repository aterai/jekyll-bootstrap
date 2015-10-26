---
layout: post
category: swing
folder: ExpandsSelectedPaths
title: JTreeの選択されたノードを展開する
tags: [JTree, TreePath]
author: aterai
pubdate: 2012-09-24T13:08:25+09:00
description: JTreeの選択されたノードまでのパスをすべて展開して可視状態にします。
comments: true
---
## 概要
`JTree`の選択されたノードまでのパスをすべて展開して可視状態にします。

{% download https://lh6.googleusercontent.com/-sOsnOftT8xE/UF_b7dSxzQI/AAAAAAAABS0/i_xYkTfxbZg/s800/ExpandsSelectedPaths.png %}

## サンプルコード
<pre class="prettyprint"><code>tree.setExpandsSelectedPaths(true);
</code></pre>

## 解説
上記のサンプルでは、マウスによるノード選択ではなく、`JTree#addSelectionPath(TreePath)`などによるノード選択が行われた場合、そのノードまでのパスを展開するかどうかを、`JTree#setExpandsSelectedPaths(...)`メソッドを使って切り替えるテストを行っています。

- `JTree#setExpandsSelectedPaths(false);`
    - ノード選択を変更しても親パスが閉じている場合は展開しない
- `JTree#setExpandsSelectedPaths(true);`
    - デフォルト(`JDK 1.3`から)
    - 選択されたノードまでのパスをすべて展開して可視化(スクロールはしない)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [http://docs.oracle.com/javase/1.3/docs/guide/swing/JTreeChanges.html](http://docs.oracle.com/javase/1.3/docs/guide/swing/JTreeChanges.html)
- [http://docs.oracle.com/javase/jp/1.3/guide/swing/JTreeChanges.html](http://docs.oracle.com/javase/jp/1.3/guide/swing/JTreeChanges.html)
    - メモ: 日本語版には`docs`が付かない
- [JTreeのノードを検索する](http://ateraimemo.com/Swing/SearchBox.html)

<!-- dummy comment line for breaking list -->

## コメント
