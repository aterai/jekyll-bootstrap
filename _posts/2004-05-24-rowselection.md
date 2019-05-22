---
layout: post
category: swing
folder: RowSelection
title: JTableで行を選択
tags: [JTable, ListSelectionListener]
author: aterai
pubdate: 2004-05-24T05:21:46+09:00
description: JTableで、行を選択した場合の動作をテストします。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTSWRoWNRI/AAAAAAAAAio/X-jqAVKs3Bw/s800/RowSelection.png
comments: true
---
## 概要
`JTable`で、行を選択した場合の動作をテストします。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTSWRoWNRI/AAAAAAAAAio/X-jqAVKs3Bw/s800/RowSelection.png %}

## サンプルコード
<pre class="prettyprint"><code>table = new JTable(model);
table.setAutoCreateRowSorter(true);
table.getSelectionModel().addListSelectionListener(new ListSelectionListener() {
  @Override public void valueChanged(ListSelectionEvent e) {
    if (e.getValueIsAdjusting()) {
      return;
    }
    int sc = table.getSelectedRowCount();
    changeInfoPanel((sc == 1) ? getInfo() : " ");
  }
});
// ...
private String getInfo() {
  int index = table.convertRowIndexToModel(table.getSelectedRow());
  String str = (String) model.getValueAt(index, 0);
  Integer idx = (Integer) model.getValueAt(index, 1);
  Boolean flg = (Boolean) model.getValueAt(index, 2);
  return String.format("%s, %d, %s", str, idx, flg);
}
</code></pre>

## 解説
上記のサンプルでは、マウス、カーソルキー、<kbd>Tab</kbd>キーでの選択状態の変更に対応するため、`JTable`に`MouseListener`リスナーを設定するのではなく`JTable#getSelectionModel`メソッドで`ListSelectionModel`を参照し、このモデルに`ListSelectionListener`リスナーを追加しています。

`ListSelectionEvent#getValueIsAdjusting()`メソッドでイベントが重複処理を起こさないように制御しています。

## 参考リンク
- [JTable#getSelectionModel() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#getSelectionModel--)

<!-- dummy comment line for breaking list -->

## コメント
- ありがとう。助かります。 -- *ごん* 2009-10-16 (金) 19:37:37
    - どうもです。 -- *aterai* 2009-10-17 (土) 00:09:01
- どうもです。  -- *ごん?* 2011-08-02 (火) 15:31:26

<!-- dummy comment line for breaking list -->
