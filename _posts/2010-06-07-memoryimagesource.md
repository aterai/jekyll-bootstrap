---
layout: post
title: MemoryImageSourceで配列から画像を生成
category: swing
folder: MemoryImageSource
tags: [BufferedImage, MouseListener, MouseMotionListener, MemoryImageSource]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-06-07

## MemoryImageSourceで配列から画像を生成
マウスのドラッグに応じて線を描画、消しゴムで消去する機能を実装します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTPu_OEqoI/AAAAAAAAAec/z6MobKhblfI/s800/MemoryImageSource.png)

### サンプルコード
<pre class="prettyprint"><code>int[] pixels = new int[320 * 240];
MemoryImageSource source = new MemoryImageSource(320, 240, pixels, 0, 320);
int penc = 0x0;
@Override public void paintComponent(Graphics g) {
  super.paintComponent(g);
  if(backImage!=null) {
    ((Graphics2D)g).drawImage(backImage, 0, 0, this);
  }
  if(source!=null) {
    g.drawImage(createImage(source), 0, 0, null);
  }
}
@Override public void mouseDragged(MouseEvent e) {
  Point pt = e.getPoint();
  double xDelta = e.getX() - startPoint.getX();
  double yDelta = e.getY() - startPoint.getY();
  double delta = Math.max(Math.abs(xDelta), Math.abs(yDelta));

  double xIncrement = xDelta / delta;
  double yIncrement = yDelta / delta;
  double xStart = startPoint.x;
  double yStart = startPoint.y;
  for(int i=0; i&lt;delta; i++) {
    Point p = new Point((int)xStart, (int)yStart);
    if(p.x&lt;0 || p.y&lt;0 || p.x&gt;=320 || p.y&gt;=240) break;
    pixels[p.x + p.y * 320] = penc;
    for(int n=-1;n&lt;=1;n++) {
      for(int m=-1;m&lt;=1;m++) {
        int t = (p.x+n) + (p.y+m) * 320;
        if(t&gt;=0 &amp;&amp; t&lt;320*240) {
          pixels[t] = penc;
        }
      }
    }
    repaint(p.x-2, p.y-2, 4, 4);
    xStart += xIncrement;
    yStart += yIncrement;
  }
  startPoint = pt;
}
@Override public void mousePressed(MouseEvent e) {
  startPoint = e.getPoint();
  penc = (e.getButton()==MouseEvent.BUTTON1)?0xff000000:0x0;
}
</code></pre>

### 解説
上記のサンプルでは、左クリックでドラッグすると黒で、右クリックでドラッグすると透過色(`0xff000000`、消しゴム)で、自由曲線を描画することができます。
`MemoryImageSource`に設定した画像の各ピクセルを表す`int`配列を、マウスのドラッグに応じて操作して`Image`を作成しています。

- - - -
以下のような方法もあります。
<pre class="prettyprint"><code>private static final Color ERASER = new Color(0,0,0,0);
private boolean isPen = true;
private Point startPoint = new Point(-10,-10);
private BufferedImage currentImage = null;
private BufferedImage backImage = null;
@Override public void paintComponent(Graphics g) {
  super.paintComponent(g);
  if(backImage!=null) {
    g.drawImage(backImage, 0, 0, this);
  }
  if(currentImage!=null) {
    g.drawImage(currentImage, 0, 0, this);
  }
}
@Override public void mouseDragged(MouseEvent e) {
  Point pt = e.getPoint();
  Graphics2D g2d = currentImage.createGraphics();
  g2d.setStroke(new BasicStroke(3.0F));
  if(isPen) {
    g2d.setPaint(Color.BLACK);
  }else{
    g2d.setComposite(AlphaComposite.Clear);
    g2d.setPaint(ERASER);
  }
  g2d.drawLine(startPoint.x, startPoint.y, pt.x, pt.y);
  g2d.dispose();
  startPoint = pt;
  repaint();
}
@Override public void mousePressed(MouseEvent e) {
  startPoint = e.getPoint();
  isPen = e.getButton()==MouseEvent.BUTTON1;
}
</code></pre>

### 参考リンク
- [JPanelにマウスで自由曲線を描画](http://terai.xrea.jp/Swing/PaintPanel.html)
- [PixelGrabberで画像を配列として取得し編集、書出し](http://terai.xrea.jp/Swing/PixelGrabber.html)

<!-- dummy comment line for breaking list -->

### コメント