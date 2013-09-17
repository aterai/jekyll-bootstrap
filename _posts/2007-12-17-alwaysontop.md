---
layout: post
title: JFrameを常に前面に表示する
category: swing
folder: AlwaysOnTop
tags: [JFrame, Window, Toolkit]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-12-17

## JFrameを常に前面に表示する
`JFrame`などを常に前面に表示します。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTHh-ILwOI/AAAAAAAAARU/SYnOw7As81Y/s800/AlwaysOnTop.png)

### サンプルコード
<pre class="prettyprint"><code>frame.setAlwaysOnTop(true);
</code></pre>

### 解説
`JDK 1.5.0`で導入された、`Window#setAlwaysOnTop(boolean)`メソッドを使って、フレームを常に最前面に表示します。

プラットフォームで、最前面がサポートされていない場合は、何も起こらないようです。サポートされているかどうかは、`JDK 1.6.0`で導入された、`Window#isAlwaysOnTopSupported()`か、`Toolkit.isAlwaysOnTopSupported()`で調べることができます。

### 参考リンク
- [Window.html#setAlwaysOnTop(boolean)](http://docs.oracle.com/javase/jp/6/api/java/awt/Window.html#setAlwaysOnTop%28boolean%29)

<!-- dummy comment line for breaking list -->

### コメント
