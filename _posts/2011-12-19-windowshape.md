---
layout: post
category: swing
folder: WindowShape
title: Windowの形を変更
tags: [JFrame, Shape, TextLayout]
author: aterai
pubdate: 2011-12-19T19:46:54+09:00
description: JFrameのタイトルバーなどを非表示にし、Windowの形を非矩形図形に変更します。
image: https://lh4.googleusercontent.com/-f54GogC4jCU/Tu7AbPCJhsI/AAAAAAAABGc/EzG0Tf9ITFI/s800/WindowShape.png
comments: true
---
## 概要
`JFrame`のタイトルバーなどを非表示にし、`Window`の形を非矩形図形に変更します。

{% download https://lh4.googleusercontent.com/-f54GogC4jCU/Tu7AbPCJhsI/AAAAAAAABGc/EzG0Tf9ITFI/s800/WindowShape.png %}

## サンプルコード
<pre class="prettyprint"><code>JFrame frame = new JFrame();
frame.setUndecorated(true);
frame.setAlwaysOnTop(true);
frame.setDefaultCloseOperation(WindowConstants.HIDE_ON_CLOSE);
frame.getContentPane().add(label);
frame.getContentPane().setBackground(Color.GREEN);
frame.pack();

String str = textField.getText().trim();
TextLayout tl = new TextLayout(str, font, frc);
Rectangle2D b = tl.getBounds();
Shape shape = tl.getOutline(AffineTransform.getTranslateInstance(-b.getX(), -b.getY()));

frame.setBounds(shape.getBounds());
// JDK 1.6.0: com.sun.awt.AWTUtilities.setWindowShape(frame, shape);
frame.setShape(shape);
frame.setLocationRelativeTo(parent);
frame.setVisible(true);
</code></pre>

## 解説
上記のサンプルでは、`JDK 1.7.0`で導入された`Window#setShape(Shape)`メソッドを使用して`JFrame`の形を変更しています。

- `JDK 1.6.0_10`の場合は、`com.sun.awt.AWTUtilities.setWindowShape(...)`を使用する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Translucent and Shaped Windows in JDK7 (The Java Tutorials' Weblog)](https://blogs.oracle.com/thejavatutorials/entry/translucent_and_shaped_windows_in)
- [Window#setShape(Shape) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Window.html#setShape-java.awt.Shape-)

<!-- dummy comment line for breaking list -->

## コメント
