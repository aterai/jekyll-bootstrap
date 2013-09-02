---
layout: post
title: JTableが空の場合、中央にJComponentを表示する
category: swing
folder: PlaceholderForEmptyTable
tags: [JTable, JEditorPane, GridBagLayout, URL]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-09-13

## JTableが空の場合、中央にJComponentを表示する
`JTable`が空の場合、表領域の中央に任意の`JComponent`が表示されるように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTRDxbcszI/AAAAAAAAAgk/5iisfYFJom0/s800/PlaceholderForEmptyTable.png)

### サンプルコード
<pre class="prettyprint"><code>JEditorPane hint = new JEditorPane("text/html", "&lt;html&gt;&lt;a href='dummy'&gt;No data!&lt;/a&gt;&lt;/html&gt;");

table.setFillsViewportHeight(true);
table.setLayout(new GridBagLayout());
table.add(hint);

model.addTableModelListener(new TableModelListener() {
  @Override public void tableChanged(TableModelEvent e) {
    DefaultTableModel model = (DefaultTableModel)e.getSource();
    hint.setVisible(model.getRowCount()==0);
  }
});
</code></pre>

### 解説
上記のサンブルでは、`JTable`に編集不可にした`JEditorPane`を追加し、以下のように設定して、常に中央にレイアウトされるように設定しています。

- `JTable#setFillsViewportHeight(true)`として、`JTable`の高さが`JViewport`の高さより小さい場合、両者が同じ高さになるように設定
- `JTable`のレイアウトを`null`から、`GridBagLayout`に変更

<!-- dummy comment line for breaking list -->

~~追加した`JEditorPane`の表示非表示の切り替えは、ポップアップメニューで行の追加削除を行ったとき、`JTable#getRowCount()==0`かどうかで判断しています。~~ `TableModelListener`を使って行の追加削除を行ったときに`JEditorPane`の表示非表示を切り替えるように変更しました。


### コメント
- 大変素晴らしいです。参考にさせていただきました。 -- [shuna](http://terai.xrea.jp/shuna.html) 2010-09-18 (土) 12:12:50
    - ありがとうございます。どうもです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-09-18 (土) 20:19:21

<!-- dummy comment line for breaking list -->

