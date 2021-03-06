---
layout: post
category: swing
folder: TabTitleHighlight
title: JTabbedPaneのタブ文字列をハイライト
tags: [JTabbedPane, MouseMotionListener]
author: aterai
pubdate: 2007-12-10T16:19:56+09:00
description: JTabbedPaneのタブ上に、マウスカーソルがある場合、その文字色を変更します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTU7QqLieI/AAAAAAAAAm0/dgW3rio-pzA/s800/TabTitleHighlight.png
comments: true
---
## 概要
`JTabbedPane`のタブ上に、マウスカーソルがある場合、その文字色を変更します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTU7QqLieI/AAAAAAAAAm0/dgW3rio-pzA/s800/TabTitleHighlight.png %}

## サンプルコード
<pre class="prettyprint"><code>jtp.addMouseMotionListener(new MouseMotionAdapter() {
  @Override public void mouseMoved(MouseEvent e) {
    JTabbedPane source = (JTabbedPane) e.getComponent();
    int tgt = source.indexAtLocation(e.getX(), e.getY());
    for (int i = 0; i &lt; source.getTabCount(); i++) {
      source.setForegroundAt(i, i == tgt ? Color.GREEN : Color.BLACK);
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JTabbedPane`に`MouseMotionListener`を追加し`JTabbedPane#indexAtLocation`メソッドでマウスカーソルの下にあるタブを取得しています。

- タブ文字色の変更が可能かは`LookAndFeel`に依存する
    - 例えば`GTKLookAndFeel`では`JTabbedPane#setForegroundAt(...)`メソッドでのタイトル変更は不可

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTabbedPaneの選択文字色を変更](https://ateraimemo.com/Swing/ColorTab.html)

<!-- dummy comment line for breaking list -->

## コメント
