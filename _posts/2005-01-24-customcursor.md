---
layout: post
category: swing
folder: CustomCursor
title: Cursorオブジェクトの生成
tags: [Cursor, BufferedImage, ImageIcon]
author: aterai
pubdate: 2005-01-24
description: 新しいカスタムカーソルオブジェクトを作成します。
comments: true
---
## 概要
新しいカスタムカーソルオブジェクトを作成します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTKTOEY7FI/AAAAAAAAAVw/OeBJRlIWHsQ/s800/CustomCursor.png %}

## サンプルコード
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

## 解説
`Toolkit#createCustomCursor`メソッドでカーソルオブジェクトを作成します。上記のサンプルコードでは、`32*32`のバッファの中心に、直径`16`の円をかき、この円の中心がホットスポットとなるようなカーソルを作っています。

## コメント
