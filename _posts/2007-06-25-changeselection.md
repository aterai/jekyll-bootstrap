---
layout: post
title: JTableの選択状態を変更
category: swing
folder: ChangeSelection
tags: [JTable]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-06-25

## JTableの選択状態を変更
`JTable`の選択状態を`changeSelection`メソッドを使って変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTI0VFZw9I/AAAAAAAAATY/1C_mVqWcXPc/s800/ChangeSelection.png)

### サンプルコード
<pre class="prettyprint"><code>box.add(new JButton(new AbstractAction("changeSelection") {
  @Override public void actionPerformed(ActionEvent e) {
    int row = -1, col = -1;
    try{
      row = Integer.parseInt(rowField.getText().trim());
      col = Integer.parseInt(colField.getText().trim());
    }catch(Exception ex) {
      ex.printStackTrace();
    }
    table.changeSelection(row, col, toggle.isSelected(), extend.isSelected());
    //table.changeSelection(row, table.convertColumnIndexToModel(col),
    //                      toggle.isSelected(), extend.isSelected());
    table.requestFocusInWindow();
    table.repaint();
  }
}));
</code></pre>

### 解説
`JTable#changeSelection`は、`toggle`と`extend`の`2`つのフラグで、セルの選択状態を以下のようにいろいろ変更することができます([JTable#changeSelection(int, int, boolean, boolean)](http://docs.oracle.com/javase/jp/6/api/javax/swing/JTable.html#changeSelection%28int,%20int,%20boolean,%20boolean%29) より引用)。

- `toggle`:`false`、`extend`:`false`
    - 既存の選択をクリアし、新しいセルが確実に選択されるようにする。
- `toggle`:`false`、`extend`:`true`
    - 既存の選択をアンカーから指定のセルまで拡張して、ほかのすべての選択をクリアする。
- `toggle`:`true`、`extend`:`false`
    - 指定されたセルが選択されている場合、そのセルを選択解除する。選択されていない場合、そのセルを選択する。
- `toggle`:`true`、`extend`:`true`
    - アンカーの選択状態を、そのアンカーと指定されたセル間のすべてのセルに適用する。

<!-- dummy comment line for breaking list -->

上記のサンプルは、`toggle`、`extend`の状態を変えて、実際に選択状態の変化をテストすることができます。アンカーや選択状態、列の入れ替えなどを行って`changeSelection`による変更の確認をしてみてください。

### コメント