---
layout: post
title: JSplitPaneに2つのJTableを配置してスクロールを同期する
category: swing
folder: SynchronizedScrollingTables
tags: [JTable, JScrollPane, JScrollBar, JSplitPane]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-11-12

## 概要
`JSplitPane`の左右に、`JTable`をそれぞれ配置し、スクロールや追加などが同期するようにモデルを共有します。

{% download https://lh4.googleusercontent.com/-mAnvPJlUJSI/UJ_bYI_kJsI/AAAAAAAABWo/a_jdyUqFLwM/s800/SynchronizedScrollingTables.png %}

## サンプルコード
<pre class="prettyprint"><code>JScrollPane scroll1 = new JScrollPane(leftTable);
//scroll1.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_NEVER);
scroll1.setVerticalScrollBar(new JScrollBar(JScrollBar.VERTICAL) {
  @Override public Dimension getPreferredSize() {
    Dimension dim = super.getPreferredSize();
    return new Dimension(0, dim.height);
  }
});
JScrollPane scroll2 = new JScrollPane(table);
scroll2.getVerticalScrollBar().setModel(scroll1.getVerticalScrollBar().getModel());
</code></pre>

## 解説
- `JTable`
    - `TableModel`を共有し、`JTable#removeColumn()`で、それぞれで非表示にする列を指定
    - 左右で`RowSorter`、`SelectionModel`を共有
- `JScrollPane`
    - それぞれ内部に配置する`JTable`の高さは、常に同じになるので、`VerticalScrollBar`の`BoundedRangeModel`を共有

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableの列固定とソート](http://terai.xrea.jp/Swing/FixedColumnTableSorting.html)
    - `ChangeListener`を使用、`1`つの`JScrollPane`に、`JTable`を`2`つ配置
- [JScrollPaneのスクロールを同期](http://terai.xrea.jp/Swing/SynchronizedScroll.html)
    - `ChangeListener`を使用
- [2つのJTableを同時にスクロール - argius note](http://d.hatena.ne.jp/argius/20080325/1206454660)
    - `AdjustmentListener`を使用

<!-- dummy comment line for breaking list -->

## コメント
