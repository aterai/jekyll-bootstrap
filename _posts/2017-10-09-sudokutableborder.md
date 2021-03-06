---
layout: post
category: swing
folder: SudokuTableBorder
title: JTableのセル罫線をMatteBorderで描画する
tags: [JTable, MatteBorder, TableCellRenderer]
author: aterai
pubdate: 2017-10-09T16:29:33+09:00
description: JTableのセル罫線をMatteBorderで描画することで3x3のブロック罫線を太さを変更しています。
image: https://drive.google.com/uc?id=17i0Wt64_TblvMzPrEX2YBqxGvdF7_L74Ew
hreflang:
    href: https://java-swing-tips.blogspot.com/2017/10/set-sudoku-style-border-lines-created.html
    lang: en
comments: true
---
## 概要
`JTable`のセル罫線を`MatteBorder`で描画することで`3x3`のブロック罫線を太さを変更しています。

{% download https://drive.google.com/uc?id=17i0Wt64_TblvMzPrEX2YBqxGvdF7_L74Ew %}

## サンプルコード
<pre class="prettyprint"><code>static class SudokuCellRenderer extends DefaultTableCellRenderer {
  private final Font font;
  private final Font bold;
  private final Border b0 = BorderFactory.createMatteBorder(
      0, 0, BORDERWIDTH1, BORDERWIDTH1, Color.GRAY);
  private final Border b1 = BorderFactory.createMatteBorder(
      0, 0, BORDERWIDTH2, BORDERWIDTH2, Color.BLACK);
  private final Border b2 = BorderFactory.createCompoundBorder(
      BorderFactory.createMatteBorder(0, 0, BORDERWIDTH2, 0, Color.BLACK),
      BorderFactory.createMatteBorder(0, 0, 0, BORDERWIDTH1, Color.GRAY));
  private final Border b3 = BorderFactory.createCompoundBorder(
      BorderFactory.createMatteBorder(0, 0, 0, BORDERWIDTH2, Color.BLACK),
      BorderFactory.createMatteBorder(0, 0, BORDERWIDTH1, 0, Color.GRAY));
  private final Integer[][] data;
  protected SudokuCellRenderer(Integer[][] src, Font font) {
    super();
    this.font = font;
    this.bold = font.deriveFont(Font.BOLD);
    Integer[][] dest = new Integer[src.length][src[0].length];
    for (int i = 0; i &lt; src.length; i++) {
      System.arraycopy(src[i], 0, dest[i], 0, src[0].length);
    }
    this.data = dest;
  }
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus,
      int row, int column) {
    boolean isEditable = data[row][column] == 0;
    super.getTableCellRendererComponent(
        table, value, isEditable &amp;&amp; isSelected, hasFocus, row, column);
    if (isEditable &amp;&amp; Objects.equals(value, 0)) {
      this.setText(" ");
    }
    setFont(isEditable ? font : bold);
    setHorizontalAlignment(CENTER);
    boolean rf = (row + 1) % 3 == 0;
    boolean cf = (column + 1) % 3 == 0;
    if (rf &amp;&amp; cf) {
      setBorder(b1);
    } else if (rf) {
      setBorder(b2);
    } else if (cf) {
      setBorder(b3);
    } else {
      setBorder(b0);
    }
    return this;
  }
}
</code></pre>

## 解説
上記のサンプルでは、以下のような設定で`3x3`のブロック罫線の太さを変更し、数独風のセル罫線をもつ`JTable`を作成しています。

- すべてのセルの罫線を非表示、かつセルの内余白を`0`に設定
    - [JTableの罫線の有無とセルの内余白を変更](https://ateraimemo.com/Swing/IntercellSpacing.html)
    - `JTable#setShowVerticalLines(false)`、`JTable#setShowHorizontalLines(false)`、`JTable#setIntercellSpacing(new Dimension());`
- 列幅、行高を罫線幅分だけ増加
    - `2,5,8`列目のセル列幅をブロック罫線の幅だけ増加、その他のセル列幅はセル罫線の幅だけ増加: `TableColumn#setPreferredWidth(int)`
    - `2,5,8`行目のセル行高をブロック罫線の幅だけ増加、その他のセル行高はセル罫線の幅だけ増加: `JTable#setRowHeight(int, int)`
- `MatteBorder`でセル罫線を描画する`DefaultTableCellRenderer`を設定
    - 罫線を描画するのは右辺と下辺のみ
    - `3`行、`3`列ごとに太さの異なるブロック罫線を描画する
- `JTable`を`JScrollPane`に追加、`JTable`のヘッダを非表示、`JViewport`の上辺と左辺にブロック罫線を描画
    - `JScrollPane`に追加した`JTable`自体に`Border`を設定すると`JTable`内部に`Border`が表示されてしまう

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JLabelに表示するtableタグの罫線を変更する](https://ateraimemo.com/Swing/HtmlTableBorderStyle.html)
- [JTableの罫線の有無とセルの内余白を変更](https://ateraimemo.com/Swing/IntercellSpacing.html)

<!-- dummy comment line for breaking list -->

## コメント
