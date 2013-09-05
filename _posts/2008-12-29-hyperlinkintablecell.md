---
layout: post
title: JTableのセルにHyperlinkを表示
category: swing
folder: HyperlinkInTableCell
tags: [JTable, TableCellRenderer, MouseListener, MouseMotionListener, Html, Desktop]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-12-29

## JTableのセルにHyperlinkを表示
`JTable`のセルの中に、`Hyperlink`を表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTOF06rk7I/AAAAAAAAAb0/31ZBya_beYk/s800/HyperlinkInTableCell.png)

### サンプルコード
<pre class="prettyprint"><code>class URLRenderer extends DefaultTableCellRenderer implements MouseListener, MouseMotionListener {
  private int row = -1;
  private int col = -1;
  @Override public Component getTableCellRendererComponent(JTable table, Object value,
                         boolean isSelected, boolean hasFocus, int row, int column) {
    super.getTableCellRendererComponent(table, value, isSelected, false, row, column);
    if(!table.isEditing() &amp;&amp; this.row==row &amp;&amp; this.col==column) {
      setText("&lt;html&gt;&lt;u&gt;&lt;font color='blue'&gt;"+value.toString());
    }else if(hasFocus) {
      setText("&lt;html&gt;&lt;font color='blue'&gt;"+value.toString());
    }else{
      setText(value.toString());
    }
    return this;
  }
  @Override public void mouseMoved(MouseEvent e) {
    JTable table = (JTable)e.getSource();
    Point pt = e.getPoint();
    row = table.rowAtPoint(pt);
    col = table.columnAtPoint(pt);
    if(row&lt;0 || col&lt;0) {
      row = -1;
      col = -1;
    }
    table.repaint();
  }
  @Override public void mouseExited(MouseEvent e)  {
    JTable table = (JTable)e.getSource();
    row = -1;
    col = -1;
    table.repaint();
  }
  @Override public void mouseClicked(MouseEvent e) {
    JTable table = (JTable)e.getSource();
    Point pt = e.getPoint();
    int crow = table.rowAtPoint(pt);
    int ccol = table.columnAtPoint(pt);
    //if(table.convertColumnIndexToModel(ccol) == 2)
    if(table.getColumnClass(ccol).equals(URL.class)) {
      URL url = (URL)table.getValueAt(crow, ccol);
      System.out.println(url);
      try{
        Desktop.getDesktop().browse(url.toURI());
      }catch(Exception ex) {
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

### 解説
`html`タグを使って文字列を修飾するセルレンダラーを作成して使用しています。

<pre class="prettyprint"><code>URLRenderer renderer = new URLRenderer();
table.setDefaultRenderer(URL.class, renderer);
table.addMouseListener(renderer);
table.addMouseMotionListener(renderer);
</code></pre>

- - - -
~~上記のサンプルでは、クリックしてもリンク先には接続せず、`System.out.println(table.getValueAt(crow, ccol));`で文字列を表示しているだけです。~~ `Java 6`以上を対象にすることにしたので、`Desktop.getDesktop().browse()`を使用するようにしました。

### 参考リンク
- [Hyperlinkを、JLabel、JButton、JEditorPaneで表示](http://terai.xrea.jp/Swing/HyperlinkLabel.html)
- [Htmlで修飾した文字列のクリップ](http://terai.xrea.jp/Swing/ClippedHtmlLabel.html)

<!-- dummy comment line for breaking list -->

### コメント
- `URLRenderer`のコンストラクタで`JTable`にマウスリスナを追加していたのを修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-06-25 (木) 12:05:13
- 「解説」中のコードではコンストラクタに`table`が渡されたままになっているようです。 -- [yosei](http://terai.xrea.jp/yosei.html) 2010-05-05 (Wed) 16:54:43
    - コメントありがとうございます。ご指摘のように修正し忘れていました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-05-06 (木) 17:04:59

<!-- dummy comment line for breaking list -->
