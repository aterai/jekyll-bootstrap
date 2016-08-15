---
layout: post
category: swing
folder: AdjustRowHeightFillsViewport
title: JTableの行高がJViewportの高さに合うまで調整する
tags: [JTable, JViewport, JScrollPane]
author: aterai
pubdate: 2015-07-13T02:32:20+09:00
description: JTableの各行の高さ変更することで行数などに変更があっても、JViewportに余白が発生しないように調整します。
image: https://lh3.googleusercontent.com/-Poa86QgNChU/VaKgwOMpRdI/AAAAAAAAN9E/2gQi6newmek/s800-Ic42/AdjustRowHeightFillsViewport.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2015/09/adjust-height-of-every-row-in-jtable-to.html
    lang: en
comments: true
---
## 概要
`JTable`の各行の高さ変更することで行数などに変更があっても、`JViewport`に余白が発生しないように調整します。

{% download https://lh3.googleusercontent.com/-Poa86QgNChU/VaKgwOMpRdI/AAAAAAAAN9E/2gQi6newmek/s800-Ic42/AdjustRowHeightFillsViewport.png %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  int prevHeight = -1;
  int prevCount = -1;
  public void updateRowsHeight(JViewport vport) {
    int height = vport.getExtentSize().height;
    int rowCount = getModel().getRowCount();
    int defautlRowHeight = height / rowCount;
    if ((height != prevHeight || rowCount != prevCount) &amp;&amp; defautlRowHeight &gt; 0) {
      int over = height - rowCount * defautlRowHeight;
      for (int i = 0; i &lt; rowCount; i++) {
        int a = over-- &gt; 0 ? i == rowCount - 1 ? over : 1 : 0;
        setRowHeight(i, defautlRowHeight + a);
      }
    }
    prevHeight = height;
    prevCount = rowCount;
  }
  @Override public void doLayout() {
    super.doLayout();
    Container p = SwingUtilities.getAncestorOfClass(JViewport.class, this);
    if (p instanceof JViewport) {
      updateRowsHeight((JViewport) p);
    }
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JViewport`のサイズまで`JTable`の各セルを`GridLayout`風に同比率で拡大縮小するよう`JTable#doLayout()`をオーバーライドしています。

- 余白(高さ方向)の調整
    - `JViewport`の高さが変更されたり、行数の増減があった場合、行の高さを`JTable#setRowHeight(...)`で設定し直すことで、`JViewport`に余白が発生しないように調整

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableの行の高さを変更する](http://ateraimemo.com/Swing/FishEyeTable.html)

<!-- dummy comment line for breaking list -->

## コメント
