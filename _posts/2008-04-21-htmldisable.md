---
layout: post
title: JLabelなどのHtmlレンダリングを無効化
category: swing
folder: HtmlDisable
tags: [JLabel, Html, JToolTip]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-04-21

## JLabelなどのHtmlレンダリングを無効化
`JLabel`などの`Html`レンダリングを無効化して、タグ文字列をそのまま表示します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTODbO-ktI/AAAAAAAAAbw/bTVYI0sgEY4/s800/HtmlDisable.png)

### サンプルコード
<pre class="prettyprint"><code>label1.putClientProperty("html.disable", Boolean.TRUE);
label1.setText("&lt;html&gt;&lt;font color=red&gt;Html Test&lt;/font&gt;&lt;/html&gt;");
label1.setToolTipText("&lt;html&gt;&amp;lt;html&amp;gt;&amp;lt;font color=red&amp;gt;Html Test&amp;lt;/font&amp;gt;&amp;lt;/html&amp;gt;&lt;/html&gt;");
</code></pre>

### 解説
上記のサンプルでは、`JLabel`などに`putClientProperty("html.disable", Boolean.TRUE)`を設定することで、タグをレンダリングせずにそのまま文字列として表示しています。

- - - -
`JLabel`に、`putClientProperty("html.disable", Boolean.TRUE)`としても、その `JLabel`の`JToolTip`には反映されないので、`<html>`タグの中で文字実体参照を使っています。

- - - -
`Html`レンダリングされた文字列を、`setEnabled(false)`で無効化(灰色にする)する場合は、[Htmlを使ったJLabelとJEditorPaneの無効化](http://terai.xrea.jp/Swing/DisabledHtmlLabel.html)を参考にしてください。

### コメント
