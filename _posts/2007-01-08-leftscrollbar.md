---
layout: post
title: JScrollBarをJScrollPaneの左と上に配置
category: swing
folder: LeftScrollBar
tags: [JScrollBar, JScrollPane, BorderLayout]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-01-08

## JScrollBarをJScrollPaneの左と上に配置
`JScrollBar`の配置位置を、`JScrollPane`の左側、上側に変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.ggpht.com/_9Z4BYR88imo/TQTPG13yZbI/AAAAAAAAAdc/1a4aTgyblRo/s800/LeftScrollBar.png)

### サンプルコード
<pre class="prettyprint"><code>scroll.setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT);
JPanel panel = new JPanel(new BorderLayout());
int w = scroll.getVerticalScrollBar().getPreferredSize().width;
panel.add(Box.createHorizontalStrut(w), BorderLayout.WEST);
panel.add(scroll.getHorizontalScrollBar(), BorderLayout.CENTER);
add(panel,  BorderLayout.NORTH);
add(scroll, BorderLayout.CENTER);
</code></pre>

### 解説
- 水平スクロールバーを右から左に
    - パネルのレイアウトを、`BorderLayout`にして、`JScrollPane`をそのパネルの中央(`BorderLayout.CENTER`)に追加し、`JScrollPane#setComponentOrientation`メソッドで、`ComponentOrientation.RIGHT_TO_LEFT`を設定しています。

<!-- dummy comment line for breaking list -->

- 垂直スクロールバーを下から上に
    - `JScrollPane#getHorizontalScrollBar()`メソッドでスクロールバーを取得し、パネルレイアウトを使って`JScrollPane`の上部(`BorderLayout.NORTH`)に配置されているように見せかけています。
    - 左上隅の余白は、`Box.createHorizontalStrut`(縦スクロールバーの幅)です。

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Swing - JScrollPane with scroll bar on the left](https://forums.oracle.com/thread/1375964)
- [2000ピクセル以上のフリー写真素材集](http://sozai-free.com/)
- [JScrollBarのButtonの位置を変更](http://terai.xrea.jp/Swing/ScrollBarButtonLayout.html)

<!-- dummy comment line for breaking list -->

### コメント
- グッド -- [a1](http://terai.xrea.jp/a1.html) 2008-12-26 (金) 13:52:59
    - どうも -- [aterai](http://terai.xrea.jp/aterai.html)

<!-- dummy comment line for breaking list -->

