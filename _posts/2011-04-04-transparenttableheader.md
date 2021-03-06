---
layout: post
category: swing
folder: TransparentTableHeader
title: JTableのヘッダを透明化
tags: [JTable, JTableHeader, Transparent, JScrollPane, JViewport, TableCellRenderer, TableCellEditor]
author: aterai
pubdate: 2011-04-04T16:49:46+09:00
description: JTableのヘッダ背景、セル間の垂直罫線を非表示にします。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TZl3Ci_GNnI/AAAAAAAAA40/wSbo6ySTlz0/s800/TransparentTableHeader.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2011/04/transparent-jtableheader.html
    lang: en
comments: true
---
## 概要
`JTable`のヘッダ背景、セル間の垂直罫線を非表示にします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TZl3Ci_GNnI/AAAAAAAAA40/wSbo6ySTlz0/s800/TransparentTableHeader.png %}

## サンプルコード
<pre class="prettyprint"><code>class TransparentHeader extends JLabel implements TableCellRenderer {
  private final Border b = BorderFactory.createCompoundBorder(
      BorderFactory.createMatteBorder(0, 0, 1, 0, Color.BLACK),
      BorderFactory.createEmptyBorder(2, 2, 1, 2));
  private final Color alphaZero = new Color(0x0, true);
  @Override public Component getTableCellRendererComponent(
        JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    this.setText(Objects.toString(value, ""));
    this.setHorizontalAlignment(SwingConstants.CENTER);
    this.setOpaque(false);
    this.setBackground(alphaZero);
    this.setForeground(Color.BLACK);
    this.setBorder(b);
    return this;
  }
}
</code></pre>

## 解説
- `JTableHeader`
    - `JTableHeader`とヘッダセルレンダラーの両方を、`setOpaque(false)`, 背景色: `Color(0x0, true)`と設定
- `JTable`, `JScrollPane`(`Viewport`, `ColumnHeader`)も`setOpaque(false)`, 背景色: `Color(0x0, true)`と設定
    - 背景パターンは、`JScrollPane#paintComponent(...)`をオーバーライドして描画
        - [JTableを半透明にする](https://ateraimemo.com/Swing/TransparentTable.html)は、`JViewport#paintComponent(...)`をオーバーライド
- `VerticalLine`
    - セル間の垂直線を非表示: `table.setShowVerticalLines(false);`
    - セル間の幅を`0`にして、選択時に罫線のあとが表示されないように設定: `table.setIntercellSpacing(new Dimension(0, 1));`
- `Boolean.class`の`DefaultRenderer`
    - 透明化した`BooleanCellRenderer`や`BooleanCellEditor`を設定
- 注:
    - `ColumnHeader`には、`scroll.setColumnHeader(new JViewport());`とダミーの`JViewport`を設定しておかないと、`NullPointerException`が発生する
        
        <pre class="prettyprint"><code>scroll.setOpaque(false);
        scroll.setBackground(alphaZero);
        scroll.getViewport().setOpaque(false);
        scroll.getViewport().setBackground(alphaZero);
        scroll.setColumnHeader(new JViewport()); // Dummy JViewport
        scroll.getColumnHeader().setOpaque(false);
        scroll.getColumnHeader().setBackground(alphaZero);
</code></pre>
    - レンダラーとして使用している`JCheckBox`の揃えを`updateUI()`メソッドをオーバーライドして`setHorizontalAlignment(SwingConstants.CENTER);`で中央に変更していたが、効かなくなっている？
        - 何時からなのか不明
        - `getTableCellRendererComponent(...)`中で`setHorizontalAlignment(SwingConstants.CENTER);`を毎回設定して回避

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableを半透明にする](https://ateraimemo.com/Swing/TransparentTable.html)
- [JTableHeaderを非表示にする](https://ateraimemo.com/Swing/RemoveTableHeader.html)
    - `JTable`のヘッダ自体を非表示にする場合のサンプル
- [JTable#setShowVerticalLines(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#setShowVerticalLines-boolean-)

<!-- dummy comment line for breaking list -->

## コメント
