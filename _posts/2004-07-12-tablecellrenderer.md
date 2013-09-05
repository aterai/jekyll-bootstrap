---
layout: post
title: JTableのセル幅で文字列を折り返し
category: swing
folder: TableCellRenderer
tags: [JTable, TableCellRenderer, JTextArea, JLabel]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-07-12

## JTableのセル幅で文字列を折り返し
`JTable`のセル幅に合わせて文字列を折り返します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTUbGVPssI/AAAAAAAAAmA/dPiTKpwf1Ro/s800/TableCellRenderer.png)

### サンプルコード
<pre class="prettyprint"><code>TableColumnModel tcm = table.getColumnModel();
tcm.getColumn(1).setCellRenderer(new TestRenderer());
tcm.getColumn(2).setCellRenderer(new TextAreaCellRenderer());
</code></pre>
<pre class="prettyprint"><code>class TextAreaCellRenderer extends JTextArea implements TableCellRenderer {
  TextAreaCellRenderer() {
    super();
    setLineWrap(true);
  }
  @Override public Component getTableCellRendererComponent(
        JTable table, Object value, boolean isSelected, boolean hasFocus,
        int row, int column) {
    if(isSelected) {
      setForeground(table.getSelectionForeground());
      setBackground(table.getSelectionBackground());
    }else{
      setForeground(table.getForeground());
      setBackground(table.getBackground());
    }
    setText((value == null) ? "" : value.toString());
    return this;
  }
}
</code></pre>
<pre class="prettyprint"><code>class TestRenderer extends MyJLabel implements TableCellRenderer {
  public TestRenderer() {
    super();
    setOpaque(true);
    setBorder(BorderFactory.createEmptyBorder(0,5,0,5));
  }
  @Override public Component getTableCellRendererComponent(
        JTable table, Object value, boolean isSelected, boolean hasFocus,
        int row, int column) {
    if(isSelected) {
      setForeground(table.getSelectionForeground());
      setBackground(table.getSelectionBackground());
    }else{
      setForeground(table.getForeground());
      setBackground(table.getBackground());
    }
    //setHorizontalAlignment((value instanceof Number)?RIGHT:LEFT);
    setFont(table.getFont());
    setText((value == null) ? "" : value.toString());
    return this;
  }
}
class MyJLabel extends JLabel {
  private GlyphVector gvtext;
  public MyJLabel() {super();}
  @Override protected void paintComponent(Graphics g) {
    //super.paintComponent(g);
    Graphics2D g2 = (Graphics2D)g;
    //......
    g2.drawGlyphVector(gvtext,
                       getInsets().left,
                       getFont().getSize()+getInsets().top);
  }
  //......
}
</code></pre>

### 解説
- `0`列目
    - デフォルト

<!-- dummy comment line for breaking list -->

- `1`列目
    - [文字列の折り返し](http://terai.xrea.jp/Swing/GlyphVector.html)で作成した`JLabel`を継承するレンダラーを使って、セル幅に合わせて折り返しています。

<!-- dummy comment line for breaking list -->

- `2`列目
    - `JTextArea`を継承する`TableCellRenderer`を作成し、このレンダラーを`JTextArea#setLineWrap(boolean)`メソッドを使って折り返しを有効にしています。

<!-- dummy comment line for breaking list -->

### 参考リンク
- [TableCellRendererでセルの背景色を変更](http://terai.xrea.jp/Swing/StripeTable.html)
- [JTableのセルの高さを自動調整](http://terai.xrea.jp/Swing/AutoWrapTableCell.html)

<!-- dummy comment line for breaking list -->

### コメント
- メモ: `TextAreaCellRenderer`を、`NimbusLookAndFeel`で使ったとき、うまく余白を消す方法が分からない。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-05-08 (木) 18:25:18
- ここの方法だと行の高さも自動変更してくれます。[This JDK Tutorial shows you how to wrap text inside cells of a JTable](http://www.roseindia.net/javatutorials/JTable_in_JDK.shtml) -- [とおりすがり](http://terai.xrea.jp/とおりすがり.html) 2010-12-10 (金) 10:12:40
- ご指摘ありがとうございます。この方法なら、[JTableのセルの高さを自動調整](http://terai.xrea.jp/Swing/AutoWrapTableCell.html)で発生しているバグも修正できそうです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-12-10 (金) 13:50:58
    - スクロールバーの表示・非表示が繰り返されるバグは修正できそうだけど、高さが更新されない場合がある(上記の`www.roseindia.net`にある例だと、列幅をすこしずつ調整すると、`fox`が表示されなくなる)方は難しそう？ -- [aterai](http://terai.xrea.jp/aterai.html) 2010-12-10 (金) 17:43:28

<!-- dummy comment line for breaking list -->
