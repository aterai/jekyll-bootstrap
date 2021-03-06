---
layout: post
category: swing
folder: GeneralPath
title: GeneralPathなどで星型図形を作成する
tags: [GeneralPath, Path2D, Polygon, Icon, AffineTransform, Font]
author: aterai
pubdate: 2009-02-09T18:26:33+09:00
description: GeneralPathなどを使って星型の図形をパネルに描画したり、アイコンを作成します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTNT-1toKI/AAAAAAAAAak/t96zX52eOVg/s800/GeneralPath.png
comments: true
---
## 概要
`GeneralPath`などを使って星型の図形をパネルに描画したり、アイコンを作成します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTNT-1toKI/AAAAAAAAAak/t96zX52eOVg/s800/GeneralPath.png %}

## サンプルコード
<pre class="prettyprint"><code>class StarPanel1 extends JPanel {
  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D) g.create();
    int w = getWidth();
    int h = getHeight();
    //&lt;blockquote cite="%JAVA_HOME%/demo/jfc/Java2D/src/java2d/demos/Lines/Joins.java"&gt;
    GeneralPath p = new GeneralPath();
    p.moveTo(-w / 4f, -h / 12f);
    p.lineTo(+w / 4f, -h / 12f);
    p.lineTo(-w / 6f, +h / 4f);
    p.lineTo(+    0f, -h / 4f);
    p.lineTo(+w / 6f, +h / 4f);
    p.closePath();
    //&lt;/blockquote&gt;
    g2.translate(w / 2, h / 2);
    g2.setColor(Color.YELLOW);
    g2.fill(p);
    g2.setColor(Color.BLACK);
    g2.draw(p);
    g2.dispose();
  }
}
</code></pre>

<pre class="prettyprint"><code>class StarIcon2 implements Icon {
  private static final int R1 = 20;
  private static final int R2 = 40;
  //double R1 = R2 * Math.sin(Math.PI / 10d) / Math.cos(Math.PI / 5d); //= 15d;
  private static final int VC = 5; //16;
  private final AffineTransform at;
  private final Shape star;
  public StarIcon2() {
    double agl = 0d;
    double add = 2 * Math.PI / (VC * 2);
    Path2D p = new Path2D.Double();
    p.moveTo(R2 * 1, R2 * 0);
    for (int i = 0; i &lt; VC * 2 - 1; i++) {
      agl += add;
      if (i % 2 == 0) {
        p.lineTo(R1 * Math.cos(agl), R1 * Math.sin(agl));
      } else {
        p.lineTo(R2 * Math.cos(agl), R2 * Math.sin(agl));
      }
    }
    p.closePath();
    at = AffineTransform.getRotateInstance(-Math.PI / 2, R2, 0);
    star = new Path2D.Double(p, at);
  }
  @Override public int getIconWidth() {
    return 2 * R2;
  }
  @Override public int getIconHeight() {
    return 2 * R2;
  }
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.translate(x, y);
    g2.setPaint(Color.YELLOW);
    g2.fill(star);
    g2.setPaint(Color.BLACK);
    g2.draw(star);
    g2.dispose();
  }
}
</code></pre>

## 解説
- 上段、左
    - `GeneralPath`(=`Path2D.Float`)を使用して星型図形を作成
    - `%JAVA_HOME%/demo/jfc/Java2D/src/java2d/demos/Lines/Joins.java`を参考
- 上段、中
    - `Polygon`を使用して星型図形を作成
- 上段、右
    - `Font`から星型文字★(`U+2605`)のアウトラインを取得して描画
- 下段、左
    - `10`個の頂点を予め計算して`GeneralPath`で星型を作成
    - [ついにベールを脱いだJavaFX：第9回 アニメーションを用いてより魅力的に［応用編］｜gihyo.jp … 技術評論社](http://gihyo.jp/dev/serial/01/javafx/0009?page=2) を参考
- 下段、中
    - `Icon#paintIcon(...)`メソッドをオーバーライドして`Path2D.Double`で星型図形を描画
    - 外周の半径: `40px`
- 下段、右
    - `Icon#paintIcon(...)`メソッドをオーバーライドして`Path2D.Double`で星型図形を描画
    - 外周の半径: `40px`
    - 内周の半径: `20px`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [GeneralPath (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/geom/GeneralPath.html)
- [Polygon (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Polygon.html)
- [Path2D (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/geom/Path2D.html)
- `%JAVA_HOME%/demo/jfc/Java2D/src/java2d/demos/Lines/Joins.java`
- [ついにベールを脱いだJavaFX：第9回 アニメーションを用いてより魅力的に［応用編］｜gihyo.jp … 技術評論社](http://gihyo.jp/dev/serial/01/javafx/0009?page=2)
- [Java2D Shapes project.](http://java-sl.com/shapes.html)
- [プログラマメモ2: 扇形っぽいのを描く](http://programamemo2.blogspot.com/2008/12/java.html)
- [PathIteratorからSVGを生成](https://ateraimemo.com/Swing/PathIterator.html)

<!-- dummy comment line for breaking list -->

## コメント
