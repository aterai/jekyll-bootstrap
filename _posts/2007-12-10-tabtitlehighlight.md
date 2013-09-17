---
layout: post
title: JTabbedPaneのタブ文字列をハイライト
category: swing
folder: TabTitleHighlight
tags: [JTabbedPane, MouseMotionListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-12-10

## JTabbedPaneのタブ文字列をハイライト
`JTabbedPane`のタブ上に、マウスカーソルがある場合、その文字色を変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTU7QqLieI/AAAAAAAAAm0/dgW3rio-pzA/s800/TabTitleHighlight.png)

### サンプルコード
<pre class="prettyprint"><code>jtp.addMouseMotionListener(new MouseMotionAdapter() {
  @Override public void mouseMoved(MouseEvent e) {
    JTabbedPane source = (JTabbedPane)e.getSource();
    int tgt = source.indexAtLocation(e.getX(), e.getY());
    for(int i=0;i&lt;source.getTabCount();i++) {
      source.setForegroundAt(i, i==tgt ? Color.GREEN
                                       : Color.BLACK);
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、`JTabbedPane`に`MouseMotionListener`を追加し、`JTabbedPane#indexAtLocation`メソッドで、マウスカーソルの下にあるタブを取得しています。

`GTKLookAndFeel`(`Ubuntu`+`GNOME`+`jdk1.6.0_03`)などでは、タブの文字色を変更出来ないようです。

### 参考リンク
- [JTabbedPaneの選択文字色を変更](http://terai.xrea.jp/Swing/ColorTab.html)

<!-- dummy comment line for breaking list -->

### コメント
