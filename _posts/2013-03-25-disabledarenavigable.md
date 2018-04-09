---
layout: post
category: swing
folder: DisabledAreNavigable
title: DisabledなJMenuItemのハイライトをテスト
tags: [JMenuItem, UIManager, LookAndFeel]
author: aterai
pubdate: 2013-03-25T00:06:25+09:00
description: DisabledなJMenuItemがハイライト可能かどうかをLookAndFeelごとにテストします。
image: https://lh4.googleusercontent.com/--XCIC-Dhgwk/UU8M_ixmZeI/AAAAAAAABoU/aXonTNvOs0A/s800/DisabledAreNavigable.png
comments: true
---
## 概要
`Disabled`な`JMenuItem`がハイライト可能かどうかを`LookAndFeel`ごとにテストします。

{% download https://lh4.googleusercontent.com/--XCIC-Dhgwk/UU8M_ixmZeI/AAAAAAAABoU/aXonTNvOs0A/s800/DisabledAreNavigable.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("MenuItem.disabledAreNavigable", Boolean.TRUE);
</code></pre>

## 解説
- `WindowsLookAndFeel`の場合、`UIManager.getBoolean("MenuItem.disabledAreNavigable")`のデフォルトは`true`で、`Disabled`な`JMenuItem`でもハイライトが可能
- `MetalLookAndFeel`の場合、`UIManager.getBoolean("MenuItem.disabledAreNavigable")`のデフォルトは`false`だが、`UIManager.put("MenuItem.disabledAreNavigable", Boolean.TRUE)`とすれば、`Disabled`な`JMenuItem`でもハイライトが可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JDK-4515765 Win L&F: Disabled menu items should show highlight - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-4515765)
- [JDK-6325555 Only Partial Fix in for 4515765 in B53 Swing PIT - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6325555)

<!-- dummy comment line for breaking list -->

## コメント
