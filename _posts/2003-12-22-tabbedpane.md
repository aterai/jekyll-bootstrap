---
layout: post
category: swing
folder: TabbedPane
title: JTabbedPaneでタブを追加削除
tags: [JTabbedPane, JPopupMenu]
author: aterai
pubdate: 2003-12-22
description: ポップアップメニューを使って、JTabbedPaneにタブを追加、削除します。
comments: true
---
## 概要
ポップアップメニューを使って、`JTabbedPane`にタブを追加、削除します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTULwZD83I/AAAAAAAAAlo/NwNuK8prCFY/s800/TabbedPane.png %}

## サンプルコード
<pre class="prettyprint"><code>private final JPopupMenu pop = new JPopupMenu() {
  @Override public void show(Component c, int x, int y) {
    //JDK 1.3 tabindex = tab.getUI().tabForCoordinate(tab, x, y);
    closePageAction.setEnabled(tab.indexAtLocation(x, y) &gt;= 0);
    closeAllAction.setEnabled(tab.getTabCount() &gt; 0);
    closeAllButActiveAction.setEnabled(tab.getTabCount() &gt; 0);
    super.show(c, x, y);
  }
};
</code></pre>

## 解説
上記のサンプルでは、ポップアップメニューから、タブの追加、削除などが実行できます。

削除メニューは、タブタイトル上で右クリックされた場合のみ選択可となります。タブタイトル上でマウスがクリックされたかどうかは、`JDK 1.4`で導入された`JTabbedPane#indexAtLocation`メソッドで判定しています。

## コメント
- スクリーンショットなどを更新 -- *aterai* 2008-03-13 (Thu) 21:58:23

<!-- dummy comment line for breaking list -->
