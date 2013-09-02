---
layout: post
title: JTableで行を選択
category: swing
folder: RowSelection
tags: [JTable, ListSelectionListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-05-24

## JTableで行を選択
`JTable`で、行を選択した場合の動作をテストします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTSWRoWNRI/AAAAAAAAAio/X-jqAVKs3Bw/s800/RowSelection.png)

### サンプルコード
<pre class="prettyprint"><code>table = new JTable(model);
table.setAutoCreateRowSorter(true);
table.getSelectionModel().addListSelectionListener(new ListSelectionListener() {
  @Override public void valueChanged(ListSelectionEvent e) {
    if(e.getValueIsAdjusting()) return;
    int sc = table.getSelectedRowCount();
    changeInfoPanel((sc==1)?getInfo():" ");
  }
});
//...
private String getInfo() {
  int index = table.convertRowIndexToModel(table.getSelectedRow());
  String name = (String)model.getValueAt(index, 1);
  String comment = (String)model.getValueAt(index, 2);
  return name+"( "+comment+" )";
}
</code></pre>

### 解説
マウス、カーソルキー、<kbd>Tab</kbd>キーでの選択状態の変更に対応するために、`JTable`に`MouseListener`リスナーを設定するのではなく、`JTable#getSelectionModel`メソッドで`ListSelectionModel`を参照し、このモデルに`ListSelectionListener`リスナーを追加して利用します。

`ListSelectionEvent#getValueIsAdjusting()`メソッドでイベントが重複処理を起こさないように制御しています。

### コメント
- ありがとう。助かります。 -- [ごん](http://terai.xrea.jp/ごん.html) 2009-10-16 (金) 19:37:37
    - どうもです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-10-17 (土) 00:09:01
- どうもです。  -- [ごん?](http://terai.xrea.jp/ごん?.html) 2011-08-02 (火) 15:31:26

<!-- dummy comment line for breaking list -->

