---
layout: post
category: swing
folder: WindowShape
title: Windowの形を変更
tags: [JFrame, Shape, TextLayout]
author: aterai
pubdate: 2011-12-19T19:46:54+09:00
description: Windowの形を非矩形図形に変更します。
comments: true
---
## 概要
`Window`の形を非矩形図形に変更します。

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
//label.setText(str);
TextLayout tl = new TextLayout(str, font, frc);
Rectangle2D b = tl.getBounds();
Shape shape = tl.getOutline(AffineTransform.getTranslateInstance(-b.getX(),-b.getY()));

frame.setBounds(shape.getBounds());
//frame.setSize(shape.getBounds().width, shape.getBounds().height);
com.sun.awt.AWTUtilities.setWindowShape(frame, shape);
//frame.setShape(shape); // 1.7.0
frame.setLocationRelativeTo(parent);
frame.setVisible(true);
</code></pre>

## 解説
上記のサンプルでは、`com.sun.awt.AWTUtilities.setWindowShape(...)`メソッドを使用して、`JFrame`の形を変更しています。

- `Java 1.7.0`の場合は、`Window#setShape(Shape)`を使用

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Translucent and Shaped Windows in JDK7 (The Java Tutorials' Weblog)](http://blogs.oracle.com/thejavatutorials/entry/translucent_and_shaped_windows_in)

<!-- dummy comment line for breaking list -->

## コメント
