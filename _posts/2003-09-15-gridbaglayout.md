---
layout: post
title: GridBagLayoutの使用
category: swing
folder: GridBagLayout
tags: [GridBagLayout, LayoutManager]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2003-09-15

## GridBagLayoutの使用
`GridBagLayout`を使用して、左右の部品のサイズを固定、中央だけは水平方向に伸縮可になるよう配置します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTNi4XckaI/AAAAAAAAAa8/8VJwvf6EScw/s800/GridBagLayout.png)

### サンプルコード
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
  //c.insets = new Insets(5, 5, 5, 0);
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

### 解説
上記のサンプルでは、`GridBagLayout`で`BorderLayout`のような配置を行っています。ただし、`GridBagLayout`の場合は、各コンポーネントが推奨する高さが生かされるように設定しています。

- `BorderLayout`
    - それぞれデフォルトの高さが違うコンポーネントを、`BorderLayout`を使って、`WEST`、`CENTER`、`EAST`に配置すると、一番高いコンポーネントに揃えられる。
    - `CENTER`の`JComboBox`が、`EAST`の`JButton`の高さになっている(スクリーンショット参照)。
    - `MotifLookAndFeel`の場合

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTNldPsABI/AAAAAAAAAbA/eep6P-D2eC8/s800/GridBagLayout1.png)

- `GridBagLayout`
    - 左右のコンポーネントのサイズは`BorderLayout`のように固定して、中央のコンポーネントだけを水平方向にのみ伸縮させる。
    - `weightx`を指定することで、余分のスペースを各列のウェイトに比例して分配している。
    - ウェイトが`0`の場合、余分のスペースはその列に分配されない。
    - 左右の列の`weightx`が`0.0`なので、中央の列の`weightx`は、`0.001`でも`100.0`でも水平方向の余分なスペースすべてが配分されている。
    - 垂直方向のスペースは指定していないため、デフォルト値の`weighty=0.0`となり、フレームのサイズを変更しても、垂直方向に関しては常にコンポーネントの推奨サイズで固定される。

<!-- dummy comment line for breaking list -->

`IDE`などのサポート無しでは、すこし面倒な`GridBagLayout`ですが、[GridBagの使い方１](http://homepage1.nifty.com/masada/cyber/javagridbag1.htm)の「紙などにマス目で下書きをしてから、コンポーネントのレイアウトを設計する」方法を使えば、凝ったレイアウトでも理解しやすく、すっきり設計できます。

### 参考リンク
- [GridBagの使い方１](http://homepage1.nifty.com/masada/cyber/javagridbag1.htm)
- [GridBagLayoutでコンポーネントがつぶれるのを防ぎたいとき～](http://satoshi.kinokuni.org/tech/SwingTipsLayout.html#section1)
- [GroupLayoutの使用](http://terai.xrea.jp/Swing/GroupLayout.html)

<!-- dummy comment line for breaking list -->

### コメント