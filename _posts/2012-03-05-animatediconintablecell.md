---
layout: post
title: JTableのセルにAnimated GIFを表示する
category: swing
folder: AnimatedIconInTableCell
tags: [JTable, ImageIcon, ImageObserver]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-03-05

## JTableのセルにAnimated GIFを表示する
`ImageIcon`に`ImageObserver`を設定して、`JTable`のセル中で`Animated GIF`のアニメーションを行います。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/-138Snht85-E/T1B6iHoG1pI/AAAAAAAABJw/XaESowuWEC4/s800/AnimatedIconInTableCell.png)

### サンプルコード
<pre class="prettyprint"><code>ImageIcon icon = new ImageIcon(url);
//Wastefulness: icon.setImageObserver((ImageObserver)table);
icon.setImageObserver(new ImageObserver() {
  //@see http://www2.gol.com/users/tame/swing/examples/SwingExamples.html
  @Override public boolean imageUpdate(
      Image img, int infoflags, int x, int y, int w, int h) {
    //@see javax.swing.JLabel#imageUpdate(...)
    if(!table.isShowing()) return false;
    //@see java.awt.Component#imageUpdate(...)
    if((infoflags &amp; (FRAMEBITS|ALLBITS)) != 0) {
      int vr = table.convertRowIndexToView(row); //JDK 1.6.0
      int vc = table.convertColumnIndexToView(col);
      table.repaint(table.getCellRect(vr, vc, false));
    }
    return (infoflags &amp; (ALLBITS|ABORT)) == 0;
  };
});
</code></pre>

### 解説
上記のサンプルでは、[AnimatedIconTableExample.java](http://www2.gol.com/users/tame/swing/examples/SwingExamples.html)を参考にして、`Animated GIF`ファイルから作成した`ImageIcon`に、`setImageObserver(ImageObserver)`を設定しています。直接`JTable`を`ImageObserver`として設定するとすべてのセルが再描画されて無駄なので、`JTable#getCellRect(row, col, false)`で対象セルのみ`repaint`するようにしています。

- [AnimatedIconTableExample.java](http://www2.gol.com/users/tame/swing/examples/SwingExamples.html)からの変更点
    - `JTable#isShowing(...)==false`で、非表示の場合は`JTable#repaint(...)`しない
    - `JDK 1.6.0`以降に導入された`JTable#convertRowIndexToView(row)`を使って、行がソートされていても正しいセルを再描画する
    - `JTable#convertColumnIndexToView(col)`を使って、列の入れ替えがあっても正しいセルを再描画する

<!-- dummy comment line for breaking list -->

### 参考リンク
- [AnimatedIconTableExample.java](http://www2.gol.com/users/tame/swing/examples/SwingExamples.html)
    - 元サイトには繋がらないので、[animatedicontableexample.java - Google 検索](https://www.google.com/search?q=AnimatedIconTableExample.java)などのミラーを参考

<!-- dummy comment line for breaking list -->

### コメント
