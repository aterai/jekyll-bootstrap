---
layout: post
category: swing
folder: ChangeSelection
title: JTableの選択状態を変更
tags: [JTable]
author: aterai
pubdate: 2007-06-25T18:03:27+09:00
description: JTableの選択状態をchangeSelectionメソッドを使って変更します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTI0VFZw9I/AAAAAAAAATY/1C_mVqWcXPc/s800/ChangeSelection.png
comments: true
---
## 概要
`JTable`の選択状態を`changeSelection`メソッドを使って変更します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTI0VFZw9I/AAAAAAAAATY/1C_mVqWcXPc/s800/ChangeSelection.png %}

## サンプルコード
<pre class="prettyprint"><code>p.add(new JButton(new AbstractAction("changeSelection") {
  @Override public void actionPerformed(ActionEvent e) {
    int row = Integer.parseInt(rowField.getValue().toString());
    int col = Integer.parseInt(colField.getValue().toString());
    table.changeSelection(row, col, toggle.isSelected(), extend.isSelected());
    //table.changeSelection(row, table.convertColumnIndexToModel(col),
    //                      toggle.isSelected(), extend.isSelected());
    table.requestFocusInWindow();
    table.repaint();
  }
}));
</code></pre>

## 解説
`JTable#changeSelection(...)`メソッドは、`toggle`と`extend`の`2`つのフラグで、セルの選択状態を以下のように変更できます。

- `toggle`:`false`、`extend`:`false`
    - 既存の選択をクリアし、新しいセルが確実に選択されるようにする
- `toggle`:`false`、`extend`:`true`
    - 既存の選択をアンカーから指定のセルまで拡張して、ほかのすべての選択をクリアする
- `toggle`:`true`、`extend`:`false`
    - 指定されたセルが選択されている場合、そのセルを選択解除する。選択されていない場合、そのセルを選択する
- `toggle`:`true`、`extend`:`true`
    - アンカーの選択状態を、そのアンカーと指定されたセル間のすべてのセルに適用する

<!-- dummy comment line for breaking list -->

- - - -
- `toggle`、`extend`の状態を変えて、実際に選択状態の変化をテスト可能
- アンカーや選択状態、列の入れ替えなどを行って`changeSelection(...)`による変更もテスト可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTable#changeSelection(int, int, boolean, boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#changeSelection-int-int-boolean-boolean-)
    - この記事の内容は、ほぼ上記の`API`ドキュメントからの引用

<!-- dummy comment line for breaking list -->

## コメント
