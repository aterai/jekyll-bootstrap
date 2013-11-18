---
layout: post
title: JTable自体の高さを拡張
category: swing
folder: FillsViewportHeight
tags: [JTable, JScrollPane, JViewport, JPopupMenu]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-08-20

## JTable自体の高さを拡張
`JDK 6`で導入された機能を使用して、`JViewport`の高さまで`JTable`を拡張します。

{% download %}

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMkfiP8jI/AAAAAAAAAZY/qHWqJtrcUgQ/s800/FillsViewportHeight.png)

### サンプルコード
<pre class="prettyprint"><code>table.setFillsViewportHeight(true);
</code></pre>
<pre class="prettyprint"><code>table = new JTable(model) {
  @Override public Component prepareRenderer(TableCellRenderer tcr, int row, int column) {
    Component c = super.prepareRenderer(tcr, row, column);
    if(isRowSelected(row)) {
      c.setForeground(getSelectionForeground());
      c.setBackground(getSelectionBackground());
    }else{
      c.setForeground(getForeground());
      c.setBackground((row%2==0)?evenColor:getBackground());
    }
    return c;
  }
};
JScrollPane scroll = new JScrollPane(table);
scroll.setBackground(Color.RED);
scroll.getViewport().setBackground(Color.GREEN);
//table.setBackground(Color.BLUE);
//table.setBackground(scroll.getBackground());
</code></pre>

### 解説
上記のサンプルでは、チェックボックスの選択状態で、`JTable#setFillsViewportHeight(boolean)`を適用するかどうかを切り替えることができます。

- `getFillsViewportHeight() == false`の場合(デフォルト値)
    - 下部の余白は`JTable`ではないため、`JViewport`の背景色(緑)が表示される
        - [JTableの背景色を変更](http://terai.xrea.jp/Swing/TableBackground.html)
    - `JScrollPane`、または`JViewport`に`setComponentPopupMenu`したり、リスナーを設定していないため、下部の余白で右クリックしてもポップアップメニューは無効

<!-- dummy comment line for breaking list -->

- `getFillsViewportHeight() == true`の場合
    - `JTable`の高さが`JViewport`の高さより小さい時は、両者が同じ高さになるように`JTable`が拡張される
    - `JTable#setBackgorund(Color)`で設定した色(薄い黄色)が`JTable`下部の余白の背景色となる
    - `JTable`自体が拡張されるため、余白部分を右クリックしてもポップアップメニューが表示される
        - 縦スクロールバーとテーブルヘッダで出来る余白(赤)などは`JScrollPane`なので、ポップアップメニューは無効
    - 簡単に余白部分にドロップしたり、空の`JTable`にドロップすることができる
        - [JTableの行をドラッグ＆ドロップ](http://terai.xrea.jp/Swing/DnDTable.html)では、余白にドロップ出来ない
        - [Fileのドラッグ＆ドロップ](http://terai.xrea.jp/Swing/FileListFlavor.html)では、`DropTarget`を`JTable`、`JViewport`の両方に設定する必要がある

<!-- dummy comment line for breaking list -->

- - - -
`JScrollPane`、`JViewport`の背景色も以下のように表示されることがあるので、実際に使う場合は`table.setBackground(scrollPane.getBackground())`するなどして、すべておなじ色になるようにしておいた方がいいかもしれません。

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTMm5lGwGI/AAAAAAAAAZc/VWaIAURiCKk/s800/FillsViewportHeight1.png)

- `scrollPane.setBackground(Color.RED);`
    - 縦スクロールバーとテーブルヘッダで出来る余白の色
- `scrollPane.getViewport().setBackground(Color.GREEN);`
    - 列をドラッグして移動する場合の隙間の色
    - `JTable#setAutoResizeMode(JTable.AUTO_RESIZE_OFF)`としたときの右余白

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTableの背景色を変更](http://terai.xrea.jp/Swing/TableBackground.html)
- [TableCellRendererでセルの背景色を変更](http://terai.xrea.jp/Swing/StripeTable.html)
- [Fileのドラッグ＆ドロップ](http://terai.xrea.jp/Swing/FileListFlavor.html)
- [JTable becomes uglier with AUTO_RESIZE_OFF - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/entry/jtable_becomes_uglier_with_auto)

<!-- dummy comment line for breaking list -->

### コメント
