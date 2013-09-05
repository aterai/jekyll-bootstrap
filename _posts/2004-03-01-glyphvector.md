---
layout: post
title: JLabelの文字列を折り返し
category: swing
folder: GlyphVector
tags: [JLabel, GlyphVector, JTextArea, LineBreakMeasurer]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-03-01

## JLabelの文字列を折り返し
`GlyphVector`を使って、ラベルの文字列を折り返して表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTNbQw2SHI/AAAAAAAAAaw/AApL8KKml8E/s800/GlyphVector.png)

### サンプルコード
<pre class="prettyprint"><code>class WrappedLabel extends JLabel {
  private GlyphVector gvtext;
  public WrappedLabel() {
    this(null);
  }
  public WrappedLabel(String str) {
    super(str);
  }
  private int prevwidth = -1;
  @Override public void doLayout() {
    Insets i = getInsets();
    int w = getWidth()-i.left-i.right;
    if(w!=prevwidth) {
      Font font = getFont();
      FontMetrics fm = getFontMetrics(font);
      FontRenderContext frc = fm.getFontRenderContext();
      gvtext = getWrappedGlyphVector(getText(), w, font, frc);
      prevwidth = w;
    }
    super.doLayout();
  }
  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D)g;
    if(gvtext!=null) {
      Insets i = getInsets();
      g2.setPaint(Color.RED);
      g2.drawGlyphVector(gvtext, i.left, getFont().getSize()+i.top);
    }else{
      super.paintComponent(g);
    }
  }
  private GlyphVector getWrappedGlyphVector(
      String str, float width, Font font, FontRenderContext frc) {
    Point2D gmPos  = new Point2D.Double(0.0d, 0.0d);
    GlyphVector gv   = font.createGlyphVector(frc, str);
    float lineheight = (float) (gv.getLogicalBounds().getHeight());
    float xpos     = 0.0f;
    float advance  = 0.0f;
    int   lineCount  = 0;
    GlyphMetrics gm;
    for(int i=0;i&lt;gv.getNumGlyphs();i++) {
      gm = gv.getGlyphMetrics(i);
      advance = gm.getAdvance();
      if(xpos&lt;width &amp;&amp; width&lt;=xpos+advance) {
        lineCount++;
        xpos = 0.0f;
      }
      gmPos.setLocation(xpos, lineheight*lineCount);
      gv.setGlyphPosition(i, gmPos);
      xpos = xpos + advance;
    }
    return gv;
  }
}
</code></pre>

### 解説
- 上: `JLabel`
- 中: `GlyphVector`
    - ラベルのサイズが変更されるたびに`GlyphVector`を更新することで、文字列の折り返しを行っています。
- 下: `JTextArea`
    - `JLabel`の`Font`と背景色を同じものに設定した編集不可の`JTextArea`を`setLineWrap(true);`として、文字列の折り返しを行っています。

<!-- dummy comment line for breaking list -->

- - - -
ラベルの幅ではなく、任意の場所で文字列を改行したい場合は、以下のように`JLabel`に`html`の`<br>`タグを利用したり、編集不可にした`JTextPane`、`JTextArea`などを使用します(参考:[JTextPane、JLabelなどで複数行を表示](http://terai.xrea.jp/Swing/MultiLineLabel.html))。

<pre class="prettyprint"><code>label.setText("&lt;html&gt;文字列を適当なところで&lt;br /&gt;折り返す。");
</code></pre>

- - - -
`AttributedString`と`LineBreakMeasurer`を使って、文字列の折り返しを描画する方法もあります。

<pre class="prettyprint"><code>class WrappingLabel extends JLabel {
  public WrappingLabel(String text) {
    super(text);
  }
  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D)g.create();
    g2.setPaint(getForeground());
    Insets i = getInsets();
    float x = i.left;
    float y = i.top;
    int w = getWidth() - i.left - i.right;
    AttributedString as = new AttributedString(getText());
    as.addAttribute(TextAttribute.FONT, getFont());
    AttributedCharacterIterator aci = as.getIterator();
    FontRenderContext frc = g2.getFontRenderContext();
    LineBreakMeasurer lbm = new LineBreakMeasurer(aci, frc);
    while(lbm.getPosition() &lt; aci.getEndIndex()) {
      TextLayout tl = lbm.nextLayout(w);
      tl.draw(g2, x, y + tl.getAscent());
      y += tl.getDescent() + tl.getLeading() + tl.getAscent();
    }
    g2.dispose();
  }
}
</code></pre>

### 参考リンク
- [How to Use Labels](http://docs.oracle.com/javase/tutorial/uiswing/components/label.html)
- [LineBreakMeasurer (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/java/awt/font/LineBreakMeasurer.html)

<!-- dummy comment line for breaking list -->

### コメント
- `JTextArea#setLineWrap(true);`を使う方法を追加、スクリーンショットの更新。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-01-05 (月) 17:15:36
- `LineBreakMeasurer`を使用する方法を追加。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-01-01 (火) 22:38:47

<!-- dummy comment line for breaking list -->
