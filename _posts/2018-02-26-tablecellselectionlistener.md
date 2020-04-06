---
layout: post
category: swing
folder: TableCellSelectionListener
title: JTableのセル選択をテストする
tags: [JTable, ListSelectionListener]
author: aterai
pubdate: 2018-02-26T17:40:02+09:00
description: JTableの行と列のSelectionModelにListSelectionListenerを追加し、選択されたセルの情報を書き出すテストを行っています。
image: https://drive.google.com/uc?id=1d_wUBKZrFO5wKccZ3b2qiE0J8zKc-Q9QVQ
comments: true
---
## 概要
`JTable`の行と列の`SelectionModel`に`ListSelectionListener`を追加し、選択されたセルの情報を書き出すテストを行っています。

{% download https://drive.google.com/uc?id=1d_wUBKZrFO5wKccZ3b2qiE0J8zKc-Q9QVQ %}

## サンプルコード
<pre class="prettyprint"><code>JTable table1 = new JTable(model);
table1.setCellSelectionEnabled(true);
ListSelectionListener selectionListener1 = new AbstractTableCellSelectionListener() {
  @Override public void valueChanged(ListSelectionEvent e) {
    if (e.getValueIsAdjusting()) {
      return;
    }
    int sr = table1.getSelectionModel().getLeadSelectionIndex();
    int sc = table1.getColumnModel().getSelectionModel().getLeadSelectionIndex();
    if (getRowColumnAdjusting(sr, sc)) {
      return;
    }
    Object o = table1.getValueAt(sr, sc);
    textArea.append(String.format("(%d, %d) %s%n", sr, sc, o));
    textArea.setCaretPosition(textArea.getDocument().getLength());
  }
};
table1.getSelectionModel().addListSelectionListener(selectionListener1);
table1.getColumnModel().getSelectionModel().addListSelectionListener(selectionListener1);
// ...
abstract class AbstractTableCellSelectionListener implements ListSelectionListener {
  private int prevRow = -1;
  private int prevCol = -1;
  protected boolean getRowColumnAdjusting(int sr, int sc) {
    boolean flg = prevRow == sr &amp;&amp; prevCol == sc;
    prevRow = sr;
    prevCol = sc;
    return flg;
  }
}
</code></pre>

## 解説
- `JTable`
    - `JTable#getSelectionModel()`と`JTable#getColumnModel()#getSelectionModel()`で取得した行と列の`SelectionModel`に共通の`ListSelectionListener`を追加し、選択されたセルの内容と行列番号を表示
    - `JTable#getSelectedRow()`と`JTable#getSelectedColumn()`を使用しているため、<kbd>Shift</kbd>+クリックなどで範囲選択した場合アンカーインデックスが現在選択しているセルになる
        - 同一セルが選択された場合は選択セルの内容を書き出さないよう設定しているため、これらの範囲選択ではなにも書き出されない
    - <kbd>Ctrl+A</kbd>で全選択すると、常に`(0, 0)`のセル情報が書き出される(直前に選択されているのが`(0, 0)`の場合は除く)
- `SelectionModel`
    - `JTable#getSelectionModel()`と`JTable#getColumnModel()#getSelectionModel()`で取得した行と列の`SelectionModel`に共通の`ListSelectionListener`を追加し、選択されたセルの内容と行列番号を表示
    - `JTable#getSelectionModel()#getLeadSelectionIndex()`と`JTable#getColumnModel()#getSelectionModel()#getLeadSelectionIndex()`を使用しているため、<kbd>Shift</kbd>+クリックなどで範囲選択した場合リードインデックスが現在選択しているセルになる
        - 範囲選択するとマウスをリリースした位置のセル情報が書き出される
    - <kbd>Ctrl+A</kbd>で全選択してもリードインデックスは変化しないため、セル情報は書き出されない
- `Row/Column`
    - `JTable#getSelectionModel()`と`JTable#getColumnModel()#getSelectionModel()`で取得した行と列の`SelectionModel`に別々の`ListSelectionListener`を追加し、選択インデックスを表示
    - 行と列で異なる`ListSelectionListener`を追加しているため、`1`回のマウス選択などで`2`回情報が書き出される場合がある
    - 範囲選択した場合、常に`ListSelectionEvent#getFirstIndex() <= ListSelectionEvent#getLastIndex()`
        - 例えば`(2, 2)`のセルから`(0, 0)`へ範囲選択した場合、`ListSelectionEvent#getFirstIndex()`は`0`、`ListSelectionEvent#getLastIndex()`は`2`
        - アンカーインデックス、リードインデックスを取得する場合は、`ListSelectionModel#getAnchorSelectionIndex()`と`ListSelectionModel#getLeadSelectionIndex()`を使用する
- `changeSelection`
    - `JTable#changeSelection(...)`メソッドをオーバーライドして選択セル情報を書き出す
    - 範囲選択中(`ListSelectionEvent#getValueIsAdjusting()`)を除外していないため、マウスでドラッグされたセル情報などもすべて書き出される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableで行を選択](https://ateraimemo.com/Swing/RowSelection.html)
- [JTableの選択状態を変更](https://ateraimemo.com/Swing/ChangeSelection.html)
- [ListSelectionEvent#getFirstIndex() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/event/ListSelectionEvent.html#getFirstIndex--)
    - 英語版は`getFirstIndex() <= getLastIndex()`と表示されているが、日本語版は以下のように文字化けしている
    
    		&lt;code&gt;getFirstIndex()&amp;amp;lt;= getLastIndex()&lt;/code&gt;
    		getFirstIndex()&amp;lt;= getLastIndex()
    - * コメント [#comment]
    
    		#comment
    		#comment
