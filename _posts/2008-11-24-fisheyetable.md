---
layout: post
title: JTableの行の高さを変更する
category: swing
folder: FishEyeTable
tags: [JTable, MouseMotionListener, MouseListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-11-24

## JTableの行の高さを変更する
`JTable`の行の高さを変更して、マウスカーソルの下を魚眼レンズのように拡大します。

{% download %}

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMw3Q5yMI/AAAAAAAAAZs/0O7lUunN9Rw/s800/FishEyeTable.png)

### サンプルコード
<pre class="prettyprint"><code>@Override public void mouseMoved(MouseEvent e) {
  int row = rowAtPoint(e.getPoint());
  if(prev_row==row) return;
  initRowHeigth(prev_height, row);
  prev_row = row;
}
public void initRowHeigth(int height, int ccRow) {
  int rd2      = (fishEyeRowList.size()-1)/2;
  int rowCount = getModel().getRowCount();
  int view_rc  = getViewableColoredRowCount(ccRow);
  int view_h   = 0; for(int i=0;i&lt;view_rc;i++) view_h += fishEyeRowHeightList.get(i);
  int rest_rc  = rowCount - view_rc;
  int rest_h   = height - view_h;
  int rest_rh  = rest_h/rest_rc; rest_rh = rest_rh&gt;0?rest_rh:1;
  int a        = rest_h - rest_rh*rest_rc;
  int index    = -1;
  for(int i=-rd2;i&lt;rowCount;i++) {
    int crh;
    if(ccRow-rd2&lt;=i &amp;&amp; i&lt;=ccRow+rd2) {
      index++;
      if(i&lt;0) continue;
      crh = fishEyeRowHeightList.get(index);
    }else{
      if(i&lt;0) continue;
      crh = rest_rh+(a&gt;0?1:0);
      a = a-1;
    }
    setRowHeight(i, crh);
  }
}
</code></pre>

### 解説
上記のサンプルでは、マウスカーソルの下の行の高さを、`JTable#setRowHeight()`メソッドを使って変更することで、魚眼レンズのように拡大するようになっています。

- 注意
    - `JTable#setFillsViewportHeight(true);`を使用しているので、`JDK 1.6.0`以上が必要です。
    - `JTable`自体の高さが変化することは想定していません。

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Fisheye Menus](http://www.cs.umd.edu/hcil/fisheyemenu/)

<!-- dummy comment line for breaking list -->

### コメント
- スクリーンショット更新 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-12-25 (木) 16:12:54

<!-- dummy comment line for breaking list -->

