---
layout: post
category: swing
folder: PlaceholderForEmptyTable
title: JTableが空の場合、中央にJComponentを表示する
tags: [JTable, JEditorPane, GridBagLayout, URL]
author: aterai
pubdate: 2010-09-13T11:14:48+09:00
description: JTableが空の場合、表領域の中央に任意のJComponentが表示されるように設定します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRDxbcszI/AAAAAAAAAgk/5iisfYFJom0/s800/PlaceholderForEmptyTable.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2010/09/placeholder-for-empty-jtable.html
    lang: en
comments: true
---
## 概要
`JTable`が空の場合、表領域の中央に任意の`JComponent`が表示されるように設定します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRDxbcszI/AAAAAAAAAgk/5iisfYFJom0/s800/PlaceholderForEmptyTable.png %}

## サンプルコード
<pre class="prettyprint"><code>JEditorPane hint = new JEditorPane("text/html", "&lt;html&gt;&lt;a href='dummy'&gt;No data!&lt;/a&gt;&lt;/html&gt;");

table.setFillsViewportHeight(true);
table.setLayout(new GridBagLayout());
table.add(hint);

model.addTableModelListener(new TableModelListener() {
  @Override public void tableChanged(TableModelEvent e) {
    DefaultTableModel model = (DefaultTableModel) e.getSource();
    hint.setVisible(model.getRowCount() == 0);
  }
});
</code></pre>

## 解説
- `JTable#setFillsViewportHeight(true)`として`JTable`の高さが`JViewport`の高さより小さい場合、両者が同じ高さになるように設定
- `JTable`のレイアウトを`null`から`GridBagLayout`に変更し、追加した編集不可の`JEditorPane`が中央に配置されるよう設定
- `TableModelListener#tableChanged(...)`イベントが発生したとき、モデルに行が存在するかどうかで`JEditorPane`の表示・非表示を切り替え

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TableModelListener (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/event/TableModelListener.html)

<!-- dummy comment line for breaking list -->

## コメント
- 大変素晴らしいです。参考にさせていただきました。 -- *shuna* 2010-09-18 (土) 12:12:50
    - ありがとうございます。どうもです。 -- *aterai* 2010-09-18 (土) 20:19:21

<!-- dummy comment line for breaking list -->
