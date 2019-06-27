---
layout: post
category: swing
folder: PositionInGridLayout
title: GridLayout内でのセル位置を取得する
tags: [GridLayout, JPanel, LayoutManager]
author: aterai
pubdate: 2019-06-17T16:13:12+09:00
description: GridLayoutを設定したJPanel内に配置したJButtonをクリックしたときそのセル位置を取得します。
image: https://drive.google.com/uc?id=1rdkSt62Po3ua2bJiL0XWH4IGa8DGjkom
comments: true
---
## 概要
`GridLayout`を設定した`JPanel`内に配置した`JButton`をクリックしたときそのセル位置を取得します。

{% download https://drive.google.com/uc?id=1rdkSt62Po3ua2bJiL0XWH4IGa8DGjkom %}

## サンプルコード
<pre class="prettyprint"><code>GridLayout gl = new GridLayout(5, 7, 5, 5);
JPanel p = new JPanel(gl);
p.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));

JTextArea log = new JTextArea(3, 0);
ActionListener al = e -&gt; {
  JComponent c = (JComponent) e.getSource();
  int idx = p.getComponentZOrder(c);
  int row = idx / gl.getColumns();
  int col = idx % gl.getColumns();
  log.append(String.format("Row: %d, Column: %d%n", row + 1, col + 1));
};
for (int i = 0; i &lt; gl.getRows() * gl.getColumns(); i++) {
  JButton b = new JButton();
  b.addActionListener(al);
  p.add(b);
}
</code></pre>

## 解説
- `Container#getComponentZOrder(Component)`で、コンテナ(`JPanel`)内のコンポーネント(`JButton`)の`Z`軸順インデックスを取得
- `GridLayout#getColumns()`でレイアウト(`GridLayout`)内の列数を取得
    - `Z`軸順インデックスを列数で割りコンポーネントの存在する行番号を取得
    - `Z`軸順インデックスを列数で剰余しコンポーネントの存在する列番号を取得
- 最初のセル(左上)は`(0, 0)`なので行列にそれぞれ`1`足してコンポーネントの存在するセル位置を`JTextArea`に表示
- コンテナの`ComponentOrientation`プロパティが水平方向に右から左(`ComponentOrientation.RIGHT_TO_LEFT`)の場合は考慮していない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [GridLayout#getRows() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/GridLayout.html#getRows--)
- [GridLayout#getColumns() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/GridLayout.html#getColumns--)

<!-- dummy comment line for breaking list -->

## コメント
