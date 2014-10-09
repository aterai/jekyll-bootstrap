---
layout: post
category: swing
folder: MoveNonRectangularImage
title: JComponentの形状を変更する
tags: [JComponent, JLabel, BufferedImage, DragAndDrop]
author: aterai
pubdate: 2008-11-17T16:07:53+09:00
description: コンポーネントの形状を画像の不透明領域に合わせて変更します。
comments: true
---
## 概要
コンポーネントの形状を画像の不透明領域に合わせて変更します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTQKdiDk4I/AAAAAAAAAfI/tb322r8ngL0/s800/MoveNonRectangularImage.png %}

## サンプルコード
<pre class="prettyprint"><code>JLabel label = new JLabel(dukeIcon) {
  @Override public boolean contains(int x, int y) {
    return super.contains(x, y) &amp;&amp; ((image.getRGB(x, y) &gt;&gt; 24) &amp; 0xff) &gt; 0;
  }
};
</code></pre>

## 解説
- `JLabel#contains(int, int)`メソッドをオーバーライドし、与えられた座標が画像の透明部分に当たる場合は、`false`を返すように設定
- 画像の透明部分は`JLabel`に含まれないことになり、`JLabel`に設定した`MouseListener`などに反応しない
- 非矩形画像の不透明部分だけマウスでドラッグ可能になる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Duke Images: iconSized](http://duke.kenai.com/iconSized/index.html)
- [JButtonの形を変更](http://terai.xrea.jp/Swing/RoundButton.html)
- [ImageIconの形でJButtonを作成](http://terai.xrea.jp/Swing/RoundImageButton.html)

<!-- dummy comment line for breaking list -->

## コメント
