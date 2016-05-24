---
layout: post
category: swing
folder: TableColumnHeaderIcon
title: JTableのカラムヘッダにIconを表示する
tags: [JTable, JTableHeader, TableColumn, Icon]
author: aterai
pubdate: 2016-01-25T01:26:15+09:00
description: JTableの各カラムヘッダにアイコンとタイトル文字列を表示するよう設定します。
comments: true
---
## 概要
`JTable`の各カラムヘッダにアイコンとタイトル文字列を表示するよう設定します。

{% download https://lh3.googleusercontent.com/-yQYpkrDnAcQ/VqT3Oq7tovI/AAAAAAAAOL8/YbbgnXgZ9B4/s800-Ic42/TableColumnHeaderIcon.png %}

## サンプルコード
<pre class="prettyprint"><code>URL[] icons = {
    getIconURL("wi0062-16.png"),
    getIconURL("wi0063-16.png"),
    getIconURL("wi0064-16.png")
};
String[] columnNames = {"Column1", "Column2", "Column3"};
JTable table = new JTable(new DefaultTableModel(columnNames, 8));
TableColumnModel m = table.getColumnModel();
for (int i = 0; i &lt; m.getColumnCount(); i++) {
  //m.getColumn(i).setHeaderRenderer(new IconColumnHeaderRenderer());
  m.getColumn(i).setHeaderValue( //cellspacing='0'
    String.format("&lt;html&gt;&lt;table cellpadding='0'&gt;&lt;td&gt;&lt;img src='%s'/&gt;&lt;/td&gt;%s",
                  icons[i], columnNames[i]));
}
table.setAutoCreateRowSorter(true);
</code></pre>

## 解説
上記のサンプルでは、カラムヘッダにアイコンを表示するために、タイトル文字列として`<img>`タグでアイコンを表示する`html`文字列を設定しています。

- メモ
    - `html`文字列として、`String.format("<html><img src='%s'/>nbsp%s", url, str)`を使用するとアイコンと文字列のベースラインが揃わない場合があるので、`<table>`タグを使用している
    - `<table>`タグを使用する場合、`JTableHeader`の高さが拡大するので、`cellpadding='0' cellspacing='0'`などでセル余白を`0`に変更している
    - デフォルトのヘッダレンダラーは`JLabel`を継承しているので、`setIcon(...)`メソッドが使用可能だが、`LookAndFeel`によってはソートアイコンと競合する場合がある

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class IconColumnHeaderRenderer implements TableCellRenderer {
  private final Icon icon = new ImageIcon(getClass().getResource("wi0063-16.png"));
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus,
      int row, int column)
    TableCellRenderer r = table.getTableHeader().getDefaultRenderer();
    JLabel l = (JLabel) r.getTableCellRendererComponent(
        table, value, isSelected, hasFocus, row, column);
    l.setHorizontalTextPosition(SwingConstants.RIGHT);
    l.setIcon(icon);
    return l;
  }
}
</code></pre>

## 参考リンク
- [XP Style Icons - Windows Application Icon, Software XP Icons](http://www.icongalore.com/)

<!-- dummy comment line for breaking list -->

## コメント
