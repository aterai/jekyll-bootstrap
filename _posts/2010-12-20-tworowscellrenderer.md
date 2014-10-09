---
layout: post
category: swing
folder: TwoRowsCellRenderer
title: JTableのセル内に二行だけ表示
tags: [JTable, TableCellRenderer, JLabel, JPanel]
author: aterai
pubdate: 2010-12-20T15:44:39+09:00
description: JTableのセル内に文字列を二行分だけ表示し、あふれる場合は...で省略します。
comments: true
---
## 概要
`JTable`のセル内に文字列を二行分だけ表示し、あふれる場合は`...`で省略します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQ77KlEsZJI/AAAAAAAAAuE/mc9fcp-ZmBU/s800/TwoRowsCellRenderer.png %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model);
table.setAutoCreateRowSorter(true);
table.setRowHeight(table.getRowHeight() * 2);
table.setDefaultRenderer(String.class, new TwoRowsCellRenderer());
</code></pre>

<pre class="prettyprint"><code>class TwoRowsCellRenderer extends JPanel implements TableCellRenderer {
  JLabel top = new JLabel();
  JLabel bottom = new JLabel();
  public TwoRowsCellRenderer() {
    super(new GridLayout(2,1,0,0));
    add(top);
    add(bottom);
  }
  @Override public Component getTableCellRendererComponent(JTable table,
      Object value,boolean isSelected,boolean hasFocus,int row,int column) {
    if (isSelected) {
      setForeground(table.getSelectionForeground());
      setBackground(table.getSelectionBackground());
    } else {
      setForeground(table.getForeground());
      setBackground(table.getBackground());
    }
    setFont(table.getFont());
    FontMetrics fm  = table.getFontMetrics(table.getFont());
    String text   = (value==null) ? "" : value.toString();
    String first  = text;
    String second   = "";
    int columnWidth = table.getColumnModel().getColumn(column).getWidth();
    int textWidth   = 0;
    for(int i=0; i&lt;text.length(); i++) {
      textWidth += fm.charWidth(text.charAt(i));
      if(textWidth&gt;columnWidth) {
        first  = text.substring(0,i-1);
        second = text.substring(i-1);
        break;
      }
    }
    top.setText(first);
    bottom.setText(second);
    return this;
  }
}
</code></pre>

## 解説
`JLabel`を上下に配置した`JPanel`を使って、`TableCellRenderer`を作成しています。`...`での省略は、二行目の`JLabel`のデフォルト動作です。

## 参考リンク
- [JLabelの文字列を折り返し](http://terai.xrea.jp/Swing/GlyphVector.html)

<!-- dummy comment line for breaking list -->

## コメント
