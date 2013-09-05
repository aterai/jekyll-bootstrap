---
layout: post
title: GlyphVectorで文字列を電光掲示板風にスクロール
category: swing
folder: ScrollingMessage
tags: [GlyphVector, LineMetrics, TextLayout, Animation, JComponent]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-11-13

## GlyphVectorで文字列を電光掲示板風にスクロール
`GlyphVector`を生成して、これを電光掲示板のようにスクロールさせます。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTSlbxO22I/AAAAAAAAAjA/SJLXTaAYArY/s800/ScrollingMessage.png)

### サンプルコード
<pre class="prettyprint"><code>class MarqueePanel extends JComponent implements ActionListener {
  public final javax.swing.Timer animator;
  private final GlyphVector gv;
  private float xx, yy;
  public MarqueePanel() {
    super();
    animator = new javax.swing.Timer(10, this);
    String text = "asffdfaaAAASFDsfasdfsdfasdfasd";
    Font font = new Font(Font.SERIF, Font.PLAIN, 100);
    FontRenderContext frc = new FontRenderContext(null,true,true);
    gv = font.createGlyphVector(frc, text);
    LineMetrics lm = font.getLineMetrics(text, frc);
    yy = lm.getAscent()/2f + (float)gv.getVisualBounds().getY();
  }
  @Override public void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D)g;
    int cw = getWidth();
    int ch = getHeight();
    g2.setPaint(Color.WHITE);
    g2.draw(new Line2D.Float(0,ch/2f,cw,ch/2f));
    g2.setPaint(Color.BLACK);
    g2.drawGlyphVector(gv, cw-xx, ch/2f-yy);
    xx = (cw+gv.getVisualBounds().getWidth()-xx &gt; 0) ? xx+2f : 0f;
  }
  @Override public void actionPerformed(ActionEvent e) {
    repaint();
  }
}
</code></pre>

### 解説
上記のサンプルでは、`GlyphVector`や`LineMetrics`から、テキストの`VisualBounds`や`Ascent`を取得して、文字列を描画する位置などを計算しています。

以下のように`TextLayout`を使用する方法もあります。

<pre class="prettyprint"><code>TextLayout tl = new TextLayout(text, font, frc);
Rectangle2D b = tl.getBounds();
yy = tl.getAscent()/2f + (float)b.getY();
</code></pre>

### コメント