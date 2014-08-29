---
layout: post
title: JTableのヘッダを透明化
category: swing
folder: TransparentTableHeader
tags: [JTable, JTableHeader, Transparent, JScrollPane, JViewport, TableCellRenderer, TableCellEditor]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-04-04

## JTableのヘッダを透明化
`JTable`のヘッダ背景、セル間の垂直罫線を非表示にします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TZl3Ci_GNnI/AAAAAAAAA40/wSbo6ySTlz0/s800/TransparentTableHeader.png %}

### サンプルコード
<pre class="prettyprint"><code>class TransparentHeader extends JLabel implements TableCellRenderer {
  private final Border b = BorderFactory.createCompoundBorder(
      BorderFactory.createMatteBorder(0,0,1,0,Color.BLACK),
      BorderFactory.createEmptyBorder(2,2,1,2));
  private final Color alphaZero = new Color(0, true);
  @Override public Component getTableCellRendererComponent(
        JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    this.setText(Objects.toString(value, ""));
    this.setHorizontalAlignment(JLabel.CENTER);
    this.setOpaque(false);
    this.setBackground(alphaZero);
    this.setForeground(Color.BLACK);
    this.setBorder(b);
    return this;
  }
}
</code></pre>

### 解説
- `JTableHeader`
    - `JTableHeader`とヘッダレンダラーの両方を、`setOpaque(false)`, 背景色: `Color(0, true)`と設定
- `JTable`, `JScrollPane`(`Viewport`, `ColumnHeader`)も`setOpaque(false)`, 背景色: `Color(0, true)`と設定
    - 背景パターンは、`JScrollPane#paintComponent(...)`をオーバーライドして描画
        - [JTableを半透明にする](http://terai.xrea.jp/Swing/TransparentTable.html)は、`JViewport#paintComponent(...)`をオーバーライド
- `VerticalLine`
    - セル間の垂直線を非表示: `table.setShowVerticalLines(false);`
    - セル間の幅を`0`にして、選択時に罫線のあとが表示されないように設定: `table.setIntercellSpacing(new Dimension(0,1));`
- `Boolean.class`の`DefaultRenderer`
    - 透明化した`BooleanCellRenderer`や`BooleanCellEditor`を設定

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTableを半透明にする](http://terai.xrea.jp/Swing/TransparentTable.html)
- [JTableHeaderを非表示にする](http://terai.xrea.jp/Swing/RemoveTableHeader.html)
    - `JTable`のヘッダ自体を非表示にする場合のサンプル

<!-- dummy comment line for breaking list -->

### コメント
