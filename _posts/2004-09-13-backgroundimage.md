---
layout: post
category: swing
folder: BackgroundImage
title: JPanelの背景に画像を並べる
tags: [JPanel, Image]
author: aterai
pubdate: 2004-09-13T03:00:13+09:00
description: JPanelの背景に画像をタイル状に並べて表示します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTH67VnIQI/AAAAAAAAAR8/JMqkIoI8n1Y/s800/BackgroundImage.png
comments: true
---
## 概要
`JPanel`の背景に画像をタイル状に並べて表示します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTH67VnIQI/AAAAAAAAAR8/JMqkIoI8n1Y/s800/BackgroundImage.png %}

## サンプルコード
<pre class="prettyprint"><code>@Override protected void paintComponent(Graphics g) {
  Dimension d = getSize();
  int w = bgimage.getIconWidth();
  int h = bgimage.getIconHeight();
  for (int i = 0; i * w &lt; d.width; i++) {
    for (int j = 0; j * h &lt; d.height; j++) {
      g.drawImage(bgimage.getImage(), i * w, j * h, w, h, this);
    }
  }
  super.paintComponent(g);
}
</code></pre>

## 解説
上記のサンプルでは、`JPanel#setOpaque(false)`でパネルの背景を透過するよう設定し、`JPanel#paintComponent(Graphics)`メソッドをオーバーライドしてこの内部で`Image`を順番に並べて描画しています。

## 参考リンク
- [TexturePaintを使って背景に画像を表示](https://ateraimemo.com/Swing/TexturePaint.html)
    - 同様に画像から`TexturePaint`を作成してタイル状に並べて表示
- [JTextAreaの背景に画像を表示](https://ateraimemo.com/Swing/CentredBackgroundBorder.html)
    - ひとつの画像をパネル中央に表示

<!-- dummy comment line for breaking list -->

## コメント
