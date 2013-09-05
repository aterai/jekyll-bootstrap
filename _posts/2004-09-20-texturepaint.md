---
layout: post
title: TexturePaintを使って背景に画像を表示
category: swing
folder: TexturePaint
tags: [TexturePaint, BufferedImage, Graphics2D]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-09-20

## TexturePaintを使って背景に画像を表示
`TexturePaint`を使用して背景にタイル状に画像を貼り付けます。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTVUeXC5lI/AAAAAAAAAnc/CWUYfOODy1E/s800/TexturePaint.png)

### サンプルコード
<pre class="prettyprint"><code>BufferedImage bi = null;
try {
  bi = ImageIO.read(getClass().getResource("16x16.png"));
}catch(IOException ioe) {
  ioe.printStackTrace();
}
texture = new TexturePaint(img, new Rectangle(bi.getWidth(), bi.getHeight()));
panel = new JPanel() {
  @Override public void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D)g;
    g2.setPaint(texture);
    g2.fillRect(0, 0, getWidth(), getHeight());
    super.paintComponent(g);
  }
}
</code></pre>

### 解説
このサンプルでは、`BufferedImage`から`TexturePaint`を生成し、これを`Graphics2D#setPaint`メソッドで設定してパネル全体を塗りつぶしています。

### 参考リンク
- [JPanelの背景に画像を並べる](http://terai.xrea.jp/Swing/BackgroundImage.html)

<!-- dummy comment line for breaking list -->

### コメント