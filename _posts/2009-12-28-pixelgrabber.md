---
layout: post
category: swing
folder: PixelGrabber
title: PixelGrabberで画像を配列として取得し編集、書出し
tags: [PixelGrabber, MemoryImageSource, BufferedImage, Graphics2D]
author: aterai
pubdate: 2009-12-28T11:50:47+09:00
description: 画像の配列を取り出すPixelGrabberを生成して、角を透過色で塗りつぶします。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTRBSkghZI/AAAAAAAAAgg/Ce52fcu-nQI/s800/PixelGrabber.png
comments: true
---
## 概要
画像の配列を取り出す`PixelGrabber`を生成して、角を透過色で塗りつぶします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTRBSkghZI/AAAAAAAAAgg/Ce52fcu-nQI/s800/PixelGrabber.png %}

## サンプルコード
<pre class="prettyprint"><code>int[] pix  = new int[height * width];
PixelGrabber pg = new PixelGrabber(image, 0, 0, width, height, pix, 0, width);
try {
  pg.grabPixels();
} catch (InterruptedException ex) {
  ex.printStackTrace();
}
Area area = makeNorthWestConer();
Rectangle r = area.getBounds();

Shape s = area; //NW
for (int y = 0; y &lt; r.height; y++) {
  for (int x = 0; x &lt; r.width; x++) {
    if (s.contains(x, y)) {
      pix[x + y * width] = 0x0;
    }
  }
}
AffineTransform at = AffineTransform.getScaleInstance(-1d, 1d);
at.translate(-width, 0);
s = at.createTransformedShape(area); //NE
for (int y = 0; y &lt; r.height; y++) {
  for (int x = width - r.width; x &lt; width; x++) {
    if (s.contains(x, y)) {
      pix[x + y * width] = 0x0;
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、ウィンドウのスクリーンショット画像から、`PixelGrabber`で`int`配列を生成し、左上、右上の角を`Windows XP`風に透過色で上書きしています。

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
//} catch (IOException ioe) {
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
g2d.setPaint(new Color(0x0, true));
//NW
g2d.drawLine(0, 0, 4, 0);
g2d.drawLine(0, 1, 2, 1);
g2d.drawLine(0, 2, 1, 2);
g2d.drawLine(0, 3, 0, 4);
//NE
g2d.drawLine(w - 5, 0, w - 1, 0);
g2d.drawLine(w - 3, 1, w - 1, 1);
g2d.drawLine(w - 2, 2, w - 1, 2);
g2d.drawLine(w - 1, 3, w - 1, 4);
g2d.dispose();
</code></pre>

## 参考リンク
[PixelGrabber (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/image/PixelGrabber.html)

## コメント
