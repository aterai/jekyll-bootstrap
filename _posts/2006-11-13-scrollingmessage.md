---
layout: post
category: swing
folder: ScrollingMessage
title: GlyphVectorで文字列を電光掲示板風にスクロール
tags: [GlyphVector, LineMetrics, TextLayout, Animation, JComponent]
author: aterai
pubdate: 2006-11-13T04:01:26+09:00
description: GlyphVectorを生成して、これを電光掲示板のようにスクロールさせます。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTSlbxO22I/AAAAAAAAAjA/SJLXTaAYArY/s800/ScrollingMessage.png
comments: true
---
## 概要
`GlyphVector`を生成して、これを電光掲示板のようにスクロールさせます。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTSlbxO22I/AAAAAAAAAjA/SJLXTaAYArY/s800/ScrollingMessage.png %}

## サンプルコード
<pre class="prettyprint"><code>class MarqueePanel extends JComponent implements ActionListener {
  public final javax.swing.Timer animator;
  private final GlyphVector gv;
  private float xx, yy;
  public MarqueePanel() {
    super();
    animator = new javax.swing.Timer(10, this);
    String text = "asffdfaaAAASFDsfasdfsdfasdfasd";
    Font font = new Font(Font.SERIF, Font.PLAIN, 100);
    FontRenderContext frc = new FontRenderContext(null, true, true);
    gv = font.createGlyphVector(frc, text);
    LineMetrics lm = font.getLineMetrics(text, frc);
    yy = lm.getAscent() / 2f + (float) gv.getVisualBounds().getY();
  }
  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D) g;
    int cw = getWidth();
    int ch = getHeight();
    g2.setPaint(Color.WHITE);
    g2.draw(new Line2D.Float(0, ch / 2f, cw, ch / 2f));
    g2.setPaint(Color.BLACK);
    g2.drawGlyphVector(gv, cw - xx, ch / 2f - yy);
    xx = (cw + gv.getVisualBounds().getWidth() - xx &gt; 0) ? xx + 2f : 0f;
  }
  @Override public void actionPerformed(ActionEvent e) {
    repaint();
  }
}
</code></pre>

## 解説
上記のサンプルでは、`GlyphVector`や`LineMetrics`からテキストの`VisualBounds`や`Ascent`を取得して文字列を描画する位置などを計算しています。

- - - -
- 以下のように`TextLayout`を使用する方法もある
    
    <pre class="prettyprint"><code>TextLayout tl = new TextLayout(text, font, frc);
    Rectangle2D b = tl.getBounds();
    yy = tl.getAscent() / 2f + (float) b.getY();
</code></pre>
- * 参考リンク [#reference]
- [GlyphVector (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/font/GlyphVector.html)
- [TextLayout (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/font/TextLayout.html)

<!-- dummy comment line for breaking list -->

## コメント
