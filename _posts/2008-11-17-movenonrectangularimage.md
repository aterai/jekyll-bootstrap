---
layout: post
category: swing
folder: MoveNonRectangularImage
title: JComponentの形状を変更する
tags: [JComponent, JLabel, BufferedImage, DragAndDrop]
author: aterai
pubdate: 2008-11-17T16:07:53+09:00
description: マウスカーソルに反応するコンポーネントの領域をJLabelに設定した画像アイコンの不透明領域に合わせて変更します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTQKdiDk4I/AAAAAAAAAfI/tb322r8ngL0/s800/MoveNonRectangularImage.png
comments: true
---
## 概要
マウスカーソルに反応するコンポーネントの領域を`JLabel`に設定した画像アイコンの不透明領域に合わせて変更します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTQKdiDk4I/AAAAAAAAAfI/tb322r8ngL0/s800/MoveNonRectangularImage.png %}

## サンプルコード
<pre class="prettyprint"><code>private JLabel makeLabelIcon(BufferedImage image) {
  JLabel label = new JLabel(new ImageIcon(image)) {
    @Override public boolean contains(int x, int y) {
      return super.contains(x, y) &amp;&amp; ((image.getRGB(x, y) &gt;&gt; 24) &amp; 0xff) &gt; 0;
    }
  };
  //...
</code></pre>

## 解説
- `JLabel#contains(int, int)`メソッドをオーバーライドし、与えられた座標にある画像の色成分が透明である場合は、`false`を返すように設定
- 画像の透明部分は`JLabel`に含まれないことになり、`JLabel`に設定した`MouseListener`などに反応しない
- 非矩形画像の不透明部分だけがマウスでドラッグ可能になる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Duke Images: iconSized](http://duke.kenai.com/iconSized/index.html)
- [JButtonの形を変更](http://ateraimemo.com/Swing/RoundButton.html)
- [ImageIconの形でJButtonを作成](http://ateraimemo.com/Swing/RoundImageButton.html)

<!-- dummy comment line for breaking list -->

## コメント
