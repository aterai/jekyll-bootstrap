---
layout: post
category: swing
folder: GridBagLayout
title: GridBagLayoutの使用
tags: [GridBagLayout, LayoutManager]
author: aterai
pubdate: 2003-09-15
description: GridBagLayoutを使用して、左右の部品のサイズを固定、中央だけは水平方向に伸縮可になるよう配置します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTNi4XckaI/AAAAAAAAAa8/8VJwvf6EScw/s800/GridBagLayout.png
comments: true
---
## 概要
`GridBagLayout`を使用して、左右の部品のサイズを固定、中央だけは水平方向に伸縮可になるよう配置します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTNi4XckaI/AAAAAAAAAa8/8VJwvf6EScw/s800/GridBagLayout.png %}

## サンプルコード
<pre class="prettyprint"><code>public JPanel createPanel(JComponent cmp, JButton btn, String str) {
  GridBagConstraints c = new GridBagConstraints();
  JPanel panel = new JPanel(new GridBagLayout());

  c.gridheight = 1;
  c.gridwidth  = 1;
  c.gridy = 0;

  c.gridx = 0;
  c.weightx = 0.0;
  c.insets = new Insets(5, 5, 5, 0);
  c.anchor = GridBagConstraints.WEST;
  panel.add(new JLabel(str), c);

  c.gridx = 1;
  c.weightx = 1.0;
  // c.insets = new Insets(5, 5, 5, 0);
  c.fill = GridBagConstraints.HORIZONTAL;
  panel.add(cmp, c);

  c.gridx = 2;
  c.weightx = 0.0;
  c.insets = new Insets(5, 5, 5, 5);
  c.anchor = GridBagConstraints.WEST;
  panel.add(btn, c);

  return panel;
}
</code></pre>

## 解説
上記のサンプルでは、`GridBagLayout`で`BorderLayout`のような配置を行っています。`GridBagLayout`の場合、各コンポーネント自身が推奨する高さが生かされるように設定します。

- `BorderLayout`
    - それぞれデフォルトの高さ(推奨サイズ)が異なるコンポーネントを`BorderLayout`を使用して、`WEST`、`CENTER`、`EAST`に配置すると一番高いコンポーネントまで拡大
    - `CENTER`の`JComboBox`が`EAST`の`JButton`の高さになっている(以下のスクリーンショット参照)
    - `MotifLookAndFeel`の場合

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTNldPsABI/AAAAAAAAAbA/eep6P-D2eC8/s800/GridBagLayout1.png)

- `GridBagLayout`
    - 左右のコンポーネントのサイズは`BorderLayout`のように固定して、中央のコンポーネントだけを水平方向にのみ伸縮
    - `weightx`を指定することで、余分のスペースを各列のウェイトに比例して分配
    - ウェイトが`0`の場合、余分のスペースはその列に分配されない
    - 左右の列の`weightx`が`0.0`なので、中央の列の`weightx`は`0.001`でも`100.0`でも水平方向の余分なスペースすべてが配分されている
    - 垂直方向のスペースは指定していないためデフォルト値の`weighty=0.0`となり、フレームのサイズを変更しても垂直方向に関しては常にコンポーネントの推奨サイズで固定

<!-- dummy comment line for breaking list -->

`IDE`などのサポート無しではすこし面倒な`GridBagLayout`ですが、~~[GridBagの使い方１](http://homepage1.nifty.com/masada/cyber/javagridbag1.htm)~~の「紙などにマス目で下書きをしてからコンポーネントのレイアウトを設計する」方法を使えば、凝ったレイアウトでも理解しやすくすっきり設計できます。

## 参考リンク
- [GridBagLayout (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/GridBagLayout.html)
- ~~[GridBagの使い方１](http://homepage1.nifty.com/masada/cyber/javagridbag1.htm)~~
- [GridBagLayoutでコンポーネントがつぶれるのを防ぎたいとき～](http://satoshi.kinokuni.org/tech/SwingTipsLayout.html#section1)
- [GroupLayoutの使用](https://ateraimemo.com/Swing/GroupLayout.html)

<!-- dummy comment line for breaking list -->

## コメント
