---
layout: post
title: Cursorオブジェクトの生成
category: swing
folder: CustomCursor
tags: [Cursor, BufferedImage, ImageIcon]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-01-24

## Cursorオブジェクトの生成
新しいカスタムカーソルオブジェクトを作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTKTOEY7FI/AAAAAAAAAVw/OeBJRlIWHsQ/s800/CustomCursor.png)

### サンプルコード
<pre class="prettyprint"><code>BufferedImage bi2 = new BufferedImage(
                      32, 32, BufferedImage.TYPE_INT_ARGB);
Graphics2D g2d2 = bi2.createGraphics();
g2d2.setPaint(Color.RED);
g2d2.drawOval(8, 8, 16, 16);
g2d2.dispose();
lbl2.setCursor(getToolkit().createCustomCursor(
                               bi2,new Point(16,16),"oval"));
label2.setIcon(new ImageIcon(bi2));
</code></pre>

### 解説
`Toolkit#createCustomCursor`メソッドでカーソルオブジェクトを作成します。上記のサンプルコードでは、`32*32`のバッファの中心に、直径`16`の円をかき、この円の中心がホットスポットとなるようなカーソルを作っています。

### コメント
