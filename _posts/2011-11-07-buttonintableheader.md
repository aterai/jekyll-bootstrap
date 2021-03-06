---
layout: post
category: swing
folder: ButtonInTableHeader
title: JTableHeaderにJButtonを追加する
tags: [JTable, JTableHeader, JButton, JPopupMenu, MouseListener]
author: aterai
pubdate: 2011-11-07T22:14:09+09:00
description: JTableHeaderにクリックするとポップアップメニューを表示するJButtonを追加します。
image: https://lh3.googleusercontent.com/-ccZ08VSXYwE/Trd27UaeD2I/AAAAAAAABEk/1NAYoZ1NGV0/s800/ButtonInTableHeader.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2011/12/dropdown-menu-button-in-jtableheader.html
    lang: en
comments: true
---
## 概要
`JTableHeader`にクリックするとポップアップメニューを表示する`JButton`を追加します。

{% download https://lh3.googleusercontent.com/-ccZ08VSXYwE/Trd27UaeD2I/AAAAAAAABEk/1NAYoZ1NGV0/s800/ButtonInTableHeader.png %}

## サンプルコード
<pre class="prettyprint"><code>@Override public void mouseClicked(MouseEvent e) {
  JTableHeader header = (JTableHeader) e.getSource();
  JTable table = header.getTable();
  TableColumnModel columnModel = table.getColumnModel();
  int vci = columnModel.getColumnIndexAtX(e.getX());
  int mci = table.convertColumnIndexToModel(vci);
  TableColumn column = table.getColumnModel().getColumn(mci);
  Rectangle r = header.getHeaderRect(vci);
  Container c = (Container) getTableCellRendererComponent(table, "", true, true, -1, vci);
  // if (!isNimbus) {
  //   Insets i = c.getInsets();
  //   r.translate(r.width - i.right, 0);
  // } else {
  r.translate(r.width - BUTTON_WIDTH, 0);
  r.setSize(BUTTON_WIDTH, r.height);
  Point pt = e.getPoint();
  if (c.getComponentCount() &gt; 0 &amp;&amp; r.contains(pt) &amp;&amp; pop != null) {
    pop.show(header, r.x, r.height);
    JButton b = (JButton) c.getComponent(0);
    b.doClick();
    e.consume();
  }
}

@Override public void mouseExited(MouseEvent e) {
  rolloverIndex = -1;
}

@Override public void mouseMoved(MouseEvent e) {
  JTableHeader header = (JTableHeader) e.getSource();
  JTable table = header.getTable();
  TableColumnModel columnModel = table.getColumnModel();
  int vci = columnModel.getColumnIndexAtX(e.getX());
  int mci = table.convertColumnIndexToModel(vci);
  rolloverIndex = mci;
}
</code></pre>

## 解説
上記のサンプルでは、`JTableHeader`の各カラムにマウスカーソルがある場合、`HeaderRenderer#getTableCellRendererComponent(...)`内で、右端に`JButton`を追加表示しています。ボタンがクリックされたときに開く`JPopupMenu`は、`JTableHeader`に追加したマウスリスナーでクリックされた座標を取得して表示しています。

## 参考リンク
- [TableColumnModel#getColumnIndexAtX(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/table/TableColumnModel.html#getColumnIndexAtX-int-)

<!-- dummy comment line for breaking list -->

## コメント
- `NimbusLookAndFeel`で`JPopupMenu`が表示されないバグを修正。 -- *aterai* 2011-11-07 (月) 22:15:02

<!-- dummy comment line for breaking list -->
