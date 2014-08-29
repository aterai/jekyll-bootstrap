---
layout: post
title: Fontを回転する
category: swing
folder: TransformedShape
tags: [Font, Shape, TextLayout, Animation, AffineTransform]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-10-30

## Fontを回転する
文字のアウトラインを取得して、これを回転してみます。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTVtRPTfJI/AAAAAAAAAoE/Qiy0jcMt_l0/s800/TransformedShape.png %}

### サンプルコード
<pre class="prettyprint"><code>class FontRotateAnimation extends JComponent implements ActionListener {
  private final javax.swing.Timer animator;
  private int rotate;
  private final Shape shape;
  private Shape s;
  public FontRotateAnimation(String str) {
    super();
    animator = new javax.swing.Timer(5, this);
    addHierarchyListener(new HierarchyListener() {
      @Override public void hierarchyChanged(HierarchyEvent e) {
        JComponent c = (JComponent)e.getSource();
        if((e.getChangeFlags() &amp; HierarchyEvent.DISPLAYABILITY_CHANGED)!=0 &amp;&amp;
           animator!=null &amp;&amp; !c.isDisplayable()) {
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
  @Override public void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D)g;
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);
    g2.setPaint(Color.BLACK);
    g2.fill(s);
  }
  @Override public void actionPerformed(ActionEvent e) {
    repaint(s.getBounds());
    Rectangle2D b = shape.getBounds();
    Point2D.Double p = new Point2D.Double(
        b.getX() + b.getWidth()/2d, b.getY() + b.getHeight()/2d);
    AffineTransform at = AffineTransform.getRotateInstance(
        Math.toRadians(rotate), p.getX(), p.getY());
    AffineTransform toCenterAT = AffineTransform.getTranslateInstance(
        getWidth()/2d - p.getX(), getHeight()/2d - p.getY());
    Shape s1 = at.createTransformedShape(shape);
    s = toCenterAT.createTransformedShape(s1);
    repaint(s.getBounds());
    rotate = (rotate&gt;=360) ? 0 : rotate+2;
  }
}
</code></pre>

### 解説
上記のサンプルでは、`TextLayout`から文字列のアウトラインを`Shape`として取得しています。

### コメント
