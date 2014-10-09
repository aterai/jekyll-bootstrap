---
layout: post
category: swing
folder: AlwaysOnTop
title: JFrameを常に前面に表示する
tags: [JFrame, Window, Toolkit]
author: aterai
pubdate: 2007-12-17T14:31:41+09:00
description: JFrameなどを常に前面に表示します。
comments: true
---
## 概要
`JFrame`などを常に前面に表示します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTHh-ILwOI/AAAAAAAAARU/SYnOw7As81Y/s800/AlwaysOnTop.png %}

## サンプルコード
<pre class="prettyprint"><code>frame.setAlwaysOnTop(true);
</code></pre>

## 解説
`JDK 1.5.0`で導入された、`Window#setAlwaysOnTop(boolean)`メソッドを使って、フレームを常に最前面に表示します。

プラットフォームで、最前面がサポートされていない場合は、何も起こらないようです。サポートされているかどうかは、`JDK 1.6.0`で導入された、`Window#isAlwaysOnTopSupported()`か、`Toolkit.isAlwaysOnTopSupported()`で調べることができます。

## 参考リンク
- [Window.html#setAlwaysOnTop(boolean)](http://docs.oracle.com/javase/jp/6/api/java/awt/Window.html#setAlwaysOnTop%28boolean%29)

<!-- dummy comment line for breaking list -->

## コメント
