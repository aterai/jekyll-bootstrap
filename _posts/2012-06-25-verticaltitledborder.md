---
layout: post
category: swing
folder: VerticalTitledBorder
title: TitledBorderのタイトルを縦(左側)に表示する
tags: [Border, TitledBorder, JLabel]
author: aterai
pubdate: 2012-06-25T18:19:01+09:00
description: TitledBorderのタイトル文字列を縦(左側)に表示します。
image: https://lh4.googleusercontent.com/-ndnU9h6kzPw/T-gQmrTVqdI/AAAAAAAABOQ/KwNEpVGLDa0/s800/VerticalTitledBorder.png
comments: true
---
## 概要
`TitledBorder`のタイトル文字列を縦(左側)に表示します。

{% download https://lh4.googleusercontent.com/-ndnU9h6kzPw/T-gQmrTVqdI/AAAAAAAABOQ/KwNEpVGLDa0/s800/VerticalTitledBorder.png %}

## サンプルコード
<pre class="prettyprint"><code>class VerticalTitledBorder extends TitledBorder {
  private final JLabel label;
  public VerticalTitledBorder(String title) {
    super(title);
    this.label = new JLabel(title);
    this.label.setOpaque(true);
    //this.label.putClientProperty(BasicHTML.propertyKey, null);
  }
  @Override public void paintBorder(
      Component c, Graphics g, int x, int y, int width, int height) {
    Border border = getBorder();
    String title = getTitle();
    if ((title != null) &amp;&amp; !title.isEmpty() &amp;&amp; border != null) {
      int edge = (border instanceof TitledBorder) ? 0 : EDGE_SPACING;
      JLabel label = getLabel(c);
      Dimension size = label.getPreferredSize();
      Insets insets = getBorderInsets(border, c, new Insets(0, 0, 0, 0));

      int borderX = x + edge;
      int borderY = y + edge;
      int borderW = width - edge - edge;
      int borderH = height - edge - edge;

      int labelH = size.height;
      int labelW = height - insets.top - insets.bottom; //TEST: - (edge * 8);
      if (labelW &gt; size.width) {
        labelW = size.width;
      }

      int ileft = edge + insets.left / 2 - labelH / 2;
      if (ileft &lt; edge) {
        borderX -= ileft;
        borderW += ileft;
      }
      border.paintBorder(c, g, borderX, borderY, borderW, borderH);

      Graphics2D g2 = (Graphics2D) g.create();
      g2.translate(0, (height + labelW) / 2);
      g2.rotate(Math.toRadians(-90));
      //or: g2.transform(AffineTransform.getQuadrantRotateInstance(-1));
      label.setSize(labelW, labelH);
      label.paint(g2);
      g2.dispose();
    } else {
      super.paintBorder(c, g, x, y, width, height);
    }
  }
  @Override public Insets getBorderInsets(Component c, Insets insets) {
    Border border = getBorder();
    insets = getBorderInsets(border, c, insets);
    String title = getTitle();
    if ((title != null) &amp;&amp; !title.isEmpty()) {
      int edge = (border instanceof TitledBorder) ? 0 : EDGE_SPACING;
      JLabel label = getLabel(c);
      Dimension size = label.getPreferredSize();
      if (insets.left &lt; size.height) {
        insets.left = size.height - edge;
      }
      insets.top += edge + TEXT_SPACING;
      insets.left += edge + TEXT_SPACING;
      insets.right += edge + TEXT_SPACING;
      insets.bottom += edge + TEXT_SPACING;
    }
    return insets;
  }

  //Copied from TitledBorder
  private Color getColor(Component c) {
    Color color = getTitleColor();
    if (color != null) {
      return color;
    }
    color = UIManager.getColor("TitledBorder.titleColor");
    if (color != null) {
      return color;
    }
    return (c != null) ? c.getForeground() : null;
  }
  private JLabel getLabel(Component c) {
    this.label.setText(getTitle());
    this.label.setFont(getFont(c));
    this.label.setForeground(getColor(c));
    this.label.setComponentOrientation(c.getComponentOrientation());
    this.label.setEnabled(c.isEnabled());
    this.label.setBackground(c.getBackground()); //???
    return this.label;
  }
  private static Insets getBorderInsets(
      Border border, Component c, Insets insets) {
    if (border == null) {
      insets.set(0, 0, 0, 0);
    } else if (border instanceof AbstractBorder) {
      AbstractBorder ab = (AbstractBorder) border;
      insets = ab.getBorderInsets(c, insets);
    } else {
      Insets i = border.getBorderInsets(c);
      insets.set(i.top, i.left, i.bottom, i.right);
    }
    return insets;
  }
}
</code></pre>

## 解説
- 左
    - `TitledBorder`のデフォルト(上)
    - `Java 7`から文字列が`Border`の幅より長い場合、`...`で省略されるようになった
- 中
    - `TitledBorder#paintBorder(...)`などをオーバーライドして、タイトルを左側に縦表示
- 右
    - `TitledBorder`と`VerticalTitledBorder`の組み合わせ

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TitledBorder (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/border/TitledBorder.html)

<!-- dummy comment line for breaking list -->

## コメント
