---
layout: post
category: swing
folder: BrickLayout
title: GridBagLayoutを使ってレンガ状に配置
tags: [GridBagLayout, LayoutManager]
author: aterai
pubdate: 2009-03-09T14:08:29+09:00
description: GridBagLayoutを使ってコンポーネントをレンガ状に配置します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTIOzg1doI/AAAAAAAAASc/V_SwABvAldE/s800/BrickLayout.png
comments: true
---
## 概要
`GridBagLayout`を使ってコンポーネントをレンガ状に配置します。[Swing - GridBagLayout to create a board](https://community.oracle.com/thread/1357310)を参考にしています。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTIOzg1doI/AAAAAAAAASc/V_SwABvAldE/s800/BrickLayout.png %}

## サンプルコード
<pre class="prettyprint"><code>JPanel panel = new JPanel(new GridBagLayout());
panel.setBorder(BorderFactory.createTitledBorder("Brick Layout"));
GridBagConstraints c = new GridBagConstraints();
c.fill = GridBagConstraints.HORIZONTAL;
c.gridy = GridBagConstraints.RELATIVE;
for (int y = 0; y &lt; YSIZE; y++) {
  ////c.gridy = GridBagConstraints.RELATIVE; //c.gridy = y;
  //int d = y &amp; 0b1; //= y % 2 == 0 ? 0 : 1; //start x offset
  //if (d == 1) {
  //  c.gridwidth = 1;
  //  c.gridx = 0;
  //  panel.add(new JButton("a"), c);
  //}
  c.gridx = y &amp; 0b1; //start x offset
  c.gridwidth = WIDTH;
  for (int x = 0; x &lt; XSIZE; x++) {
    panel.add(new JButton(" "), c);
    c.gridx += WIDTH;
  }
  //if (d == 0) {
  //  c.gridwidth = 1;
  //  panel.add(new JButton("c"), c);
  //}
}
//GridBagLayout to create a board
//https://community.oracle.com/thread/1357310
//&lt;dummy-row&gt;
c.gridwidth = 1;
//c.gridy = GridBagConstraints.REMAINDER;
for (c.gridx = 0; c.gridx &lt;= WIDTH * XSIZE; c.gridx++) {
  panel.add(Box.createHorizontalStrut(24), c);
}
//&lt;/dummy-row&gt;
</code></pre>

## 解説
上記のサンプルでは、`GridBagLayout`を使って`JButton`をレンガ状に配置します。互い違いに`2`列ずつ占めるようにボタンを配置していますが、`<dummy-row>`が無い場合、うまくレンガ状にはなりません。

以下、[Swing - GridBagLayout to create a board](https://community.oracle.com/thread/1357310)のDarryl.Burkeさんの投稿を引用

	A column (or row) in a GridBagLayout is not well defined unless there is at least one component which occupies only that column (or row). All your rows have components spanning 2 columns.

列の基準となるガイド行は、どこでも(先頭でも最後でも)構わないようです。

- - - -
- 同様に、ダミーの幅を持つガイド行を作成して`JButton`をキーボード風に配置するサンプル
    - [GridBagLayoutを使ってJButtonをキーボード状に配置する](https://ateraimemo.com/Swing/KeyboardLayout.html)に移動

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Swing - GridBagLayout to create a board](https://community.oracle.com/thread/1357310)
- [GridBagLayoutを使ってJButtonをキーボード状に配置する](https://ateraimemo.com/Swing/KeyboardLayout.html)

<!-- dummy comment line for breaking list -->

## コメント
