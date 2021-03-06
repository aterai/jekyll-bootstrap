---
layout: post
category: swing
folder: StrokeMatteBorder
title: BasicStrokeで指定した辺の描画を行うBorderを作成する
tags: [Border, MatteBorder, StrokeBorder]
author: aterai
pubdate: 2015-08-03T02:50:24+09:00
description: MatteBorderの縁の塗り潰しの代わりにBasicStrokeで点線を描画するBorderを作成します。
image: https://lh3.googleusercontent.com/-HScDivtTraE/Vb46osyI3fI/AAAAAAAAN-c/-Tgk6AYSPN8/s800-Ic42/StrokeMatteBorder.png
comments: true
---
## 概要
`MatteBorder`の縁の塗り潰しの代わりに`BasicStroke`で点線を描画する`Border`を作成します。

{% download https://lh3.googleusercontent.com/-HScDivtTraE/Vb46osyI3fI/AAAAAAAAN-c/-Tgk6AYSPN8/s800-Ic42/StrokeMatteBorder.png %}

## サンプルコード
<pre class="prettyprint"><code>class StrokeMatteBorder extends EmptyBorder {
  private final transient BasicStroke stroke;
  private final Paint paint;

  public StrokeMatteBorder(int top, int left, int bottom, int right,
                           BasicStroke stroke, Paint paint) {
    super(top, left, bottom, right);
    this.stroke = stroke;
    this.paint = paint;
  }
  @Override public void paintBorder(Component c, Graphics g,
                                    int x, int y, int width, int height) {
    float size = stroke.getLineWidth();
    if (size &gt; 0f) {
      Insets insets = getBorderInsets(c);
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setStroke(this.stroke);
      g2.setPaint(Objects.nonNull(this.paint)
                  ? this.paint : Objects.nonNull(c)
                  ? c.getForeground() : null);
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                          RenderingHints.VALUE_ANTIALIAS_ON);
      g2.translate(x, y);

      int s = (int) (.5f + size);
      int sd2 = (int) (.5f + size / 2d);
      if (insets.top &gt; 0) {
        g2.drawLine(0, sd2, width - s, sd2);
      }
      if (insets.left &gt; 0) {
        g2.drawLine(sd2, sd2, sd2, height - s);
      }
      if (insets.bottom &gt; 0) {
        g2.drawLine(0, height - s, width - s, height - s);
      }
      if (insets.right &gt; 0) {
        g2.drawLine(width - sd2, 0, width - sd2, height - s);
      }
      g2.dispose();
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`MatteBorder`の飾り縁のように、指定されたインセット、色、`BasicStroke`で描画する`Border`を使用して、全体の罫線が点線で描画される表を作成しています。

- `JLabel`で作成した各セルに、右下辺を黒い点線で描画するボーダーを設定
- これらのセルを`GridBagLayout`で配置した`JPanel`に、上左辺を赤い点線で描画するボーダーを設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [StrokeBorder (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/border/StrokeBorder.html)
- [MatteBorder (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/border/MatteBorder.html)

<!-- dummy comment line for breaking list -->

## コメント
