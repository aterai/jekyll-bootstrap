---
layout: post
category: swing
folder: ComparisonDifferenceImages
title: WritableRasterからDataBufferを取得して画像の比較
tags: [BufferedImage, WritableRaster, DataBuffer]
author: aterai
pubdate: 2014-11-24T00:02:03+09:00
description: 2つの画像からそれぞれピクセル配列を取得して比較を行い、完全に一致するピクセルのアルファ値を下げることで違いを強調表示します。
image: https://lh3.googleusercontent.com/-wz-vsrJ2L3Y/VHHvorDnjaI/AAAAAAAANp0/i3riWECvTsA/s800/ComparisonDifferenceImages.png
comments: true
---
## 概要
`2`つの画像からそれぞれピクセル配列を取得して比較を行い、完全に一致するピクセルのアルファ値を下げることで違いを強調表示します。

{% download https://lh3.googleusercontent.com/-wz-vsrJ2L3Y/VHHvorDnjaI/AAAAAAAANp0/i3riWECvTsA/s800/ComparisonDifferenceImages.png %}

## サンプルコード
<pre class="prettyprint"><code>int w = iia.getIconWidth();
int h = iia.getIconHeight();
int[] pixelsA = getData(iia, w, h);
int[] pixelsB = getData(iib, w, h);
source = new MemoryImageSource(w, h, pixelsA, 0, w);
for (int i = 0; i &lt; pixelsA.length; i++) {
  if (pixelsA[i] == pixelsB[i]) {
    pixelsA[i] = pixelsA[i] &amp; 0x44_FF_FF_FF;
  }
}
//...
private static int[] getData(ImageIcon imageIcon, int w, int h) {
  Image img = imageIcon.getImage();
  BufferedImage image = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
  Graphics g = image.createGraphics();
  g.drawImage(img, 0, 0, null);
  g.dispose();
  return ((DataBufferInt) (image.getRaster().getDataBuffer())).getData();
}
</code></pre>

## 解説
上記のサンプルでは、以下の手順で同サイズの画像から、それぞれのピクセル配列を取得して比較を行っています。

1. `ImageIcon`から`Image`を取得
1. `BufferedImage.TYPE_INT_RGB`で作成した`BufferedImage`に`Image`をコピー
1. `BufferedImage`から、`WritableRaster`を取得
1. `WritableRaster`から`DataBuffer`を取得
1. `DataBuffer`を`DataBufferInt`にキャストして、`DataBufferInt#getData()`で`int`のピクセル配列を取得

比較結果は、 `MemoryImageSource`に格納し、`Component#createImage(ImageProducer)`で`Image`に変換しています。

- `ImageIO.read(...)`で取得した`BufferedImage`から、`getRaster().getDataBuffer()`で`DataBuffer`を取り出すと、`DataBufferByte`になる？

<!-- dummy comment line for breaking list -->

## 参考リンク
- [MemoryImageSourceで配列から画像を生成](https://ateraimemo.com/Swing/MemoryImageSource.html)
- [PixelGrabberで画像を配列として取得し編集、書出し](https://ateraimemo.com/Swing/PixelGrabber.html)
- [MemoryImageSource (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/image/MemoryImageSource.html)

<!-- dummy comment line for breaking list -->

## コメント
