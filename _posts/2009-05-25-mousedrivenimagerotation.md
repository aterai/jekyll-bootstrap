---
layout: post
category: swing
folder: MouseDrivenImageRotation
title: Mouseで画像を移動、回転
tags: [ImageIcon, MouseListener, MouseMotionListener, AffineTransform, Area]
author: aterai
pubdate: 2009-05-25T13:21:41+09:00
description: 画像をマウスのドラッグで任意の位置に移動、回転します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQAQVe8YI/AAAAAAAAAe4/y6GTZLKjqx0/s800/MouseDrivenImageRotation.png
comments: true
---
## 概要
画像をマウスのドラッグで任意の位置に移動、回転します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQAQVe8YI/AAAAAAAAAe4/y6GTZLKjqx0/s800/MouseDrivenImageRotation.png %}

## サンプルコード
<pre class="prettyprint"><code>class DraggableImageMouseListener extends MouseAdapter {
  private static final BasicStroke BORDER_STROKE = new BasicStroke(4f);
  private static final Color BORDER_COLOR = Color.WHITE;
  private static final Color HOVER_COLOR  = new Color(100, 255, 200, 100);
  private static final int IR = 40;
  private static final int OR = IR * 3;
  private final Shape border;
  private final Shape polaroid;
  private final RectangularShape inner = new Ellipse2D.Double(0, 0, IR, IR);
  private final RectangularShape outer = new Ellipse2D.Double(0, 0, OR, OR);
  private final Point2D startPt  = new Point2D.Double(); //drag start point
  private final Point2D centerPt = new Point2D.Double(100d, 100d); //center of Image
  private final Dimension imageSz;
  private final Image image;
  private double radian = 45d * (Math.PI / 180d);
  private double startRadian; //drag start radian
  private boolean moverHover;
  private boolean rotatorHover;

  protected DraggableImageMouseListener(ImageIcon ii) {
    super();
    image = ii.getImage();
    int width  = ii.getIconWidth();
    int height = ii.getIconHeight();
    imageSz  = new Dimension(width, height);
    border   = new RoundRectangle2D.Double(0, 0, width, height, 10, 10);
    polaroid = new Rectangle2D.Double(-2, -2, width + 4, height + 20);
    setCirclesLocation(centerPt);
  }
  private void setCirclesLocation(Point2D center) {
    double cx = center.getX();
    double cy = center.getY();
    inner.setFrameFromCenter(cx, cy, cx + IR / 2d, cy - IR / 2d);
    outer.setFrameFromCenter(cx, cy, cx + OR / 2d, cy - OR / 2d);
  }
  public void paint(Graphics g, ImageObserver observer) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);

    double w2 = imageSz.width / 2d;
    double h2 = imageSz.height / 2d;
    AffineTransform at = AffineTransform.getTranslateInstance(
        centerPt.getX() - w2, centerPt.getY() - h2);
    at.rotate(radian, w2, h2);

    g2.setPaint(BORDER_COLOR);
    g2.setStroke(BORDER_STROKE);
    Shape s = at.createTransformedShape(polaroid);
    g2.fill(s);
    g2.draw(s);

    g2.drawImage(image, at, observer);

    if (rotatorHover) {
      Area donut = new Area(outer);
      donut.subtract(new Area(inner));
      g2.setPaint(HOVER_COLOR);
      g2.fill(donut);
    } else if (moverHover) {
      g2.setPaint(HOVER_COLOR);
      g2.fill(inner);
    }

    g2.setPaint(BORDER_COLOR);
    g2.setStroke(BORDER_STROKE);
    g2.draw(at.createTransformedShape(border));
    g2.dispose();
  }
  @Override public void mouseMoved(MouseEvent e) {
    if (outer.contains(e.getX(), e.getY()) &amp;&amp; !inner.contains(e.getX(), e.getY())) {
      moverHover = false;
      rotatorHover = true;
    } else if (inner.contains(e.getX(), e.getY())) {
      moverHover = true;
      rotatorHover = false;
    } else {
      moverHover = false;
      rotatorHover = false;
    }
    e.getComponent().repaint();
  }
  @Override public void mouseReleased(MouseEvent e) {
    rotatorHover = false;
    moverHover = false;
    e.getComponent().repaint();
  }
  @Override public void mousePressed(MouseEvent e) {
    if (outer.contains(e.getX(), e.getY()) &amp;&amp; !inner.contains(e.getX(), e.getY())) {
      rotatorHover = true;
      startRadian = radian - Math.atan2(
          e.getY() - centerPt.getY(), e.getX() - centerPt.getX());
      e.getComponent().repaint();
    } else if (inner.contains(e.getX(), e.getY())) {
      moverHover = true;
      startPt.setLocation(e.getPoint());
      e.getComponent().repaint();
    }
  }
  @Override public void mouseDragged(MouseEvent e) {
    if (rotatorHover) {
      radian = startRadian + Math.atan2(
          e.getY() - centerPt.getY(), e.getX() - centerPt.getX());
      e.getComponent().repaint();
    } else if (moverHover) {
      centerPt.setLocation(centerPt.getX() + e.getX() - startPt.getX(),
                           centerPt.getY() + e.getY() - startPt.getY());
      setCirclesLocation(centerPt);
      startPt.setLocation(e.getPoint());
      e.getComponent().repaint();
    }
  }
}
</code></pre>

## 解説
- 画像の移動: 画像の中心にマウスが近づくと表示される円図形をドラッグ
- 画像の回転: 上記の円図形の外側に表示されるドーナツ型図形をドラッグ
    - ドーナツ型図形は、`Area#subtract(Area)`メソッドを使用して作成可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Life is beautiful: 習作UI：初めてのFlash その３](http://satoshi.blogs.com/life/2007/05/uiflash_2.html)
    - `Flash`の`UI`を参考
- [Area#subtract(Area) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/geom/Area.html#subtract-java.awt.geom.Area-)

<!-- dummy comment line for breaking list -->

## コメント
