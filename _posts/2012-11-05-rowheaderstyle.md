---
layout: post
category: swing
folder: RowHeaderStyle
title: JTableの行ヘッダに列ヘッダのRendererを使用する
tags: [JTable, JTableHeader, TableCellRenderer, Icon]
author: aterai
pubdate: 2012-11-05T14:47:06+09:00
description: JTableの行の描画に、JTableHeaderから取得した列ヘッダのRendererを適用します。
comments: true
---
## 概要
`JTable`の行の描画に、`JTableHeader`から取得した列ヘッダの`Renderer`を適用します。

{% download https://lh3.googleusercontent.com/-FSdrv2BDUCo/UJaJTUVXcdI/AAAAAAAABWU/gBeKokda9h8/s800/RowHeaderStyle.png %}

## サンプルコード
<pre class="prettyprint"><code>class RowHeaderRenderer extends JLabel implements TableCellRenderer {
  private int rollOverRowIndex = -1;

  public RowHeaderRenderer(JTable table) {
    super();
    RollOverListener rol = new RollOverListener();
    table.addMouseListener(rol);
    table.addMouseMotionListener(rol);
  }
  @Override public Component getTableCellRendererComponent(
      JTable tbl, Object val, boolean isS, boolean hasF, int row, int col) {
    TableCellRenderer tcr = tbl.getTableHeader().getDefaultRenderer();
    boolean f = row == rollOverRowIndex;
    JLabel l = (JLabel) tcr.getTableCellRendererComponent(
        tbl, val, isS, f ? f : hasF, -1, -1);
    if (tcr.getClass().getName().indexOf("XPDefaultRenderer") &gt;= 0) {
      l.setOpaque(!f);
      this.setIcon(new ComponentIcon(l));
      return this;
    } else {
      return l;
    }
  }
  class RollOverListener extends MouseAdapter {
    @Override public void mouseMoved(MouseEvent e) {
      JTable table = (JTable) e.getComponent();
      Point pt = e.getPoint();
      int col = table.columnAtPoint(pt);
      int column = table.convertColumnIndexToModel(col);
      if (column != 0) {
        return;
      }
      int prevRow = rollOverRowIndex;
      rollOverRowIndex = table.rowAtPoint(pt);
      if (rollOverRowIndex == prevRow) {
        return;
      }
      Rectangle repaintRect;
      if (rollOverRowIndex &gt;= 0) {
        Rectangle r = table.getCellRect(rollOverRowIndex, col, false);
        if (prevRow &gt;= 0) {
          repaintRect = r.union(table.getCellRect(prevRow, col, false));
        } else {
          repaintRect = r;
        }
      } else {
        repaintRect = table.getCellRect(prevRow, col, false);
      }
      table.repaint(repaintRect);
    }
    @Override public void mouseExited(MouseEvent e) {
      JTable table = (JTable) e.getComponent();
      Point pt = e.getPoint();
      int col = table.columnAtPoint(pt);
      int column = table.convertColumnIndexToModel(col);
      if (column != 0) {
        return;
      }
      if (rollOverRowIndex &gt;= 0) {
        table.repaint(table.getCellRect(rollOverRowIndex, col, false));
      }
      rollOverRowIndex = -1;
    }
  }
}
class ComponentIcon implements Icon {
  private final JComponent cmp;
  public ComponentIcon(JComponent cmp) {
    this.cmp = cmp;
  }
  @Override public int getIconWidth() {
    return 4000; //Short.MAX_VALUE;
  }
  @Override public int getIconHeight() {
    return cmp.getPreferredSize().height + 4; //XXX: +4 for Windows 7
  }
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    SwingUtilities.paintComponent(
        g, cmp, (Container)c, x, y, getIconWidth(), getIconHeight());
  }
}
</code></pre>

## 解説
上記のサンプルでは、`0`列目のセルの描画に、`JTable#getTableHeader()#getDefaultRenderer()`で取得したレンダラーを使用する`TableCellRenderer`を適用しています。

- ソートアイコンが列ヘッダに表示されていても、行ヘッダには表示しない
    - 引数の行と列を両方`-1`にして、`TableCellRenderer#getTableCellRendererComponent(...)`で描画用コンポーネント(`JLabel`)をヘッダレンダラーから取得
- `WindowsLookAndFeel`
    - ロールオーバーを描画する場合は、`TableCellRenderer#getTableCellRendererComponent(...)`で取得したコンポーネントを透明にする
    - 右と下側に余白が発生するので、ヘッダレンダラーからサイズを変更したアイコンを作成して、`JLabel#setIcon(Icon)`で表示

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableに行ヘッダを追加](http://ateraimemo.com/Swing/TableRowHeader.html)
- [JTableのセルのハイライト](http://ateraimemo.com/Swing/CellHighlight.html)

<!-- dummy comment line for breaking list -->

## コメント
