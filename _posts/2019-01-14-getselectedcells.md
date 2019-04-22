---
layout: post
category: swing
folder: GetSelectedCells
title: JTableで選択されているすべてのセルを取得する
tags: [JTable, TableCellEditor, JCheckBox, JPopupMenu]
author: aterai
pubdate: 2019-01-14T09:29:04+09:00
description: JTableで選択されているすべてのセルを取得し、その値を一括で変更します。
image: https://drive.google.com/uc?export=view&id=1ggYIcKf-1ErfYHclwW_lUH1U1N0dvgye7g
comments: true
---
## 概要
`JTable`で選択されているすべてのセルを取得し、その値を一括で変更します。

{% download https://drive.google.com/uc?export=view&id=1ggYIcKf-1ErfYHclwW_lUH1U1N0dvgye7g %}

## サンプルコード
<pre class="prettyprint"><code>toggle = add("toggle");
toggle.addActionListener(e -&gt; {
  JTable table = (JTable) getInvoker();
  for (int row: table.getSelectedRows()) {
    for (int col: table.getSelectedColumns()) {
      Boolean b = (Boolean) table.getValueAt(row, col);
      table.setValueAt(!b, row, col);
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JTable#getSelectedRows()`メソッドですべての選択行インデックス、`JTable#getSelectedColumns()`メソッドですべての選択列インデックスを取得し、`2`重`for`ループで処理することで選択されたすべてのセルに対して値の変更を行っています。

- - - -
<kbd>Shift</kbd>キーを押しながらの範囲選択、<kbd>Ctrl</kbd>キーを押しながらの連続選択でセルの値が変更されないよう、以下のように`DefaultCellEditor#isCellEditable()`メソッドをオーバーライドしています。

<pre class="prettyprint"><code>@see JTable.BooleanEditor
class BooleanEditor extends DefaultCellEditor {
  protected BooleanEditor() {
    super(new JCheckBox());
    JCheckBox check = (JCheckBox) getComponent();
    check.setHorizontalAlignment(SwingConstants.CENTER);
  }

  @Override public boolean isCellEditable(EventObject e) {
    if (e instanceof MouseEvent) {
      MouseEvent me = (MouseEvent) e;
      return !(me.isShiftDown() || me.isControlDown());
    }
    return super.isCellEditable(e);
  }
  // ...
}
</code></pre>

## 参考リンク
- [JTable#getSelectedRows() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#getSelectedRows--)
- [JTable#getSelectedColumns() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#getSelectedColumns--)
- [JTableのHTML形式コピーをカスタマイズする](https://ateraimemo.com/Swing/HtmlTableTransferHandler.html)

<!-- dummy comment line for breaking list -->

## コメント
