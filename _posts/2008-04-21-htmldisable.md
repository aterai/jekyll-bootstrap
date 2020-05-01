---
layout: post
category: swing
folder: HtmlDisable
title: JLabelなどのHtmlレンダリングを無効化
tags: [JLabel, Html, JToolTip]
author: aterai
pubdate: 2008-04-21T13:43:08+09:00
description: JLabelなどのHtmlレンダリングを無効化して、タグ文字列をそのまま表示します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTODbO-ktI/AAAAAAAAAbw/bTVYI0sgEY4/s800/HtmlDisable.png
comments: true
---
## 概要
`JLabel`などの`Html`レンダリングを無効化して、タグ文字列をそのまま表示します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTODbO-ktI/AAAAAAAAAbw/bTVYI0sgEY4/s800/HtmlDisable.png %}

## サンプルコード
<pre class="prettyprint"><code>label.putClientProperty("html.disable", Boolean.TRUE);
label.setText("&lt;html&gt;&lt;font color=red&gt;Html Test&lt;/font&gt;&lt;/html&gt;");
label.setToolTipText("&lt;html&gt;&amp;lt;html&amp;gt;&amp;lt;font color=red&amp;gt;Html Test&amp;lt;/font&amp;gt;&amp;lt;/html&amp;gt;&lt;/html&gt;");
</code></pre>

## 解説
上記のサンプルでは、`JLabel`などに`putClientProperty("html.disable", Boolean.TRUE)`を設定することで、`<html>`タグとしてレンダリングせずにそのまま文字列として表示しています。

- - - -
- `JLabel`に`putClientProperty("html.disable", Boolean.TRUE)`を設定しても、その`JLabel`の`JToolTip`には反映されない
    - `<html>`タグの中で文字実体参照を使用して回避

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Htmlを使ったJLabelとJEditorPaneの無効化](https://ateraimemo.com/Swing/DisabledHtmlLabel.html)

<!-- dummy comment line for breaking list -->

## コメント
