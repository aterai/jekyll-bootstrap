---
layout: post
category: swing
folder: EnabledAt
title: JTabbedPaneのタブを選択不可にする
tags: [JTabbedPane]
author: aterai
pubdate: 2004-07-26T06:10:38+09:00
description: JTabbedPaneのタブが選択できるかどうかを切り替えます。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTMLdSGopI/AAAAAAAAAYw/aRU27uh4vuQ/s800/EnabledAt.png
comments: true
---
## 概要
`JTabbedPane`のタブが選択できるかどうかを切り替えます。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTMLdSGopI/AAAAAAAAAYw/aRU27uh4vuQ/s800/EnabledAt.png %}

## サンプルコード
<pre class="prettyprint"><code>checkbox.addItemListener(e -&gt; {
  tabs.setEnabledAt(1, e.getStateChange() == ItemEvent.SELECTED);
});
</code></pre>

## 解説
上記のサンプルでは、`JTabbedPane#setEnabledAt(...)`メソッドを使用して「詳細設定」タブの選択可・不可を切り替えています。

## 参考リンク
- [JTabbedPane#setEnabledAt(int, boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTabbedPane.html#setEnabledAt-int-boolean-)

<!-- dummy comment line for breaking list -->

## コメント
