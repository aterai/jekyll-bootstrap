---
layout: post
category: swing
folder: RightSideRowHeader
title: JScrollPaneの行ヘッダを右側に変更する
tags: [JScrollPane, JScrollBar, JTable, ScrollPaneLayout, LayoutManager]
author: aterai
pubdate: 2018-09-10T16:22:14+09:00
description: JScrollPaneのレイアウトマネージャを使用して、行ヘッダをデフォルトの左側から右側に変更します。
image: https://drive.google.com/uc?id=1va-Vod9bidZfMkBZEMw6jIu8TQWjxNk5Mg
comments: true
---
## 概要
`JScrollPane`のレイアウトマネージャを使用して、行ヘッダをデフォルトの左側から右側に変更します。

{% download https://drive.google.com/uc?id=1va-Vod9bidZfMkBZEMw6jIu8TQWjxNk5Mg %}

## サンプルコード
<pre class="prettyprint"><code>class RightFixedScrollPaneLayout extends ScrollPaneLayout {
  @Override public void layoutContainer(Container parent) {
    // ...

    // if (leftToRight) {
    //   rowHeadR.x = availR.x;
    //   availR.x += rowHeadWidth;
    // } else {
    //   rowHeadR.x = availR.x + availR.width;
    // }
    rowHeadR.x = availR.x + availR.width;

    // ...

    // adjustForVSB(vsbNeeded, availR, vsbR, vpbInsets, leftToRight);
    adjustForVSB(vsbNeeded, rowHeadR, vsbR, vpbInsets, leftToRight);
</code></pre>

## 解説
- `JScrollPane#setRowHeaderView(...)`で行ヘッダを設定した場合、デフォルト(`ComponentOrientation.LEFT_TO_RIGHT`)では左側に配置される
    - 以下のような設定で行ヘッダを右側に配置可能だが、垂直`JScrollBar`が左側になる
        
        <pre class="prettyprint"><code>table.setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT);
        scroll.setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT);
        scroll.setCorner(ScrollPaneConstants.UPPER_RIGHT_CORNER, fixedTable.getTableHeader());
</code></pre>
- `ScrollPaneLayout#layoutContainer(...)`メソッドをオーバーライドして、行ヘッダや垂直`JScrollBar`の位置を直接変更する
    - 行ヘッダの位置: `ComponentOrientation.RIGHT_TO_LEFT`が設定されている場合と同じになるよう修正
    - 垂直`JScrollBar`の位置: `adjustForVSB(...)`メソッドの引数に`JViewport`ではなく行ヘッダの`Rectangle`を渡すよう修正
        - このため、`JViewport`の右側ではなく行ヘッダの右側に垂直`JScrollBar`が配置され、`JViewport`の幅ではなく行ヘッダの幅が垂直`JScrollBar`の幅だけ縮小される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableに行ヘッダを追加](https://ateraimemo.com/Swing/TableRowHeader.html)
- [JTableの列固定とソート](https://ateraimemo.com/Swing/FixedColumnTableSorting.html)
- [JSplitPaneに2つのJTableを配置してスクロールを同期する](https://ateraimemo.com/Swing/SynchronizedScrollingTables.html)

<!-- dummy comment line for breaking list -->

## コメント
