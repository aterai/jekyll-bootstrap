---
layout: post
title: PixelGrabberで画像を配列として取得し編集、書出し
category: swing
folder: PixelGrabber
tags: [PixelGrabber, MemoryImageSource, BufferedImage, Graphics2D]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-12-28

## PixelGrabberで画像を配列として取得し編集、書出し
画像の配列を取り出す`PixelGrabber`を生成して、角を透過色で塗りつぶします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTRBSkghZI/AAAAAAAAAgg/Ce52fcu-nQI/s800/PixelGrabber.png)

### サンプルコード
<pre class="prettyprint"><code>BufferedImage image;
try {
  image = javax.imageio.ImageIO.read(getClass().getResource("screenshot.png"));
}catch(java.io.IOException ioe) {
  ioe.printStackTrace();
  return;
}

int width  = image.getWidth(p);
int height = image.getHeight(p);
int[] pix  = new int[height * width];
PixelGrabber pg = new PixelGrabber(image, 0, 0, width, height, pix, 0, width);
try {
  pg.grabPixels();
} catch (Exception e) {
  e.printStackTrace();
}

//NW
for(int y=0;y&lt;5;y++) {
  for(int x=0;x&lt;5;x++) {
    if((y==0 &amp;&amp; x&lt;5) || (y==1 &amp;&amp; x&lt;3) ||
       (y==2 &amp;&amp; x&lt;2) || (y==3 &amp;&amp; x&lt;1) ||
       (y==4 &amp;&amp; x&lt;1) ) pix[y*width+x] = 0x0;
  }
}
//NE
for(int y=0;y&lt;5;y++) {
  for(int x=width-5;x&lt;width;x++) {
    if((y==0 &amp;&amp; x&gt;=width-5) || (y==1 &amp;&amp; x&gt;=width-3) ||
       (y==2 &amp;&amp; x&gt;=width-2) || (y==3 &amp;&amp; x&gt;=width-1) ||
       (y==4 &amp;&amp; x&gt;=width-1) ) pix[y*width+x] = 0x0;
  }
}
</code></pre>

### 解説
上記のサンプルでは、ウインドウのスクリーンショット画像から、`PixelGrabber`で配列を生成し、左上、右上の角を`Windows XP`風に透過色で上書きしています。

角を置き換えた配列は、以下のように`MemoryImageSource`などを使用して画像に変換しています。

<pre class="prettyprint"><code>MemoryImageSource producer = new MemoryImageSource(width, height, pix, 0, width);
Image img = p.createImage(producer);
BufferedImage bi = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
Graphics g = bi.createGraphics();
g.drawImage(img, 0, 0, null);
g.dispose();

//PNG画像ファイルとして保存
//try {
//  javax.imageio.ImageIO.write(
//    bi, "png", java.io.File.createTempFile("screenshot", ".png"));
//}catch(java.io.IOException ioe) {
//  ioe.printStackTrace();
//}
</code></pre>

- - - -
以下のように、`Graphics2D#setComposite(AlphaComposite.Clear)`として、透過色で塗りつぶす方法もあります。

<pre class="prettyprint"><code>//BufferedImage image = ...;
int w = image.getWidth(null);
int h = image.getHeight(null);

BufferedImage bi = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
Graphics2D g2d = bi.createGraphics();
g2d.drawImage(image, 0, 0, null);
g2d.setComposite(AlphaComposite.Clear);
g2d.setPaint(new Color(0,0,0,0));
//NW
g2d.drawLine(0,0,4,0);
g2d.drawLine(0,1,2,1);
g2d.drawLine(0,2,1,2);
g2d.drawLine(0,3,0,4);
//NE
g2d.drawLine(w-5,0,w-1,0);
g2d.drawLine(w-3,1,w-1,1);
g2d.drawLine(w-2,2,w-1,2);
g2d.drawLine(w-1,3,w-1,4);
g2d.dispose();
</code></pre>

### コメント
