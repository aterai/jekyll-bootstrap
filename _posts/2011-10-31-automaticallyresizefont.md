---
layout: post
title: Fontサイズをコンポーネントの幅に応じて変更する
category: swing
folder: AutomaticallyResizeFont
tags: [JTextPane, Font]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-10-31

## 概要
`JTextPane`のフォントサイズをその幅に応じて自動変更します。

{% download https://lh6.googleusercontent.com/-RTjWJaRHh4E/Tq4_8nk91OI/AAAAAAAABEY/mwfxMScDHec/s800/AutomaticallyResizeFont.png %}

## サンプルコード
<pre class="prettyprint"><code>private final Font font = new Font(Font.MONOSPACED, Font.PLAIN, 12);
private final JTextPane editor = new JTextPane() {
  float font_size = 0.0f;
  @Override public void doLayout() {
    Insets i = getInsets();
    float f = .08f * (getWidth() - i.left - i.right);
    if(Math.abs(font_size-f) &gt; 1.0e-1) {
      setFont(font.deriveFont(f));
      font_size = f;
    }
    super.doLayout();
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JTextPane#doLayout`メソッドをオーバーライドし、幅の変更に応じて使用するフォントサイズを変更(`Font#deriveFont(float)`)しています。

## 参考リンク
- [Harmonic Code: Friday Fun Component XI](http://harmoniccode.blogspot.com/2011/10/friday-fun-component-xi.html)

<!-- dummy comment line for breaking list -->

## コメント
