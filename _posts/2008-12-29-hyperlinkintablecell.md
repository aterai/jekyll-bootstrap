---
layout: post
category: swing
folder: HyperlinkInTableCell
title: JTableのセルにHyperlinkを表示
tags: [JTable, TableCellRenderer, MouseListener, MouseMotionListener, Html, Desktop, Hyperlink]
author: aterai
pubdate: 2008-12-29T01:31:09+09:00
description: JTableのセルの中に、Hyperlinkを表示します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTOF06rk7I/AAAAAAAAAb0/31ZBya_beYk/s800/HyperlinkInTableCell.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2009/02/hyperlink-in-jtable-cell.html
    lang: en
comments: true
---
## 概要
`JTable`のセルの中に、`Hyperlink`を表示します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTOF06rk7I/AAAAAAAAAb0/31ZBya_beYk/s800/HyperlinkInTableCell.png %}

## サンプルコード
<pre class="prettyprint"><code>class URLRenderer extends DefaultTableCellRenderer implements MouseInputListener {
  private int row = -1;
  private int col = -1;
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value,
      boolean isSelected, boolean hasFocus, int row, int column) {
    super.getTableCellRendererComponent(
        table, value, isSelected, false, row, column);
    if (!table.isEditing() &amp;&amp; this.row == row &amp;&amp; this.col == column) {
      setText("&lt;html&gt;&lt;u&gt;&lt;font color='blue'&gt;" + value.toString());
    } else if (hasFocus) {
      setText("&lt;html&gt;&lt;font color='blue'&gt;" + value.toString());
    } else {
      setText(value.toString());
    }
    return this;
  }

  @Override public void mouseMoved(MouseEvent e) {
    JTable table = (JTable) e.getSource();
    Point pt = e.getPoint();
    row = table.rowAtPoint(pt);
    col = table.columnAtPoint(pt);
    if (row &lt; 0 || col &lt; 0) {
      row = -1;
      col = -1;
    }
    table.repaint();
  }

  @Override public void mouseExited(MouseEvent e)  {
    JTable table = (JTable) e.getSource();
    row = -1;
    col = -1;
    table.repaint();
  }

  @Override public void mouseClicked(MouseEvent e) {
    JTable table = (JTable) e.getSource();
    Point pt = e.getPoint();
    int crow = table.rowAtPoint(pt);
    int ccol = table.columnAtPoint(pt);
    // if (table.convertColumnIndexToModel(ccol) == 2)
    if (table.getColumnClass(ccol).equals(URL.class)) {
      URL url = (URL) table.getValueAt(crow, ccol);
      System.out.println(url);
      try {
        Desktop.getDesktop().browse(url.toURI());
      } catch (Exception ex) {
        ex.printStackTrace();
      }
    }
  }

  @Override public void mouseDragged(MouseEvent e) {}

  @Override public void mouseEntered(MouseEvent e) {}

  @Override public void mousePressed(MouseEvent e) {}

  @Override public void mouseReleased(MouseEvent e) {}
}
</code></pre>

## 解説
上記のサンプルでは、`JTable`のセル内にリンクを表現するために`html`タグを使って文字列を修飾するセルレンダラーを作成して使用しています。

<pre class="prettyprint"><code>URLRenderer renderer = new URLRenderer();
table.setDefaultRenderer(URL.class, renderer);
table.addMouseListener(renderer);
table.addMouseMotionListener(renderer);
</code></pre>

## 参考リンク
- [Hyperlinkを、JLabel、JButton、JEditorPaneで表示](https://ateraimemo.com/Swing/HyperlinkLabel.html)
- [Htmlで修飾した文字列のクリップ](https://ateraimemo.com/Swing/ClippedHtmlLabel.html)

<!-- dummy comment line for breaking list -->

## コメント
- `URLRenderer`のコンストラクタで`JTable`にマウスリスナーを追加していたのを修正。 -- *aterai* 2009-06-25 (木) 12:05:13
- 「解説」中のコードではコンストラクタに`table`が渡されたままになっているようです。 -- *yosei* 2010-05-05 (Wed) 16:54:43
    - コメントありがとうございます。ご指摘のように修正し忘れていました。 -- *aterai* 2010-05-06 (木) 17:04:59

<!-- dummy comment line for breaking list -->
