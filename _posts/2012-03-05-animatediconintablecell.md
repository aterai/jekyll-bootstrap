---
layout: post
category: swing
folder: AnimatedIconInTableCell
title: JTableのセルにAnimated GIFを表示する
tags: [JTable, ImageIcon, ImageObserver, Animation]
author: aterai
pubdate: 2012-03-05T01:22:05+09:00
description: ImageIconにImageObserverを設定して、JTableのセル中でAnimated GIFのアニメーションを行います。
image: https://lh3.googleusercontent.com/-138Snht85-E/T1B6iHoG1pI/AAAAAAAABJw/XaESowuWEC4/s800/AnimatedIconInTableCell.png
comments: true
---
## 概要
`ImageIcon`に`ImageObserver`を設定して、`JTable`のセル中で`Animated GIF`のアニメーションを行います。

{% download https://lh3.googleusercontent.com/-138Snht85-E/T1B6iHoG1pI/AAAAAAAABJw/XaESowuWEC4/s800/AnimatedIconInTableCell.png %}

## サンプルコード
<pre class="prettyprint"><code>ImageIcon icon = new ImageIcon(url);
//Wastefulness: icon.setImageObserver((ImageObserver) table);
icon.setImageObserver(new ImageObserver() {
  //@see http://www2.gol.com/users/tame/swing/examples/SwingExamples.html
  @Override public boolean imageUpdate(
      Image img, int infoflags, int x, int y, int w, int h) {
    //@see javax.swing.JLabel#imageUpdate(...)
    if (!table.isShowing()) {
      return false;
    }
    //@see java.awt.Component#imageUpdate(...)
    if ((infoflags &amp; (FRAMEBITS|ALLBITS)) != 0) {
      int vr = table.convertRowIndexToView(row); //JDK 1.6.0
      int vc = table.convertColumnIndexToView(col);
      table.repaint(table.getCellRect(vr, vc, false));
    }
    return (infoflags &amp; (ALLBITS | ABORT)) == 0;
  };
});
</code></pre>

## 解説
上記のサンプルでは、[AnimatedIconTableExample.java](http://www2.gol.com/users/tame/swing/examples/SwingExamples.html)を参考にして、`Animated GIF`ファイルから作成した`ImageIcon`に、`setImageObserver(ImageObserver)`を設定しています。直接`JTable`を`ImageObserver`として設定するとすべてのセルが再描画されて無駄なので、`JTable#getCellRect(row, col, false)`で対象セルのみ`repaint`するようにしています。

- [AnimatedIconTableExample.java](http://www2.gol.com/users/tame/swing/examples/SwingExamples.html)からの変更点
    - `JTable#isShowing(...)==false`で、非表示の場合は`JTable#repaint(...)`しない
    - `JDK 1.6.0`以降に導入された[JTable#convertRowIndexToView(row)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#convertRowIndexToView-int-)メソッドを使用し、行がソートされていても正しいセルのみを再描画する
    - [JTable#convertColumnIndexToView(col)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#convertColumnIndexToView-int-)メソッドを使って、列の入れ替えがあっても正しいセルのみを再描画する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [AnimatedIconTableExample.java](http://www2.gol.com/users/tame/swing/examples/SwingExamples.html)
    - 元サイトには繋がらないので、[animatedicontableexample.java - Google 検索](https://www.google.com/search?q=AnimatedIconTableExample.java)などのミラーを参考
- [JTreeのTreeNodeにAnimated GIFを表示する](https://ateraimemo.com/Swing/AnimatedTreeNode.html)

<!-- dummy comment line for breaking list -->

## コメント
