---
layout: post
title: GroupLayoutの使用
category: swing
folder: GroupLayout
tags: [GroupLayout, GridBagLayout, LayoutManager]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-07-30

## GroupLayoutの使用
`JDK 6`で新しく導入された`GroupLayout`と`GridBagLayout`を比較しています。`GroupLayout`のサンプルは、`API`ドキュメントの例をそのまま引用しています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTNn9AdVUI/AAAAAAAAAbE/yOFdtRVr6P4/s800/GroupLayout.png)

### サンプルコード
<pre class="prettyprint"><code>//GroupLayout
JPanel p1 = new JPanel();
p1.setBorder(BorderFactory.createTitledBorder("GroupLayout"));
GroupLayout layout = new GroupLayout(p1);
p1.setLayout(layout);
layout.setAutoCreateGaps(true);
layout.setAutoCreateContainerGaps(true);

GroupLayout.SequentialGroup hGroup = layout.createSequentialGroup();

hGroup.addGroup(layout.createParallelGroup()
    .addComponent(label1).addComponent(label2));
hGroup.addGroup(layout.createParallelGroup()
    .addComponent(tf1).addComponent(tf2));
layout.setHorizontalGroup(hGroup);

GroupLayout.SequentialGroup vGroup = layout.createSequentialGroup();
vGroup.addGroup(layout.createParallelGroup(Alignment.BASELINE)
    .addComponent(label1).addComponent(tf1));
vGroup.addGroup(layout.createParallelGroup(Alignment.BASELINE)
    .addComponent(label2).addComponent(tf2));
layout.setVerticalGroup(vGroup);
</code></pre>

<pre class="prettyprint"><code>//GridBagLayout
JPanel p2 = new JPanel(new GridBagLayout());
Border inside  = BorderFactory.createEmptyBorder(10,5+2,10,10+2);
Border outside = BorderFactory.createTitledBorder("GridBagLayout");
p2.setBorder(BorderFactory.createCompoundBorder(outside, inside));
GridBagConstraints c = new GridBagConstraints();
c.gridheight = 1;

c.gridx   = 0;
c.insets  = new Insets(5, 5, 5, 0);
c.anchor  = GridBagConstraints.WEST;
c.gridy   = 0; p2.add(label3, c); //p2.add(new JLabel("一度だけのaddで"), c);
c.gridy   = 1; p2.add(label4, c); //p2.add(new JLabel("いいのは利点かも"), c);

c.gridx   = 1;
c.weightx = 1.0;
c.fill    = GridBagConstraints.HORIZONTAL;
c.gridy   = 0; p2.add(tf3, c);
c.gridy   = 1; p2.add(tf4, c);
</code></pre>

### 解説
`GroupLayout`を手で書く場合は、少ないかもしれませんが、それでも`GridBagLayout`と同程度の記述で同じようなレイアウトも作成できるようです。また手書きでも、`GroupLayout`の場合、コンテナとコンポーネントの間に、ギャップを自動的に作成してくれる`GroupLayout#setAutoCreateContainerGaps`などが便利です。

上記のサンプルでは、`GroupLayout`、`GridBagLayout`でレイアウトしたパネルを、`GridLayout`(`BorderLayout.CENTER`と同じで、推奨サイズが無視される)で上下に並べているため、フレームを拡大すると、`GroupLayout`は上揃え、`GridBagLayout`は中央揃えになっています。

### 参考リンク
- [GroupLayout (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/GroupLayout.html)
- [GridBagLayoutの使用](http://terai.xrea.jp/Swing/GridBagLayout.html)
- [GroupLayoutの考え方２ - ばかの一つ覚え。](http://d.hatena.ne.jp/jawagenjin/20080127/1201444435)
    - `GroupLayout`のイメージが、図で分かりやすく解説されています。

<!-- dummy comment line for breaking list -->

### コメント
