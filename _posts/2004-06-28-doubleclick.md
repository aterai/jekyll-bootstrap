---
layout: post
title: JTableのセルをダブルクリック
category: swing
folder: DoubleClick
tags: [JTable, MouseListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-06-28

## JTableのセルをダブルクリック
`JTable`のセルをダブルクリックして内容を表示します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTLv3qaXoI/AAAAAAAAAYE/aAnkonlteYo/s800/DoubleClick.png %}

### サンプルコード
<pre class="prettyprint"><code>table.setAutoCreateRowSorter(true);
table.addMouseListener(new MouseAdapter() {
  @Override public void mouseClicked(MouseEvent me) {
    if(me.getClickCount()==2) {
      Point pt = me.getPoint();
      int idx = table.rowAtPoint(pt);
      if(idx&gt;=0) {
        int row = table.convertRowIndexToModel(idx);
        String str = String.format("%s (%s)", model.getValueAt(row, 1),
                                   model.getValueAt(row, 2));
        JOptionPane.showMessageDialog(table, str, "title",
                                      JOptionPane.INFORMATION_MESSAGE);
      }
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、セルをマウスでダブルクリックするとダイアログが開くようになっています。各セルはクリックで編集状態になってしまわないように、すべて編集不可にしています。

### コメント
- 行以外の場所をダブルクリックすると、`IndexOutOfBoundsException`が発生する不具合を修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-02-02 (水) 19:09:18

<!-- dummy comment line for breaking list -->

