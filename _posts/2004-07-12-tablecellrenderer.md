---
layout: post
category: swing
folder: TableCellRenderer
title: JTableのセル幅で文字列を折り返し
tags: [JTable, TableCellRenderer, JTextArea, JLabel]
author: aterai
pubdate: 2004-07-12T03:26:48+09:00
description: JTableのセル幅に合わせて文字列を折り返します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUbGVPssI/AAAAAAAAAmA/dPiTKpwf1Ro/s800/TableCellRenderer.png
comments: true
---
## 概要
`JTable`のセル幅に合わせて文字列を折り返します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUbGVPssI/AAAAAAAAAmA/dPiTKpwf1Ro/s800/TableCellRenderer.png %}

## サンプルコード
<pre class="prettyprint"><code>TableColumnModel tcm = table.getColumnModel();
tcm.getColumn(1).setCellRenderer(new TestRenderer());
tcm.getColumn(2).setCellRenderer(new TextAreaCellRenderer());
// ...
class TextAreaCellRenderer extends JTextArea implements TableCellRenderer {
  TextAreaCellRenderer() {
    super();
    setLineWrap(true);
  }
  @Override public Component getTableCellRendererComponent(
        JTable table, Object value, boolean isSelected, boolean hasFocus,
        int row, int column) {
    if (isSelected) {
      setForeground(table.getSelectionForeground());
      setBackground(table.getSelectionBackground());
    } else {
      setForeground(table.getForeground());
      setBackground(table.getBackground());
    }
    setText((value == null) ? "" : value.toString());
    return this;
  }
}
// ...
class TestRenderer extends MyJLabel implements TableCellRenderer {
  public TestRenderer() {
    super();
    setOpaque(true);
    setBorder(BorderFactory.createEmptyBorder(0, 5, 0, 5));
  }
  @Override public Component getTableCellRendererComponent(
        JTable table, Object value, boolean isSelected, boolean hasFocus,
        int row, int column) {
    if (isSelected) {
      setForeground(table.getSelectionForeground());
      setBackground(table.getSelectionBackground());
    } else {
      setForeground(table.getForeground());
      setBackground(table.getBackground());
    }
    // setHorizontalAlignment((value instanceof Number) ? RIGHT : LEFT);
    setFont(table.getFont());
    setText((value == null) ? "" : value.toString());
    return this;
  }
}
class MyJLabel extends JLabel {
  private GlyphVector gvtext;
  public MyJLabel() {super();}
  @Override protected void paintComponent(Graphics g) {
    // super.paintComponent(g);
    Graphics2D g2 = (Graphics2D) g;
    // ...
    g2.drawGlyphVector(gvtext,
                       getInsets().left,
                       getFont().getSize()+getInsets().top);
  }
  // ...
}
</code></pre>

## 解説
- `0`列目
    - デフォルトの`JLabel`を継承する`DefaultTableCellRenderer`を使用し、超過分は`...`で省略
- `1`列目
    - [文字列の折り返し](https://ateraimemo.com/Swing/GlyphVector.html)で作成した`JLabel`を継承するレンダラーを使って、セル幅に合わせて折り返し
- `2`列目
    - `JTextArea`を継承する`TableCellRenderer`を作成し、`JTextArea#setLineWrap(boolean)`メソッドを使用して折り返しを有効化

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TableCellRendererでセルの背景色を変更](https://ateraimemo.com/Swing/StripeTable.html)
- [JTableのセルの高さを自動調整](https://ateraimemo.com/Swing/AutoWrapTableCell.html)
    - セル幅だけでなく、高さも調整する方法のサンプル

<!-- dummy comment line for breaking list -->

## コメント
- メモ: `TextAreaCellRenderer`を、`NimbusLookAndFeel`で使ったとき、うまく余白を消す方法が分からない。 -- *aterai* 2008-05-08 (木) 18:25:18
- ここの方法だと行の高さも自動変更してくれます。~~This JDK Tutorial shows you how to wrap text inside cells of a JTable~~ (リンク切れ) -- *とおりすがり* 2010-12-10 (金) 10:12:40
- ご指摘ありがとうございます。この方法なら、[JTableのセルの高さを自動調整](https://ateraimemo.com/Swing/AutoWrapTableCell.html)で発生しているバグも修正できそうです。 -- *aterai* 2010-12-10 (金) 13:50:58
    - スクロールバーの表示・非表示が繰り返されるバグは修正できそうだけど、高さが更新されない場合がある(上記の`www.roseindia.net`にある例だと、列幅をすこしずつ調整すると、`fox`が表示されなくなる)方は難しそう？ -- *aterai* 2010-12-10 (金) 17:43:28

<!-- dummy comment line for breaking list -->
