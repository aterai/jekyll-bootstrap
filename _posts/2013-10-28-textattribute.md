---
layout: post
category: swing
folder: TextAttribute
title: JTextFieldの文字列に下線を付ける
tags: [JTextField, JTextArea, Font, TextAttribute]
author: aterai
pubdate: 2013-10-28T00:39:37+09:00
description: JTextFieldにテキスト属性を設定したフォントを使用して、文字列に下線を引きます。
image: https://lh4.googleusercontent.com/-OkP81Y9wnSg/Um0wk_H3a5I/AAAAAAAAB5A/KfDBXqlXF3o/s800/TextAttribute.png
comments: true
---
## 概要
`JTextField`にテキスト属性を設定したフォントを使用して、文字列に下線を引きます。

{% download https://lh4.googleusercontent.com/-OkP81Y9wnSg/Um0wk_H3a5I/AAAAAAAAB5A/KfDBXqlXF3o/s800/TextAttribute.png %}

## サンプルコード
<pre class="prettyprint"><code>Font font = textField.getFont();
Map&lt;TextAttribute, Object&gt; attrs = new HashMap&lt;&gt;(font.getAttributes());
attrs.put(TextAttribute.UNDERLINE, TextAttribute.UNDERLINE_LOW_DOTTED);
textField.setFont(font.deriveFont(attrs));
// ...
enum UnderlineStyle {
  UNDERLINE_OFF(-1),
  UNDERLINE_LOW_DASHED(TextAttribute.UNDERLINE_LOW_DASHED),
  UNDERLINE_LOW_DOTTED(TextAttribute.UNDERLINE_LOW_DOTTED),
  UNDERLINE_LOW_GRAY(TextAttribute.UNDERLINE_LOW_GRAY),
  UNDERLINE_LOW_ONE_PIXEL(TextAttribute.UNDERLINE_LOW_ONE_PIXEL),
  UNDERLINE_LOW_TWO_PIXEL(TextAttribute.UNDERLINE_LOW_TWO_PIXEL),
  UNDERLINE_ON(TextAttribute.UNDERLINE_ON);
  public final int style;
  private UnderlineStyle(int style) {
    this.style = style;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`Font#deriveFont(...)`メソッドに下線の属性キーに点線や破線の属性値を設定した`TextAttribute`のマップを適用して、下線属性の付いた新しい`Font`オブジェクトを生成しています。

- 注: `JTextArea`の下にある`JTextField`のように、コンポーネントの高さが足りないと、下線の種類によっては表示されない場合がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TextAttribute (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/font/TextAttribute.html)
- [java - Is it possible to underline text on JTextField?If Yes, How? - Stack Overflow](https://stackoverflow.com/questions/19478966/is-it-possible-to-underline-text-on-jtextfieldif-yes-how)

<!-- dummy comment line for breaking list -->

## コメント
