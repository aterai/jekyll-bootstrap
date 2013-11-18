---
layout: post
title: Htmlで修飾した文字列のクリップ
category: swing
folder: ClippedHtmlLabel
tags: [Html, JTable, TableCellRenderer, JLabel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-07-06

## Htmlで修飾した文字列のクリップ
`Html`で文字列を修飾するとクリップされなくなるので、予めクリップした文字列を作成してから`Html`を使用します。

{% download %}

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJP6CTKHI/AAAAAAAAAUE/aD5gF_0luwI/s800/ClippedHtmlLabel.png)

### サンプルコード
<pre class="prettyprint"><code>class URLRenderer extends DefaultTableCellRenderer
                  implements MouseListener, MouseMotionListener {
  private static Rectangle lrect = new Rectangle();
  private static Rectangle irect = new Rectangle();
  private static Rectangle trect = new Rectangle();
  private int row = -1;
  private int col = -1;
  @Override public Component getTableCellRendererComponent(JTable table, Object value,
                           boolean isSelected, boolean hasFocus,
                           int row, int column) {
    super.getTableCellRendererComponent(table, value, isSelected, false, row, column);

    int mw = table.getColumnModel().getColumnMargin();
    int rh = table.getRowMargin();
    int w  = table.getColumnModel().getColumn(column).getWidth();
    int h  = table.getRowHeight(row);

    Insets i = this.getInsets();
    lrect.x = i.left;
    lrect.y = i.top;
    lrect.width  = w - (mw + i.right  + lrect.x);
    lrect.height = h - (rh + i.bottom + lrect.y);
    irect.x = irect.y = irect.width = irect.height = 0;
    trect.x = trect.y = trect.width = trect.height = 0;

    String str = SwingUtilities.layoutCompoundLabel(
      this,
      this.getFontMetrics(this.getFont()),
      value.toString(), //this.getText(),
      this.getIcon(),
      this.getVerticalAlignment(),
      this.getHorizontalAlignment(),
      this.getVerticalTextPosition(),
      this.getHorizontalTextPosition(),
      lrect,
      irect, //icon
      trect, //text
      this.getIconTextGap());

    if(!table.isEditing() &amp;&amp; this.row==row &amp;&amp; this.col==column) {
      setText("&lt;html&gt;&lt;u&gt;&lt;font color='blue'&gt;"+str);
    }else if(hasFocus) {
      setText("&lt;html&gt;&lt;font color='blue'&gt;"+str);
    }else{
      setText(str);
      //setText(value.toString());
    }
    return this;
  }
  //...
</code></pre>

### 解説
- 上
    - `setText("<html><font color='blue'>"+str);`で文字列に下線を引く
- 下
    - `SwingUtilities.layoutCompoundLabel`メソッドを使用して文字列をセル幅でクリップ
    - `setText("<html><font color='blue'>"+str);`で文字列に下線を引く

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTableのセルにHyperlinkを表示](http://terai.xrea.jp/Swing/HyperlinkInTableCell.html)

<!-- dummy comment line for breaking list -->

### コメント
