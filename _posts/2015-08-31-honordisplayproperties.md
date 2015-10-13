---
layout: post
category: swing
folder: HonorDisplayProperties
title: JEditorPaneに設定したフォントをHTMLテキストに適用する
tags: [JEditorPane, HTMLEditorKit, Font, StyleSheet, HTML]
author: aterai
pubdate: 2015-08-31T03:59:20+09:00
description: HTMLEditorKitでbodyタグにデフォルトで指定されている文字サイズではなく、JEditorPaneに設定したフォントをHTMLテキストで使用します。
comments: true
---
## 概要
`HTMLEditorKit`で`body`タグにデフォルトで指定されている文字サイズではなく、`JEditorPane`に設定したフォントを`HTML`テキストで使用します。

{% download https://lh3.googleusercontent.com/-eKfbGIGltkw/VeNSQCA5DkI/AAAAAAAAOAg/PyS8lMWBPu0/s800-Ic42/HonorDisplayProperties.png %}

## サンプルコード
<pre class="prettyprint"><code>editor.putClientProperty(JEditorPane.HONOR_DISPLAY_PROPERTIES, Boolean.TRUE);
</code></pre>

## 解説
`HTMLEditorKit`のデフォルトスタイルシートでは、`body`タグに`font-size: 14pt`などが設定されており、これがHTMLテキストのデフォルト文字サイズになっているため、`JEditorPane#setFont(new Font("Serif", Font.PLAIN, 16))`でフォントを指定しても反映されません。`JEditorPane`に設定されたフォントを使用する場合は、`JEditorPane#putClientProperty(JEditorPane.HONOR_DISPLAY_PROPERTIES, Boolean.TRUE)`としてコンポーネントのデフォルトのフォントを使用するように設定する必要があります。

- `body`タグのスタイルを表示するサンプルコード
    - [StyleSheet (Java Platform SE 8)](http://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/html/StyleSheet.html)のサンプル(`ShowStyles`)を参考

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>StringBuilder buf = new StringBuilder(300);
HTMLEditorKit htmlEditorKit = (HTMLEditorKit) editor.getEditorKit();
StyleSheet styles = htmlEditorKit.getStyleSheet();
//System.out.println(styles);
Enumeration rules = styles.getStyleNames();
while (rules.hasMoreElements()) {
  String name = (String) rules.nextElement();
  if ("body".equals(name)) {
    Style rule = styles.getStyle(name);
    Enumeration sets = rule.getAttributeNames();
    while (sets.hasMoreElements()) {
      Object n = sets.nextElement();
      buf.append(String.format("%s: %s&lt;br /&gt;", n, rule.getAttribute(n)));
    }
  }
}
editor.setText(buf.toString());
</code></pre>

- - - -
- メモ:
    - `JDK 1.8.0_60`ではスクリーンショットのように自動的に折り返されるが、`JDK 1.9.0-ea-b78`では、水平スクロールバーが表示される？

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JEditorPane.HONOR_DISPLAY_PROPERTIES (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JEditorPane.html#HONOR_DISPLAY_PROPERTIES)

<!-- dummy comment line for breaking list -->

## コメント