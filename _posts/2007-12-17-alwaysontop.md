---
layout: post
category: swing
folder: AlwaysOnTop
title: JFrameを常に前面に表示する
tags: [JFrame, Window, Toolkit]
author: aterai
pubdate: 2007-12-17T14:31:41+09:00
description: JFrameが常に他のウィンドウよりも前面に表示されるように設定します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTHh-ILwOI/AAAAAAAAARU/SYnOw7As81Y/s800/AlwaysOnTop.png
comments: true
---
## 概要
`JFrame`が常に他のウィンドウよりも前面に表示されるように設定します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTHh-ILwOI/AAAAAAAAARU/SYnOw7As81Y/s800/AlwaysOnTop.png %}

## サンプルコード
<pre class="prettyprint"><code>frame.setAlwaysOnTop(true);
</code></pre>

## 解説
`JDK 1.5.0`で導入された`Window#setAlwaysOnTop(boolean)`メソッドを使用してフレームを常に最前面に表示します。

- プラットフォームで「常に最前面」がサポートされていない場合は`Window#setAlwaysOnTop(boolean)`メソッドを使用しても効果がない
- 「常に最前面」がサポートされているかどうかは`JDK 1.6.0`で導入された`Window#isAlwaysOnTopSupported()`、または`Toolkit.isAlwaysOnTopSupported()`メソッドで確認可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Window.html#setAlwaysOnTop(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Window.html#setAlwaysOnTop-boolean-)
- [Window#isAlwaysOnTopSupported() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Window.html#isAlwaysOnTopSupported--)

<!-- dummy comment line for breaking list -->

## コメント
