---
layout: post
title: GridBagLayoutを使ってレンガ状に配置
category: swing
folder: BrickLayout
tags: [GridBagLayout, LayoutManager]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-03-09

## GridBagLayoutを使ってレンガ状に配置
`GridBagLayout`を使ってコンポーネントをレンガ状に配置します。[Swing - GridBagLayout to create a board](https://forums.oracle.com/thread/1357310)を参考にしています。

{% download %}

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTIOzg1doI/AAAAAAAAASc/V_SwABvAldE/s800/BrickLayout.png)

### サンプルコード
<pre class="prettyprint"><code>JPanel panel = new JPanel(new GridBagLayout());
panel.setBorder(BorderFactory.createTitledBorder("Brick Layout"));
GridBagConstraints c = new GridBagConstraints();
c.fill = GridBagConstraints.HORIZONTAL;
//c.weightx = 1.0; c.weighty = 0.0;
for(int i=0;i&lt;SIZE;i++) {
  int x = i &amp; 1; //= (i%2==0)?0:1;
  for(int j=0;j&lt;SIZE;j++) {
    c.gridy = i;
    c.gridx = 2*j+x;
    c.gridwidth = 2;
    panel.add(new JButton(" "),c);
  }
}
//&lt;blockquote cite="https://forums.oracle.com/thread/1357310"&gt;
//&lt;dummy-row&gt;
c.gridwidth = 1;
c.gridy = 10;
for(c.gridx=0; c.gridx&lt;=2*SIZE; c.gridx++)
  panel.add(Box.createHorizontalStrut(24), c);
//&lt;/dummy-row&gt;
//&lt;/blockquote&gt;
</code></pre>

### 解説
上記のサンプルでは、`GridBagLayout`を使って、`JButton`をレンガ状に配置します。互い違いに二列ずつ占めるようにボタンを配置していますが、`<dummy-row>`が無い場合、うまくレンガ状にはなりません。

以下、[Swing - GridBagLayout to create a board](https://forums.oracle.com/thread/1357310)のDarryl.Burkeさんの投稿を引用

	A column (or row) in a GridBagLayout is not well defined unless there is at least one component which occupies only that column (or row). All your rows have components spanning 2 columns.

列の基準となる行は、どこでも(先頭でも最後でも)構わないようです。

### 参考リンク
- [Swing - GridBagLayout to create a board](https://forums.oracle.com/thread/1357310)

<!-- dummy comment line for breaking list -->

### コメント
