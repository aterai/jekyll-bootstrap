---
layout: post
title: JTreeのノードがフォーカス状態になった場合のBorderを変更する
category: swing
folder: DrawsTreeFocus
tags: [JTree, UIManager, Border, Focus, LookAndFeel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-06-16

## JTreeのノードがフォーカス状態になった場合のBorderを変更する
`JTree`のノードが選択されてフォーカス状態になった場合の`Border`による描画を`UIManager`で変更します。 

{% download %}

![screenshot](https://lh3.googleusercontent.com/-I62wWvQhdQI/U53BUsVLj9I/AAAAAAAACHk/SSHVLXv9m28/s800/DrawsTreeFocus.png)

### サンプルコード
<pre class="prettyprint"><code>UIManager.putBoolean("Tree.drawsFocusBorderAroundIcon", false);
UIManager.putBoolean("Tree.drawDashedFocusIndicator", false);
</code></pre>

### 解説
- `Tree.drawsFocusBorderAroundIcon`
    - `ture`の場合、JTreeのノードアイコンも囲むように`Border`が拡張される(背景色で塗りつぶされる範囲は変化しない)
    - `MotifLookAndFeel`の初期値は`true`
- `Tree.drawDashedFocusIndicator`
    - `ture`の場合、JTreeのフォーカスの描画に使用する`Border`が点線になる
    - `WindowsLookAndFeel`の初期値は`true`

<!-- dummy comment line for breaking list -->

### コメント
