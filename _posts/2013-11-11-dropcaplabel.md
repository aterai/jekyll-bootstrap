---
layout: post
category: swing
folder: DropcapLabel
title: JLabelでイニシャル組を行う
tags: [JLabel, Shape, TextLayout, LineBreakMeasurer, Font]
author: aterai
pubdate: 2013-11-11T00:01:29+09:00
description: JLabelの先頭文字を拡大、残りの文字列をTextLayoutで回り込むよう配置し、ドロップキャップで描画します。
image: https://lh6.googleusercontent.com/-kf9qTpS1Olg/Un-Dk5bbC-I/AAAAAAAAB5s/fAVjwJVHBqA/s800/DropcapLabel.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2013/11/using-drop-caps-on-jlabel.html
    lang: en
comments: true
---
## 概要
`JLabel`の先頭文字を拡大、残りの文字列を`TextLayout`で回り込むよう配置し、ドロップキャップで描画します。

{% download https://lh6.googleusercontent.com/-kf9qTpS1Olg/Un-Dk5bbC-I/AAAAAAAAB5s/fAVjwJVHBqA/s800/DropcapLabel.png %}

## サンプルコード
<pre class="prettyprint"><code>@Override protected void paintComponent(Graphics g) {
  Graphics2D g2 = (Graphics2D) g.create();
  g2.setPaint(getBackground());
  g2.fillRect(0, 0, getWidth(), getHeight());

  Insets i = getInsets();
  float x0 = i.left;
  float y0 = i.top;

  Font font = getFont();
  String txt = getText();

  AttributedString as = new AttributedString(txt.substring(1));
  as.addAttribute(TextAttribute.FONT, font);
  AttributedCharacterIterator aci = as.getIterator();
  FontRenderContext frc = g2.getFontRenderContext();

  Shape shape = new TextLayout(txt.substring(0, 1), font, frc).getOutline(null);

  AffineTransform at1 = AffineTransform.getScaleInstance(5d, 5d);
  Shape s1 = at1.createTransformedShape(shape);
  Rectangle r = s1.getBounds();
  r.grow(6, 2);
  int rw = r.width;
  int rh = r.height;

  AffineTransform at2 = AffineTransform.getTranslateInstance(x0, y0 + rh);
  Shape s2 = at2.createTransformedShape(s1);
  g2.setPaint(getForeground());
  g2.fill(s2);

  float x = x0 + rw;
  float y = y0;
  int w0 = getWidth() - i.left - i.right;
  int w = w0 - rw;
  LineBreakMeasurer lbm = new LineBreakMeasurer(aci, frc);
  while (lbm.getPosition() &lt; aci.getEndIndex()) {
    TextLayout tl = lbm.nextLayout(w);
    tl.draw(g2, x, y + tl.getAscent());
    y += tl.getDescent() + tl.getLeading() + tl.getAscent();
    if (y0 + rh &lt; y) {
      x = x0;
      w = w0;
    }
  }
  g2.dispose();
}
</code></pre>

## 解説
上記のサンプルでは、`JLabel`に流し込む文字列でドロップキャップの装飾を行っています。

1. 先頭一文字の`Shape`を取得し、これを拡大して表示
1. 残りの文字から`AttributedString`を作成
1. 拡大した先頭文字の高さに行の`y`座標が収まる場合は、`JLabel`の幅から先頭文字幅を除いた幅に収まる文字列を`LineBreakMeasurer`で取得し描画
1. 拡大した先頭文字の高さを行の`y`座標が超えた場合は、`JLabel`の幅に収まる文字列を`LineBreakMeasurer`で取得し描画

## 参考リンク
- [JLabelの文字列を折り返し](https://ateraimemo.com/Swing/GlyphVector.html)
- [Fontを回転する](https://ateraimemo.com/Swing/TransformedShape.html)

<!-- dummy comment line for breaking list -->

## コメント
