---
layout: post
title: JTableHeaderにJButtonを追加する
category: swing
folder: ButtonInTableHeader
tags: [JTable, JTableHeader, JButton, JPopupMenu, MouseListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-11-07

## 概要
`JTableHeader`にクリックするとポップアップメニューを表示する`JButton`を追加します。

{% download https://lh3.googleusercontent.com/-ccZ08VSXYwE/Trd27UaeD2I/AAAAAAAABEk/1NAYoZ1NGV0/s800/ButtonInTableHeader.png %}

## サンプルコード
<pre class="prettyprint"><code>@Override public void mouseClicked(MouseEvent e) {
  JTableHeader header = (JTableHeader)e.getSource();
  JTable table = header.getTable();
  TableColumnModel columnModel = table.getColumnModel();
  int vci = columnModel.getColumnIndexAtX(e.getX());
  int mci = table.convertColumnIndexToModel(vci);
  TableColumn column = table.getColumnModel().getColumn(mci);
  Rectangle r = header.getHeaderRect(vci);
  Container c = (Container)getTableCellRendererComponent(table, "", true, true, -1, vci);
  //if(!isNimbus) {
  //  Insets i = c.getInsets();
  //  r.translate(r.width-i.right, 0);
  //}else{
  r.translate(r.width-BUTTON_WIDTH, 0);
  r.setSize(BUTTON_WIDTH, r.height);
  Point pt = e.getPoint();
  if(c.getComponentCount()&gt;0 &amp;&amp; r.contains(pt) &amp;&amp; pop!=null) {
    pop.show(header, r.x, r.height);
    JButton b = (JButton)c.getComponent(0);
    b.doClick();
    e.consume();
  }
}
@Override public void mouseExited(MouseEvent e) {
  rolloverIndex = -1;
}
@Override public void mouseMoved(MouseEvent e) {
  JTableHeader header = (JTableHeader)e.getSource();
  JTable table = header.getTable();
  TableColumnModel columnModel = table.getColumnModel();
  int vci = columnModel.getColumnIndexAtX(e.getX());
  int mci = table.convertColumnIndexToModel(vci);
  rolloverIndex = mci;
}
</code></pre>

## 解説
上記のサンプルでは、`JTableHeader`の各カラムにマウスカーソルがある場合、`HeaderRenderer#getTableCellRendererComponent(...)`内で、右端に`JButton`を追加しています。ボタンがクリックされたときに表示する`JPopupMenu`は、`JTableHeader`に追加したマウスリスナーでクリックされた位置などを取得して表示するようになっています。

## コメント
- `NimbusLookAndFeel`で、`JPopupMenu`が表示されないのを修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-11-07 (月) 22:15:02

<!-- dummy comment line for breaking list -->

