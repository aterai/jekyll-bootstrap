---
layout: post
category: swing
folder: SoftClippedWindow
title: Windowの縁をソフトクリッピングでなめらかにする
tags: [JWindow, AlphaComposite]
author: aterai
pubdate: 2019-03-04T15:46:57+09:00
description: Windowの形を図形で切り抜きした場合に生じる縁のジャギーをソフトクリッピング効果でなめらかに変更します。
image: https://drive.google.com/uc?id=1qfCcXJGR0gXwMZu9LI_5jSJ_rPNct5o4rg
comments: true
---
## 概要
`Window`の形を図形で切り抜きした場合に生じる縁のジャギーをソフトクリッピング効果でなめらかに変更します。

{% download https://drive.google.com/uc?id=1qfCcXJGR0gXwMZu9LI_5jSJ_rPNct5o4rg %}

## サンプルコード
<pre class="prettyprint"><code>int width = image.getWidth();
int height = image.getHeight();
Shape shape = new RoundRectangle2D.Float(0f, 0f, width / 2f, height / 2f, 50f, 50f);

BufferedImage clippedImage = makeClippedImage(image, shape);

JWindow window = new JWindow();
window.setBackground(new Color(0x0, true));
window.getContentPane().add(makePanel(clippedImage));
window.pack();
window.setLocationRelativeTo(((AbstractButton) e.getSource()).getRootPane());
window.setVisible(true);
// ...
private static BufferedImage makeClippedImage(BufferedImage source, Shape shape) {
  int width = source.getWidth();
  int height = source.getHeight();

  BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
  Graphics2D g2 = image.createGraphics();
  // g2.setComposite(AlphaComposite.Clear);
  // g2.fillRect(0, 0, width, height);

  g2.setComposite(AlphaComposite.Src);
  g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
  // g2.setColor(Color.WHITE);
  g2.fill(shape);

  g2.setComposite(AlphaComposite.SrcAtop);
  g2.drawImage(source, 0, 0, null);
  g2.dispose();

  return image;
}
</code></pre>

## 解説
- `clipped window`
    - [Window#setShape(Shape)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Window.html#setShape-java.awt.Shape-)メソッドで`JWindow`をラウンド矩形で切り抜き
    - 縁にジャギーが発生する
    - 参考: [Windowの形を変更](https://ateraimemo.com/Swing/WindowShape.html)
- `soft clipped window`
    - `JWindow`の背景色を完全に透明(`new Color(0x0, true)`でアルファ値が`0`)に設定
    - `Window#setShape(Shape)`メソッドは使用せず、代わりに`JWindow`の`CcontentPane`に図形(切り抜き用のラウンド矩形)と画像をソフトクリッピング効果(`AlphaComposite.SrcAtop`)でブレンド処理して描画する`JPanel`を追加
    - 参考: [campbell: Java 2D Trickery: Soft Clipping Blog | Oracle Community](https://community.oracle.com/blogs/campbell/2006/07/19/java-2d-trickery-soft-clipping)
    - 参考: [Soft clipping and per-pixel translucency for Swing windows · Pushing Pixels](https://www.pushing-pixels.org/2008/03/03/soft-clipping-and-per-pixel-translucency-for-swing-windows.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [campbell: Java 2D Trickery: Soft Clipping Blog | Oracle Community](https://community.oracle.com/blogs/campbell/2006/07/19/java-2d-trickery-soft-clipping)
    - [Java Developer Connection](http://otn.oracle.co.jp/technology/global/jp/sdn/java/private/techtips/2006/tt0923.html)
- [Soft clipping and per-pixel translucency for Swing windows · Pushing Pixels](https://www.pushing-pixels.org/2008/03/03/soft-clipping-and-per-pixel-translucency-for-swing-windows.html)
- [Windowの形を変更](https://ateraimemo.com/Swing/WindowShape.html)

<!-- dummy comment line for breaking list -->

## コメント
