---
layout: post
category: swing
folder: HtmlDisable
title: JLabelなどのHtmlレンダリングを無効化
tags: [JLabel, Html, JToolTip]
author: aterai
pubdate: 2008-04-21T13:43:08+09:00
description: JLabelなどのHtmlレンダリングを無効化して、タグ文字列をそのまま表示します。
comments: true
---
## 概要
`JLabel`などの`Html`レンダリングを無効化して、タグ文字列をそのまま表示します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTODbO-ktI/AAAAAAAAAbw/bTVYI0sgEY4/s800/HtmlDisable.png %}

## サンプルコード
<pre class="prettyprint"><code>label1.putClientProperty("html.disable", Boolean.TRUE);
label1.setText("&lt;html&gt;&lt;font color=red&gt;Html Test&lt;/font&gt;&lt;/html&gt;");
label1.setToolTipText("&lt;html&gt;&amp;lt;html&amp;gt;&amp;lt;font color=red&amp;gt;Html Test&amp;lt;/font&amp;gt;&amp;lt;/html&amp;gt;&lt;/html&gt;");
</code></pre>

## 解説
上記のサンプルでは、`JLabel`などに`putClientProperty("html.disable", Boolean.TRUE)`を設定することで、タグをレンダリングせずにそのまま文字列として表示しています。

- - - -
`JLabel`に、`putClientProperty("html.disable", Boolean.TRUE)`としても、その `JLabel`の`JToolTip`には反映されないので、`<html>`タグの中で文字実体参照を使っています。

## 参考リンク
- [Htmlを使ったJLabelとJEditorPaneの無効化](http://ateraimemo.com/Swing/DisabledHtmlLabel.html)

<!-- dummy comment line for breaking list -->

## コメント
