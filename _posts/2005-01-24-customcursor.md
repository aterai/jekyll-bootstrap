---
layout: post
category: swing
folder: CustomCursor
title: Cursorオブジェクトの生成
tags: [Cursor, BufferedImage, ImageIcon, JComponent]
author: aterai
pubdate: 2005-01-24T03:58:31+09:00
description: BufferedImageからカーソルオブジェクトを作成し、これをコンポーネントに設定します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTKTOEY7FI/AAAAAAAAAVw/OeBJRlIWHsQ/s800/CustomCursor.png
comments: true
---
## 概要
`BufferedImage`からカーソルオブジェクトを作成し、これをコンポーネントに設定します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTKTOEY7FI/AAAAAAAAAVw/OeBJRlIWHsQ/s800/CustomCursor.png %}

## サンプルコード
<pre class="prettyprint"><code>BufferedImage bi = new BufferedImage(32, 32, BufferedImage.TYPE_INT_ARGB);
Graphics2D g2 = bi.createGraphics();
g2.setPaint(Color.RED);
g2.drawOval(8, 8, 16, 16);
g2.dispose();
button.setCursor(getToolkit().createCustomCursor(bi,　new Point(16,　16),　"oval"));
</code></pre>

## 解説
上記のサンプルでは、サイズが`32x32`の`BufferedImage`から`Toolkit#createCustomCursor(...)`メソッドを使用してホットスポットはその`BufferedImage`の中心に設定したカーソルオブジェクトを作成しています。

- `String`: `BufferedImage`に文字を描画
- `drawOval`: `BufferedImage`に円を描画
- `paintIcon`: `BufferedImage`に`Icon`を描画

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Toolkit#createCustomCursor(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Toolkit.html#createCustomCursor-java.awt.Image-java.awt.Point-java.lang.String-)

<!-- dummy comment line for breaking list -->

## コメント
