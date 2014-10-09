---
layout: post
category: swing
folder: TextShiftOffset
title: JButtonのテキストシフト量を変更
tags: [JButton, UIManager]
author: aterai
pubdate: 2007-12-31T16:51:19+09:00
description: JButtonをクリックしたときのテキストシフト量を変更します。
comments: true
---
## 概要
`JButton`をクリックしたときのテキストシフト量を変更します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTVR92SsdI/AAAAAAAAAnY/_wKFJTNu2oY/s800/TextShiftOffset.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("Button.textShiftOffset", 0);
SwingUtilities.updateComponentTreeUI(this);
</code></pre>

## 解説
上記のサンプルでは、テキストシフト量を、`0`、`1`、`-1`と切り替えることができます。

- メモ
    - `Java 1.5.0` + `WindowsLookAndFeel`のデフォルトは`1`
    - `Java 1.6.0` + `WindowsLookAndFeel`のデフォルトは`0`

<!-- dummy comment line for breaking list -->

## コメント
