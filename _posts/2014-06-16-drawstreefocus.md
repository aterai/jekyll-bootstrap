---
layout: post
category: swing
folder: DrawsTreeFocus
title: JTreeのノードがフォーカス状態になった場合のBorderを変更する
tags: [JTree, UIManager, Border, Focus, LookAndFeel]
author: aterai
pubdate: 2014-06-16T01:26:31+09:00
description: JTreeのノードが選択されてフォーカス状態になった場合のBorderによる描画をUIManagerで変更します。
image: https://lh3.googleusercontent.com/-I62wWvQhdQI/U53BUsVLj9I/AAAAAAAACHk/SSHVLXv9m28/s800/DrawsTreeFocus.png
comments: true
---
## 概要
`JTree`のノードが選択されてフォーカス状態になった場合の`Border`による描画を`UIManager`で変更します。

{% download https://lh3.googleusercontent.com/-I62wWvQhdQI/U53BUsVLj9I/AAAAAAAACHk/SSHVLXv9m28/s800/DrawsTreeFocus.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.putBoolean("Tree.drawsFocusBorderAroundIcon", false);
UIManager.putBoolean("Tree.drawDashedFocusIndicator", false);
</code></pre>

## 解説
- `Tree.drawsFocusBorderAroundIcon`
    - `true`の場合`JTree`のノードアイコンを囲むように`Border`が拡張される
        - 背景色で塗りつぶされる範囲は変化しない
    - `MotifLookAndFeel`の初期値は`true`
- `Tree.drawDashedFocusIndicator`
    - `true`の場合`JTree`のフォーカスの描画に使用する`Border`が点線になる
    - `WindowsLookAndFeel`の初期値は`true`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [How to Use Trees (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](https://docs.oracle.com/javase/tutorial/uiswing/components/tree.html)

<!-- dummy comment line for breaking list -->

## コメント
