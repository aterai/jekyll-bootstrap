---
layout: post
category: swing
folder: HoverCloseButton
title: JTabbedPaneのCloseButtonをフォーカスがある場合だけ表示
tags: [JTabbedPane, JButton, Focus]
author: aterai
pubdate: 2008-01-21T15:27:41+09:00
description: JTabbedPaneのタブを閉じるボタンを、タブにフォーカスがある場合だけ表示します。
comments: true
---
## 概要
`JTabbedPane`のタブを閉じるボタンを、タブにフォーカスがある場合だけ表示します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTN-acwv2I/AAAAAAAAAbo/gFaIpQr1XGc/s800/HoverCloseButton.png %}

## サンプルコード
<pre class="prettyprint"><code>public MyJTabbedPane() {
  super();
  setTabLayoutPolicy(JTabbedPane.SCROLL_TAB_LAYOUT);
  addMouseMotionListener(new MouseMotionAdapter() {
    private int prev = -1;
    @Override public void mouseMoved(MouseEvent e) {
      JTabbedPane source = (JTabbedPane) e.getSource();
      int focussed = source.indexAtLocation(e.getX(), e.getY());
      if(focussed == prev) return;
      for(int i = 0; i &lt; source.getTabCount(); i++) {
        TabPanel tab = (TabPanel) source.getTabComponentAt(i);
        tab.setButtonVisible(i == focussed);
      }
      prev = focussed;
    }
  });
}
</code></pre>

## 解説
上記のサンプルでは、`JDK 6`で導入されたタブにコンポーネントを追加する機能を使って、タブ上にマウスカーソルがある場合だけ`JButton`を表示しています。

`JButton`が表示されても、そのタブ幅は常に一定で、内部のタブタイトルがクリップされるようになっています。

## 参考リンク
- [JTabbedPaneにタブを閉じるボタンを追加](http://ateraimemo.com/Swing/TabWithCloseButton.html)
- [JTabbedPaneのタブ文字列をハイライト](http://ateraimemo.com/Swing/TabTitleHighlight.html)

<!-- dummy comment line for breaking list -->

## コメント
- タブが選択されている場合にも`JButton`を表示していましたが、これを変更してタブ上にマウスカーソルがある場合だけ`JButton`を表示するようにしました。 -- *aterai* 2008-03-19 (水) 21:09:18

<!-- dummy comment line for breaking list -->
