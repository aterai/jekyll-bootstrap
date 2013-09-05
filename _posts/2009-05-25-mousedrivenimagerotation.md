---
layout: post
title: Mouseで画像を移動、回転
category: swing
folder: MouseDrivenImageRotation
tags: [ImageIcon, MouseListener, MouseMotionListener, AffineTransform]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-05-25

## Mouseで画像を移動、回転
画像をマウスのドラッグで任意の位置に移動、回転します。[Life is beautiful: 習作UI：初めてのFlash その２](http://satoshi.blogs.com/life/2007/05/uiflash_1.html)、[その３](http://satoshi.blogs.com/life/2007/05/uiflash_2.html)からの移植になります。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTQAQVe8YI/AAAAAAAAAe4/y6GTZLKjqx0/s800/MouseDrivenImageRotation.png)

### サンプルコード
<pre class="prettyprint"><code>class DraggableImageMouseListener extends MouseAdapter{
  private static final Color color = new Color(100,255,200,100);
  private static final int ir = 40, or = ir*3;
  public final Ellipse2D.Double inner = new Ellipse2D.Double(0,0,ir,ir);
  public final Ellipse2D.Double outer = new Ellipse2D.Double(0,0,or,or);
  public final Image image;
  public final int width;
  public final int height;
  public final double centerX, centerY;
  public double x = 10.0, y = 50.0, rotate = 45.0 * (Math.PI / 180.0);
  public double startX, startY, startA;
  private boolean moverHover, rotatorHover;

  public DraggableImageMouseListener(ImageIcon ii) {
    image   = ii.getImage();
    width   = ii.getIconWidth();
    height  = ii.getIconHeight();
    centerX = width/2.0;
    centerY = height/2.0;
    inner.x = (x+centerX-ir/2);
    inner.y = (y+centerY-ir/2);
    outer.x = (x+centerX-or/2);
    outer.y = (y+centerY-or/2);
  }
  public void paint(Graphics g, ImageObserver ior) {
    Graphics2D g2d = (Graphics2D)g;
    AffineTransform at = AffineTransform.getTranslateInstance(x, y);
    at.rotate(rotate, centerX, centerY);
    g2d.drawImage(image, at, ior);
    g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
    if(rotatorHover) {
      Area donut = new Area(outer);
      donut.subtract(new Area(inner));
      g2d.setPaint(color);
      g2d.fill(donut);
    }else if(moverHover) {
      g2d.setPaint(color);
      g2d.fill(inner);
    }
  }
  @Override public void mouseMoved(MouseEvent e) {
    if(outer.contains(e.getX(), e.getY()) &amp;&amp; !inner.contains(e.getX(), e.getY())) {
      moverHover = false; rotatorHover = true;
    }else if(inner.contains(e.getX(), e.getY())) {
      moverHover = true;  rotatorHover = false;
    }else{
      moverHover = rotatorHover =false;
    }
    ((JComponent)e.getSource()).repaint();
  }
  @Override public void mouseReleased(MouseEvent e) {
    rotatorHover = moverHover = false;
    ((JComponent)e.getSource()).repaint();
  }
  @Override public void mousePressed(MouseEvent e) {
    if(outer.contains(e.getX(), e.getY()) &amp;&amp; !inner.contains(e.getX(), e.getY())) {
      rotatorHover = true;
      startA = rotate - Math.atan2(e.getY()-y-centerY, e.getX()-x-centerX);
      ((JComponent)e.getSource()).repaint();
    }else if(inner.contains(e.getX(), e.getY())) {
      moverHover = true;
      startX = e.getX();
      startY = e.getY();
      ((JComponent)e.getSource()).repaint();
    }
  }
  @Override public void mouseDragged(MouseEvent e) {
    if(rotatorHover) {
      rotate = startA + Math.atan2(e.getY()-y-centerY, e.getX()-x-centerX);
      ((JComponent)e.getSource()).repaint();
    }else if(moverHover) {
      x += e.getX() - startX;
      y += e.getY() - startY;
      inner.x = (x+centerX-ir/2);
      inner.y = (y+centerY-ir/2);
      outer.x = (x+centerX-or/2);
      outer.y = (y+centerY-or/2);
      startX  = e.getX();
      startY  = e.getY();
      ((JComponent)e.getSource()).repaint();
    }
  }
}
</code></pre>

### 解説
画像の中心をドラッグすると移動、すこし外側をドラッグすると画像を回転することができます。

- - - -
回転のためのドーナツ状の図形は、`Area#subtract`メソッドを使用して作成しています。

### 参考リンク
- [Life is beautiful: 習作UI：初めてのFlash その２](http://satoshi.blogs.com/life/2007/05/uiflash_1.html)
- [Life is beautiful: 習作UI：初めてのFlash その３](http://satoshi.blogs.com/life/2007/05/uiflash_2.html)

<!-- dummy comment line for breaking list -->

### コメント