---
layout: post
category: swing
folder: ScrollableTracksViewportWidth
title: JTableの幅が一定以下で水平スクロールバー、以上で列幅を自動拡張するよう設定
tags: [JTable, JScrollPane, JTableHeader]
author: aterai
pubdate: 2019-04-15T14:10:59+09:00
description: JTableの幅が一定以下の場合は列幅を維持して水平スクロールバーを表示し、それ以上になる場合は列幅の自動調整を実行してJTableの幅まで拡張するよう設定します。
image: https://drive.google.com/uc?id=1eCpohELZxCaXX2bowhwY668e4Ww3hn326A
comments: true
---
## 概要
`JTable`の幅が一定以下の場合は列幅を維持して水平スクロールバーを表示し、それ以上になる場合は列幅の自動調整を実行して`JTable`の幅まで拡張するよう設定します。

{% download https://drive.google.com/uc?id=1eCpohELZxCaXX2bowhwY668e4Ww3hn326A %}

## サンプルコード
<pre class="prettyprint"><code>JTable table3 = new JTable(1, 3) {
  @Override public boolean getScrollableTracksViewportWidth() {
    // default: return !(autoResizeMode == AUTO_RESIZE_OFF);
    return getPreferredSize().width &lt; getParent().getWidth();
  }
};
</code></pre>

## 解説
- `AUTO_RESIZE_SUBSEQUENT_COLUMNS(Default)`
    - `JTable`のデフォルト
    - `JTable`の幅が変更された場合、列幅の合計が`JTable`の幅と等しくなるよう各列を均等にサイズ変更
- `AUTO_RESIZE_OFF`
    - `JTable`の幅が変更されても列幅の調整は自動的に行わず、代わりに水平スクロールバーを使用
- `AUTO_RESIZE_OFF + getScrollableTracksViewportWidth()`
    - `JTable#getScrollableTracksViewportWidth()`メソッドをオーバーライドし、`JTable`の幅に応じて列幅の自動調整を実行するかどうかを切り替えるよう設定
        - 参考: [java - How to make JTable both AutoResize and horizontall scrollable? - Stack Overflow](https://stackoverflow.com/questions/6104916/how-to-make-jtable-both-autoresize-and-horizontall-scrollable)
    - `JTable`の幅が一定以下に縮小された場合は、列幅を維持して水平スクロールバーを使用
    - `JTable`の幅が一定以上に拡張された場合は、列幅の自動調整を実行して列幅の合計が`JTable`の幅と等しくなるよう各列を均等にサイズ変更
        - 上記のサンプルでは`JTable`の推奨サイズ幅で切り替えるよう設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Scrollable#getScrollableTracksViewportWidth() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/Scrollable.html#getScrollableTracksViewportWidth--)
- [JTable#getScrollableTracksViewportWidth() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#getScrollableTracksViewportWidth--)
- [java - How to make JTable both AutoResize and horizontall scrollable? - Stack Overflow](https://stackoverflow.com/questions/6104916/how-to-make-jtable-both-autoresize-and-horizontall-scrollable)

<!-- dummy comment line for breaking list -->

## コメント
