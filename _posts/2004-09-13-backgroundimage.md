---
layout: post
title: JPanelの背景に画像を並べる
category: swing
folder: BackgroundImage
tags: [JPanel, Image]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-09-13

## JPanelの背景に画像を並べる
`JPanel`の背景に画像をタイル状に並べて表示します。

{% download %}

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTH67VnIQI/AAAAAAAAAR8/JMqkIoI8n1Y/s800/BackgroundImage.png)

### サンプルコード
<pre class="prettyprint"><code>@Override public void paintComponent(Graphics g) {
  Dimension d = getSize();
  int w = bgimage.getIconWidth();
  int h = bgimage.getIconHeight();
  for(int i=0;i*w&lt;d.width;i++) {
    for(int j=0;j*h&lt;d.height;j++) {
      g.drawImage(bgimage.getImage(), i*w, j*h, w, h, this);
    }
  }
  super.paintComponent(g);
}
</code></pre>

### 解説
上記のサンプルでは、`JPanel#setOpaque(false)`と背景を描画しないように設定したパネルで、`JPanel#paintComponent(Graphics)`メソッドをオーバーライドし、ここで`Image`を順番に並べて描画しています。

### 参考リンク
- [TexturePaintを使って背景に画像を表示](http://terai.xrea.jp/Swing/TexturePaint.html)
    - 同様に画像から`TexturePaint`を作成してタイル状に並べて表示
- [JTextAreaの背景に画像を表示](http://terai.xrea.jp/Swing/CentredBackgroundBorder.html)
    - ひとつの画像を中央に表示

<!-- dummy comment line for breaking list -->

### コメント
