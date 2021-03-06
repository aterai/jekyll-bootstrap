---
layout: post
category: swing
folder: TransformedShape
title: Fontを回転する
tags: [Font, Shape, TextLayout, Animation, AffineTransform]
author: aterai
pubdate: 2006-10-30T12:57:51+09:00
description: Fontから文字のアウトラインを取得し、その中心をアンカーポイントに設定して回転します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTVtRPTfJI/AAAAAAAAAoE/Qiy0jcMt_l0/s800/TransformedShape.png
comments: true
---
## 概要
`Font`から文字のアウトラインを取得し、その中心をアンカーポイントに設定して回転します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTVtRPTfJI/AAAAAAAAAoE/Qiy0jcMt_l0/s800/TransformedShape.png %}

## サンプルコード
<pre class="prettyprint"><code>class FontRotateAnimation extends JComponent implements ActionListener {
  private final Timer animator;
  private int rotate;
  private final Shape shape;
  private Shape s;
  public FontRotateAnimation(String str) {
    super();
    animator = new Timer(10, this);
    addHierarchyListener(new HierarchyListener() {
      @Override public void hierarchyChanged(HierarchyEvent e) {
        if ((e.getChangeFlags() &amp; HierarchyEvent.DISPLAYABILITY_CHANGED) != 0
            &amp;&amp; animator != null &amp;&amp; !e.getComponent().isDisplayable()) {
          animator.stop();
        }
      }
    });
    Font font = new Font(Font.SERIF, Font.PLAIN, 200);
    FontRenderContext frc = new FontRenderContext(null, true, true);
    shape = new TextLayout(str, font, frc).getOutline(null);
    s = shape;
    animator.start();
  }
  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);
    g2.setPaint(Color.BLACK);
    g2.fill(s);
    g2.dispose();
  }
  @Override public void actionPerformed(ActionEvent e) {
    repaint(s.getBounds());
    Rectangle2D b = shape.getBounds2D();
    Point2D p = new Point2D.Double(
        b.getX() + b.getWidth() / 2d, b.getY() + b.getHeight() / 2d);
    AffineTransform at = AffineTransform.getRotateInstance(
        Math.toRadians(rotate), p.getX(), p.getY());
    AffineTransform toCenterAT = AffineTransform.getTranslateInstance(
        getWidth() / 2d - p.getX(), getHeight() / 2d - p.getY());
    Shape s1 = at.createTransformedShape(shape);
    s = toCenterAT.createTransformedShape(s1);
    repaint(s.getBounds());
    rotate = rotate &gt;= 360 ? 0 : rotate + 2;
  }
}
</code></pre>

## 解説
上記のサンプルでは、対象文字、`Font`、`FontRenderContext`から`TextLayout`を生成し、`TextLayout#getOutline()`メソッドで文字のアウトラインを`Shape`として取得しています。

- - - -
- `OpenJDK Corretto-8.212`で実行すると回転中にフォント表示が乱れる件は、[Java2D rendering may break when using soft clipping effects · Issue #127 · corretto/corretto-8](https://github.com/corretto/corretto-8/issues/127)、`8u222`で修正済み ~~される予定~~

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TextLayout (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/font/TextLayout.html)
- [TextLayoutでFontのメトリック情報を取得する](https://ateraimemo.com/Swing/TextLayout.html)

<!-- dummy comment line for breaking list -->

## コメント
