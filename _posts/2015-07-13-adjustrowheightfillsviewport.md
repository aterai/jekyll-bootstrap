---
layout: post
category: swing
folder: AdjustRowHeightFillsViewport
title: JTableの行高がJVeiwportの高さに合うまで調整する
tags: [JTable, JVewport, JScrollPane]
author: aterai
pubdate: 2015-07-13T02:32:20+09:00
description: JTableの各行の高さ変更することで行数などに変更があっても、JVeiwportに余白が発生しないように調整します。
comments: true
---
## 概要
`JTable`の各行の高さ変更することで行数などに変更があっても、`JVeiwport`に余白が発生しないように調整します。

{% download https://lh3.googleusercontent.com/-Poa86QgNChU/VaKgwOMpRdI/AAAAAAAAN9E/2gQi6newmek/s800-Ic42/AdjustRowHeightFillsViewport.png %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  int prevHeight = -1;
  int prevCount = -1;
  public void updateRowsHeigth(JViewport vport) {
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
      updateRowsHeigth((JViewport) p);
    }
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JTable#doLayout()`をオーバーライドし、`JViewport`の高さが変更されり、行数の増減があった場合、行の高さを`JTable#setRowHeight(...)`で設定し直すことで、`JViewport`に余白が発生しないように調整しています。

## 参考リンク
- [JTableの行の高さを変更する](http://ateraimemo.com/Swing/FishEyeTable.html)

<!-- dummy comment line for breaking list -->

## コメント
