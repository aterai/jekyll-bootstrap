---
layout: post
category: swing
folder: NonEditableCellEditor
title: JTableのCellEditorを編集不可だが選択・コピーを可能に変更する
tags: [JTable, TableCellEditor, JPopupMenu]
author: aterai
pubdate: 2020-02-10T16:01:12+09:00
description: JTableのCellEditorとして編集不可・選択コピー可能なJTextFieldを設定します。
image: https://drive.google.com/uc?id=1REUOW6JqlORjh3rkRnez7K3E-HxCDL0j
comments: true
---
## 概要
`JTable`の`CellEditor`として編集不可・選択コピー可能な`JTextField`を設定します。

{% download https://drive.google.com/uc?id=1REUOW6JqlORjh3rkRnez7K3E-HxCDL0j %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model);
table.setAutoCreateRowSorter(true);
table.setFillsViewportHeight(true);
// table.setFocusable(false);
// table.setCellSelectionEnabled(false);
table.setSelectionForeground(Color.BLACK);
table.setSelectionBackground(new Color(0xEE_EE_EE));

JTextField field = new JTextField();
field.setEditable(false);
field.setBackground(table.getSelectionBackground());
field.setBorder(BorderFactory.createEmptyBorder(1, 1, 1, 1));
field.setComponentPopupMenu(new TextComponentPopupMenu());

DefaultCellEditor cellEditor = new DefaultCellEditor(field);
cellEditor.setClickCountToStart(1);
table.setDefaultEditor(Object.class, cellEditor);
</code></pre>

## 解説
- `JTable#isCellEditable(...)`などをオーバーライドして`JTable`を編集不可にするとセル内の文字列を部分選択してコピーできない
    - [JTableのセルを編集不可にする](https://ateraimemo.com/Swing/CellEditor.html)
- デフォルトの`JTable`ではセルを選択して<kbd>Ctrl-C</kbd>を入力しても列がタブ区切りでコピーされる
    - 参考: [JTableのHTML形式コピーをカスタマイズする](https://ateraimemo.com/Swing/HtmlTableTransferHandler.html)
- `Object.class`の`DefaultCellEditor`として編集を不可にした`JTextField`を設定することで編集は不可で文字列を選択してコピーは可能にする
    - `JTextField#setEditable(false)`で編集不可に設定
    - `JTextField#setBackground(JTable#getSelectionBackground())`でセルエディタの背景色を`JTable`の選択時背景色と同じに変更
    - `JTextField#setComponentPopupMenu(...)`でポップアップメニューからのコピーも可能にする
    - `DefaultCellEditor#setClickCountToStart(1)`を使用してシングルクリックでセルエディタが起動するよう設定し直接文字列の選択を可能にする

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableのセルを編集不可にする](https://ateraimemo.com/Swing/CellEditor.html)
- [JTableのHTML形式コピーをカスタマイズする](https://ateraimemo.com/Swing/HtmlTableTransferHandler.html)

<!-- dummy comment line for breaking list -->

## コメント
