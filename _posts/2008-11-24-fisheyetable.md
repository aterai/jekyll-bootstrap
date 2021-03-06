---
layout: post
category: swing
folder: FishEyeTable
title: JTableの行の高さを変更する
tags: [JTable, MouseMotionListener, MouseListener]
author: aterai
pubdate: 2008-11-24T16:48:07+09:00
description: JTableの行の高さを変更して、マウスカーソルの下を魚眼レンズのように拡大します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMw3Q5yMI/AAAAAAAAAZs/0O7lUunN9Rw/s800/FishEyeTable.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2008/12/jtable-fisheye-row.html
    lang: en
comments: true
---
## 概要
`JTable`の行の高さを変更して、マウスカーソルの下を魚眼レンズのように拡大します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMw3Q5yMI/AAAAAAAAAZs/0O7lUunN9Rw/s800/FishEyeTable.png %}

## サンプルコード
<pre class="prettyprint"><code>@Override public void mouseMoved(MouseEvent e) {
  int row = rowAtPoint(e.getPoint());
  if (prev_row == row) {
    return;
  }
  initRowHeight(prev_height, row);
  prev_row = row;
}
public void initRowHeight(int height, int ccRow) {
  int rd2      = (fishEyeRowList.size() - 1) / 2;
  int rowCount = getModel().getRowCount();
  int view_rc  = getViewableColoredRowCount(ccRow);
  int view_h   = 0; for (int i = 0; i &lt; view_rc; i++) view_h += fishEyeRowHeightList.get(i);
  int rest_rc  = rowCount - view_rc;
  int rest_h   = height - view_h;
  int rest_rh  = rest_h / rest_rc; rest_rh = rest_rh &gt; 0 ? rest_rh : 1;
  int a        = rest_h - rest_rh * rest_rc;
  int index    = -1;
  for (int i = -rd2; i &lt; rowCount; i++) {
    int crh;
    if (ccRow - rd2 &lt;= i &amp;&amp; i &lt;= ccRow + rd2) {
      index++;
      if (i &lt; 0) continue;
      crh = fishEyeRowHeightList.get(index);
    } else {
      if (i &lt; 0) continue;
      crh = rest_rh + (a &gt; 0 ? 1 : 0);
      a = a - 1;
    }
    setRowHeight(i, crh);
  }
}
</code></pre>

## 解説
上記のサンプルでは、マウスカーソルの下の行の高さを`JTable#setRowHeight(int, int)`メソッドを使用して動的に変更し、魚眼レンズのような拡大強調表示を行っています。

- `JTable#setFillsViewportHeight(true);`を使用しているので、`JDK 1.6.0`以上が必要
- `JTable`自体の高さが変化することは想定していない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTable#setRowHeight(int, int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#setRowHeight-int-int-)
- [Fisheye Menus](http://www.cs.umd.edu/hcil/fisheyemenu/)

<!-- dummy comment line for breaking list -->

## コメント
- スクリーンショット更新 -- *aterai* 2008-12-25 (木) 16:12:54

<!-- dummy comment line for breaking list -->
