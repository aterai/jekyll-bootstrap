---
layout: post
category: swing
folder: GlyphVector
title: JLabelの文字列を折り返し
tags: [JLabel, GlyphVector, JTextArea, LineBreakMeasurer]
author: aterai
pubdate: 2004-03-01T11:56:19+09:00
description: GlyphVectorを使って、ラベルの文字列を折り返して表示します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTNbQw2SHI/AAAAAAAAAaw/AApL8KKml8E/s800/GlyphVector.png
comments: true
---
## 概要
`GlyphVector`を使って、ラベルの文字列を折り返して表示します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTNbQw2SHI/AAAAAAAAAaw/AApL8KKml8E/s800/GlyphVector.png %}

## サンプルコード
<pre class="prettyprint"><code>class WrappedLabel extends JLabel {
  private GlyphVector gvtext;
  private int width = -1;
  public WrappedLabel() {
    this(null);
  }

  public WrappedLabel(String str) {
    super(str);
  }

  @Override public void doLayout() {
    Insets i = getInsets();
    int w = getWidth() - i.left - i.right;
    if (w != width) {
      Font font = getFont();
      FontMetrics fm = getFontMetrics(font);
      FontRenderContext frc = fm.getFontRenderContext();
      gvtext = getWrappedGlyphVector(getText(), w, font, frc);
      width = w;
    }
    super.doLayout();
  }

  @Override protected void paintComponent(Graphics g) {
    if (gvtext == null) {
      super.paintComponent(g);
    } else {
      Insets i = getInsets();
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setPaint(Color.RED);
      g2.drawGlyphVector(gvtext, i.left, getFont().getSize() + i.top);
      g2.dispose();
    }
  }

  private GlyphVector getWrappedGlyphVector(
      String str, float width, Font font, FontRenderContext frc) {
    Point2D gmPos = new Point2D.Double(0d, 0d);
    GlyphVector gv = font.createGlyphVector(frc, str);
    float lineheight = (float) (gv.getLogicalBounds().getHeight());
    float xpos = 0f;
    float advance = 0f;
    int lineCount = 0;
    GlyphMetrics gm;
    for (int i = 0; i &lt; gv.getNumGlyphs(); i++) {
      gm = gv.getGlyphMetrics(i);
      advance = gm.getAdvance();
      if (xpos &lt; width &amp;&amp; width &lt;= xpos + advance) {
        lineCount++;
        xpos = 0f;
      }
      gmPos.setLocation(xpos, lineheight * lineCount);
      gv.setGlyphPosition(i, gmPos);
      xpos = xpos + advance;
    }
    return gv;
  }
}
</code></pre>

## 解説
- 上: `JLabel`
    - デフォルトの`JLabel`で折り返しせずに右側から`...`で省略
- 中: `GlyphVector`
    - コンテナのサイズが変更されるたびに`GlyphVector`を更新して文字列の折り返しを実行
    - 欧文などで合字(リガチャ)がある場合は`GlyphVector gv = font.createGlyphVector(frc, str);`ではなく、[GlyphVector bounds and kerning, ligatures | Oracle Forums](https://community.oracle.com/thread/1289266)のように`char[] chars = text.toCharArray(); GlyphVector gv = font.layoutGlyphVector(frc, chars, 0, chars.length, Font.LAYOUT_LEFT_TO_RIGHT);`とした方が良さそう
- 下: `JTextArea`
    - `JLabel`の`Font`と背景色を同じものに設定した編集不可の`JTextArea`を`setLineWrap(true);`として文字列の折り返しを実行

<!-- dummy comment line for breaking list -->

- - - -
- ラベルの幅ではなく任意の場所で文字列を改行したい場合は、以下のように`JLabel`に`html`の`<br>`タグを利用したり、編集不可にした`JTextPane`、`JTextArea`などが使用可能
    - 参考: [JTextPane、JLabelなどで複数行を表示](https://ateraimemo.com/Swing/MultiLineLabel.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>label.setText("&lt;html&gt;文字列を適当なところで&lt;br /&gt;折り返す。");
</code></pre>

- - - -
- `AttributedString`と`LineBreakMeasurer`を使って文字列の折り返しを描画する方法もある

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class WrappingLabel extends JLabel {
  public WrappingLabel(String text) {
    super(text);
  }

  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D) g.create();
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
    while (lbm.getPosition() &lt; aci.getEndIndex()) {
      TextLayout tl = lbm.nextLayout(w);
      tl.draw(g2, x, y + tl.getAscent());
      y += tl.getDescent() + tl.getLeading() + tl.getAscent();
    }
    g2.dispose();
  }
}
</code></pre>

## 参考リンク
- [Drawing Multiple Lines of Text (The Java™ Tutorials > 2D Graphics > Working with Text APIs)](https://docs.oracle.com/javase/tutorial/2d/text/drawmulstring.html)
- [LineBreakMeasurer (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/font/LineBreakMeasurer.html)
- [JDK-6479801 java.awt.font.LineBreakMeasurer code incorrect - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6479801)

<!-- dummy comment line for breaking list -->

## コメント
- `JTextArea#setLineWrap(true);`を使う方法を追加、スクリーンショットの更新。 -- *aterai* 2009-01-05 (月) 17:15:36
- `LineBreakMeasurer`を使用する方法を追加。 -- *aterai* 2013-01-01 (火) 22:38:47

<!-- dummy comment line for breaking list -->
