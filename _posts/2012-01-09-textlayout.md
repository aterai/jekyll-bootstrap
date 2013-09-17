---
layout: post
title: TextLayoutでFontのメトリック情報を取得する
category: swing
folder: TextLayout
tags: [Font, TextLayout, GlyphVector, LineMetrics, Graphics]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-01-09

## TextLayoutでFontのメトリック情報を取得する
`TextLayout`から`Font`の`Ascent`、`Descent`、`Leading`などのメトリック情報を取得して描画します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/--iErOVV0RYk/TwpnJGdl4OI/AAAAAAAABHs/pHLpQWbpTWg/s800/TextLayout.png)

### サンプルコード
<pre class="prettyprint"><code>String text = "abcdefthijklmnopqrstuvwxyz";
Font font = new Font(Font.SERIF, Font.ITALIC, 64);
FontRenderContext frc = new FontRenderContext(null,true,true);
TextLayout tl = new TextLayout(text, font, frc);
@Override public void paintComponent(Graphics g) {
  Graphics2D g2 = (Graphics2D)g;
  int w = getWidth();
  float baseline = getHeight()/2f;

  g2.setPaint(Color.RED);
  g2.draw(new Line2D.Float(0, baseline, w, baseline));

  g2.setPaint(Color.GREEN);
  float ascent = baseline - tl.getAscent();
  g2.draw(new Line2D.Float(0, ascent, w, ascent));

  g2.setPaint(Color.BLUE);
  float descent = baseline + tl.getDescent();
  g2.draw(new Line2D.Float(0, descent, w, descent));

  g2.setPaint(Color.ORANGE);
  float leading = baseline + tl.getDescent() + tl.getLeading();
  g2.draw(new Line2D.Float(0, leading, w, leading));

  g2.setPaint(Color.CYAN);
  float xheight = baseline - (float)tl.getBlackBoxBounds(23, 24).getBounds().getHeight();
  g2.draw(new Line2D.Float(0, xheight, w, xheight));

  g2.setPaint(Color.BLACK);
  tl.draw(g2, 0f, baseline);
}
</code></pre>

### 解説
上記のサンプルでは、上の文字列は`TextLayout`を使用して、下は`GlyphVector` + `LineMetrics`で`Font`のメトリック情報を取得して描画しています。

- `Color.RED`
    - ベースライン
- `Color.GREEN`: `Ascent`
    - ベースライン - `Ascent`
- `Color.BLUE`: `Descent`
    - ベースライン + `Descent`
- `Color.ORANGE`: `Leading`
    - ベースライン + `Descent` + `Leading`
- `Color.CYAN`: `x-height`
    - ベースライン - 文字"x"の高さ;

<!-- dummy comment line for breaking list -->

### コメント
