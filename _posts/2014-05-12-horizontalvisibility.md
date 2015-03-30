---
layout: post
title: JTextFieldの表示領域をJScrollBarでスクロールする
category: swing
folder: HorizontalVisibility
tags: [JTextField, JScrollBar, BoundedRangeModel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-05-12

## JTextFieldの表示領域をJScrollBarでスクロールする
`JTextField`の表示領域を`JScrollBar`でスクロール可能にします。

{% download %}

![screenshot](https://lh3.googleusercontent.com/-cOeCI-IblNs/U2-HtWna-xI/AAAAAAAACFI/z53K4Pkgpfo/s800/HorizontalVisibility.png)

### サンプルコード
<pre class="prettyprint"><code>scroller.setModel(textField.getHorizontalVisibility());
</code></pre>

### 解説
上記のサンプルでは、`JTextField#getHorizontalVisibility()`で取得した`BoundedRangeModel`(可視領域のモデル)を`JScrollBar`に設定することで、これを使用したスクロールや現在の可視領域の位置、幅の表示などが可能になっています。

- 注: `setCaretPosition: 0`
    - `JTextField#setCaretPosition(0);`は`JTextField`にフォーカスが無い場合無効？
    - `JScrollBar`が同期しない場合がある
- 注: `setScrollOffset: 0`
    - `JScrollBar`のノブがマウスドラッグに反応しなくなる場合がある？

<!-- dummy comment line for breaking list -->

### コメント
