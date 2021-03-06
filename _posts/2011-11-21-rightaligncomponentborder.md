---
layout: post
category: swing
folder: RightAlignComponentBorder
title: Borderの右下にJComponentを配置
tags: [Border, SpringLayout, JLayeredPane, JComponent]
author: aterai
pubdate: 2011-11-21T15:47:08+09:00
description: SpringLayoutを設定したJLayeredPaneを使って、Borderの右下にJComponentを配置します。
image: https://lh5.googleusercontent.com/-IPUQvbcJ2NM/TsjbIEMsMeI/AAAAAAAABE8/Fg16E6wkLtY/s800/RightAlignComponentBorder.png
comments: true
---
## 概要
`SpringLayout`を設定した`JLayeredPane`を使って、`Border`の右下に`JComponent`を配置します。

{% download https://lh5.googleusercontent.com/-IPUQvbcJ2NM/TsjbIEMsMeI/AAAAAAAABE8/Fg16E6wkLtY/s800/RightAlignComponentBorder.png %}

## サンプルコード
<pre class="prettyprint"><code>public JComponent makePanel(JComponent m, JComponent c) {
  int ir = 20; // inset.right
  int ch = c.getPreferredSize().height / 2;
  Border ib = BorderFactory.createEmptyBorder(0, 0, ch, 0);
  Border eb = BorderFactory.createEtchedBorder();
  Border bo = BorderFactory.createCompoundBorder(eb, ib);
  m.setBorder(BorderFactory.createCompoundBorder(ib, bo));

  SpringLayout layout = new SpringLayout();
  JLayeredPane p = new JLayeredPane();
  p.setLayout(layout);

  Spring x = layout.getConstraint(SpringLayout.WIDTH, p);
  Spring y = layout.getConstraint(SpringLayout.HEIGHT, p);
  Spring g = Spring.minus(Spring.constant(ir));

  SpringLayout.Constraints constraints = layout.getConstraints(c);
  constraints.setConstraint(SpringLayout.EAST,  Spring.sum(x, g));
  constraints.setConstraint(SpringLayout.SOUTH, y);
  p.setLayer(c, JLayeredPane.DEFAULT_LAYER+1);
  p.add(c);

  constraints = layout.getConstraints(m);
  constraints.setConstraint(SpringLayout.WEST,  Spring.constant(0));
  constraints.setConstraint(SpringLayout.NORTH, Spring.constant(0));
  constraints.setConstraint(SpringLayout.EAST,  x);
  constraints.setConstraint(SpringLayout.SOUTH, y);
  p.setLayer(m, JLayeredPane.DEFAULT_LAYER);
  p.add(m);

  return p;
}
</code></pre>

## 解説
- 中央に表示するコンポーネントに右下に配置するコンポーネントと同じ高さの`EtchedBorder`を設定
- `SpringLayout`を設定した`JLayeredPane`の`DEFAULT_LAYER`上に中央に表示するコンポーネントを追加、また`DEFAULT_LAYER + 1`上に右下に配置するコンポーネントを追加
- `SpringLayout.Constraints`を設定して、中央に表示するコンポーネントは親の`JLayeredPane`のサイズとおなじになるようにレイアウト、また右下に配置するコンポーネントは右下になるようにレイアウト
    - 右下に配置するコンポーネントと親の`JLayeredPane`の右端同士は固定で`20px`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [BorderにJComponentを配置](https://ateraimemo.com/Swing/ComponentTitledBorder.html)
- [SpringLayoutの使用](https://ateraimemo.com/Swing/SpringLayout.html)

<!-- dummy comment line for breaking list -->

## コメント
