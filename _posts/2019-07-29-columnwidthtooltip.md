---
layout: post
category: swing
folder: ColumnWidthTooltip
title: TableColumnのリサイズ中にその幅をJToolTipで表示する
tags: [JTable, JTableHeader, TableColumn, JToolTip, JWindow]
author: aterai
pubdate: 2019-07-29T02:07:59+09:00
description: TableColumnをマウスでリサイズ中の場合、その幅をJWindowに配置したJToolTipで表示します。
image: https://drive.google.com/uc?id=10_c07xtUT3tMntB9hunUeA4fV-jZN50j
comments: true
---
## 概要
`TableColumn`をマウスでリサイズ中の場合、その幅を`JWindow`に配置した`JToolTip`で表示します。

{% download https://drive.google.com/uc?id=10_c07xtUT3tMntB9hunUeA4fV-jZN50j %}

## サンプルコード
<pre class="prettyprint"><code>class ColumnWidthResizeHandler extends MouseInputAdapter {
  private final JWindow window = new JWindow();
  private final JToolTip tip = new JToolTip();
  private String prev = "";

  private Point getToolTipLocation(MouseEvent e) {
    Point p = e.getPoint();
    Component c = e.getComponent();
    SwingUtilities.convertPointToScreen(p, c);
    p.translate(0, -tip.getPreferredSize().height);
    return p;
  }

  private static TableColumn getResizingColumn(MouseEvent e) {
    Component c = e.getComponent();
    if (c instanceof JTableHeader) {
      return ((JTableHeader) c).getResizingColumn();
    }
    return null;
  }

  private void updateTooltipText(MouseEvent e) {
    TableColumn column = getResizingColumn(e);
    if (column != null) {
      String txt = String.format("Width: %dpx", column.getWidth());
      tip.setTipText(txt);
      if (prev.length() != txt.length()) {
        window.pack();
      }
      window.setLocation(getToolTipLocation(e));
      prev = txt;
    }
  }

  @Override public void mouseDragged(MouseEvent e) {
    if (!window.isVisible() &amp;&amp; getResizingColumn(e) != null) {
      window.add(tip);
      window.setAlwaysOnTop(true);
      window.setVisible(true);
    }
    updateTooltipText(e);
  }

  @Override public void mouseReleased(MouseEvent e) {
    window.setVisible(false);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`TableColumn`のマウスによるリサイズイベントを取得してその幅を`JToolTip`で表示しています。

- `JTable#getColumnModel()#addColumnModelListener(...)`
    - [TableColumnModelListener](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/event/TableColumnModelListener.html)では列の追加、削除、移動イベントは取得可能だが、リサイズイベントは取得不可
- `JTable#getTableHeader()#addPropertyChangeListener(...)`
    - `JTableHeader`に`PropertyChangeListener`を追加し、`JTableHeader#getResizingColumn()`メソッドでリサイズ状態の`ColumnModel`を取得可能だが、リサイズ終了イベントが取得できない
- `JTable#getTableHeader()#addMouseListener(...)`、`JTable#getTableHeader()#addMouseMotionListener()`
    - `MouseListener`と`JTableHeader#getResizingColumn()`メソッドを合わせて使用し、`ColumnModel`リサイズの開始終了を取得
    - `MouseMotionListener`を使用し、リサイズ中は`ColumnModel#getWidth()`メソッドで取得した`ColumnModel`の幅を`JToolTip`で表示
    - `JToolTip`のデフォルトウィンドウは使用せず、別途用意した`JWindow`に`JToolTip`を追加し、その`JWindow`で表示・非表示や位置の更新を操作

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JToolTipの表示位置](https://ateraimemo.com/Swing/ToolTipLocation.html)

<!-- dummy comment line for breaking list -->

## コメント
