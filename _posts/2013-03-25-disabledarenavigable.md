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
- [Windows L&F Bugs: Part 2 | Java.net](http://weblogs.java.net/blog/joshy/archive/2006/08/windows_lf_bugs.html)
    - [4515765 Win L&F: Disabled menu items should show highlight](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=4515765)

<!-- dummy comment line for breaking list -->

## コメント
