---
layout: post
category: swing
folder: DisabledHtmlLabel
title: Htmlを使ったJLabelとJEditorPaneの無効化
tags: [Html, JLabel, JEditorPane, UIManager]
author: aterai
pubdate: 2007-12-24T23:18:44+09:00
description: Htmlを使ったJLabelと、JEditorPaneをsetEnabled(false)で無効にします。
comments: true
---
## 概要
`Html`を使った`JLabel`と、`JEditorPane`を`setEnabled(false)`で無効にします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTK9vV2SGI/AAAAAAAAAW0/PIlAG2B9yZA/s800/DisabledHtmlLabel.png %}

## サンプルコード
<pre class="prettyprint"><code>final JLabel label2 = new JLabel(HTML_TEXT) {
  @Override public void setEnabled(boolean b) {
    super.setEnabled(b);
    setForeground(b ? UIManager.getColor("Label.foreground")
                    : UIManager.getColor("Label.disabledForeground"));
  }
};
final JEditorPane editor1 = new JEditorPane("text/html", HTML_TEXT);
editor1.setOpaque(false);
editor1.setEditable(false);
</code></pre>

## 解説
- 上段左
    - 通常の`JLabel`です。無効化すると文字がへこみます。

<!-- dummy comment line for breaking list -->

- 上段中
    - `Html`タグを使った`JLabel`です。無効化しても文字色は変化しません。

<!-- dummy comment line for breaking list -->

- 上段右
    - `Html`タグを使った`JLabel`です。無効化するとき、`setForeground`で文字色を変更していまが、`<font color='red'>`とした文字の色までは変化しません。

<!-- dummy comment line for breaking list -->

- 下段左
    - `Html`タグを使った`JLabel`です。無効化するとき、`setForeground`で文字色を変更し、さらに文字色をグレースケール化しています。このサンプルでは、無効化している時にラベルのテキストやサイズを変更しても、表示は更新されません。

<!-- dummy comment line for breaking list -->

- 下段中
    - `Html`タグを使った`JEditorPane`です。無効化すると、すべての文字色が変化します。

<!-- dummy comment line for breaking list -->

- 下段右
    - `Html`タグを使った`JEditorPane`です。無効化すると、すべての文字色が変化します。以下のようにして、`JLabel`と同じフォントを使用するように設定しています。

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>editor2.putClientProperty(JEditorPane.HONOR_DISPLAY_PROPERTIES, Boolean.TRUE);
editor2.setFont(UIManager.getFont("Label.font"));
</code></pre>

- - - -
`Html`レンダリングを無効化して、タグを文字列として表示する場合は、[JLabelなどのHtmlレンダリングを無効化](http://ateraimemo.com/Swing/HtmlDisable.html)を参考にしてください。

- - - -
- [Bug ID: 4783068 Components with HTML text should gray out the text when disabled](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=4783068)
    - `JDK 1.7.0-ea-b55`以上で、修正されている(上記のサンプルでも、無効化ですべての文字列がグレーになる)ようです。

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Bug ID: 4740519 HTML JLabel not greyed out on setEnabled(false)](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=4740519)
- [Swing - JLabel with html tag can not be disabled or setForegroud?!](https://forums.oracle.com/thread/1377943)
- [Hyperlinkを、JLabel、JButton、JEditorPaneで表示](http://ateraimemo.com/Swing/HyperlinkLabel.html)

<!-- dummy comment line for breaking list -->

## コメント
