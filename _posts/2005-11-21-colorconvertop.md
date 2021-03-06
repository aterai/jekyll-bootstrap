---
layout: post
category: swing
folder: ColorConvertOp
title: ColorConvertOpで画像をグレースケールに変換
tags: [ColorConvertOp, BufferedImage, RGBImageFilter, ImageIcon]
author: aterai
pubdate: 2005-11-21T14:18:04+09:00
description: ColorConvertOpを使って画像をグレースケールに変換します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTJmEhFayI/AAAAAAAAAUo/x4JGGk_f08c/s800/ColorConvertOp.png
comments: true
---
## 概要
`ColorConvertOp`を使って画像をグレースケールに変換します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTJmEhFayI/AAAAAAAAAUo/x4JGGk_f08c/s800/ColorConvertOp.png %}

## サンプルコード
<pre class="prettyprint"><code>Image img = icon1.getImage();
BufferedImage source = new BufferedImage(
    img.getWidth(this), img.getHeight(this), BufferedImage.TYPE_INT_ARGB);
Graphics g = source.createGraphics();
g.drawImage(img, 0, 0, this);
g.dispose();

ColorConvertOp colorConvert = new ColorConvertOp(
    ColorSpace.getInstance(ColorSpace.CS_GRAY), null);
BufferedImage destination = colorConvert.filter(source, null);
icon2 = new ImageIcon(destination);
</code></pre>

## 解説
用意したアイコンから、`BufferedImage`を作成し、これを`ColorConvertOp#filter`メソッドを使ってグレースケールに変換しています。

上記のサンプルでは、各`JLabel`をクリックで`Icon`として表示されている元画像とグレースケール画像を切り替えています。

- - - -
以下のように`GrayFilter.createDisabledImage(...)`を使った場合よりきれいに変換できるようです。

<pre class="prettyprint"><code>icon2 = new ImageIcon(GrayFilter.createDisabledImage(img));
</code></pre>

- - - -
`GrayFilter`の代わりに、以下のような`RGBImageFilter`を継承したフィルタを使う方法もあります。

<pre class="prettyprint"><code>class MyGrayFilter extends RGBImageFilter {
  public int filterRGB(int x, int y, int argb) {
    //int a = (argb &gt;&gt; 24) &amp; 0xFF;
    int r = (argb &gt;&gt; 16) &amp; 0xFF;
    int g = (argb &gt;&gt;  8) &amp; 0xFF;
    int b = (argb      ) &amp; 0xFF;
    //http://ofo.jp/osakana/cgtips/grayscale.phtml
    int m = (2 * r + 4 * g + b) / 7; //NTSC Coefficients
    return (argb &amp; 0xFF_00_00_00) | (m &lt;&lt; 16) | (m &lt;&lt; 8) | m;
  }
}
// ...
ImageProducer ip = new FilteredImageSource(img.getSource(), new MyGrayFilter());
icon2 = new ImageIcon(Toolkit.getDefaultToolkit().createImage(ip));
</code></pre>

- - - -
`BufferedImage.TYPE_BYTE_GRAY`で、`BufferedImage`を作成して複写してもグレースケールに変換できますが、透過色を使用している場合はすこし注意が必要なようです(参考: [Swing - Color to Grayscale to Binary](https://community.oracle.com/thread/1373262))。

<pre class="prettyprint"><code>BufferedImage bi = new BufferedImage(w, h, BufferedImage.TYPE_BYTE_GRAY);
Graphics g = bi.createGraphics();
//g.setColor(Color.WHITE);
g.fillRect(0, 0, w, h); // pre-fill: alpha
g.drawImage(img, 0, 0, this);
g.dispose();
</code></pre>

## 参考リンク
- [Image Color Gray Effect : Java examples (example source code) » 2D Graphics GUI » Image](http://www.java2s.com/Code/Java/2D-Graphics-GUI/ImageColorGrayEffect.htm)
- [opus-i | シンプル素材 テンプレート 音楽素材](http://opus-i.biz/)
- [osakana.factory - グレースケールのひみつ](http://ofo.jp/osakana/cgtips/grayscale.phtml)
    - via: [プログラマメモ2: グレースケール](http://programamemo2.blogspot.com/2007/08/blog-post_21.html)
- [Swing - image manipulation](https://community.oracle.com/thread/1903279)

<!-- dummy comment line for breaking list -->

## コメント
- リンクを参考にして`RGBImageFilter`を使うサンプルを修正しました。 -- *aterai* 2007-08-21 (火) 13:06:10
- グレイスケールからグレースケールに変更。 -- *aterai* 2008-01-10 (木) 14:31:00

<!-- dummy comment line for breaking list -->
