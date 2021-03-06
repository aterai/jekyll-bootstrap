---
layout: post
category: swing
folder: HoverCloseButton
title: JTabbedPaneのCloseButtonをフォーカスがある場合だけ表示
tags: [JTabbedPane, JButton, Focus]
author: aterai
pubdate: 2008-01-21T15:27:41+09:00
description: JTabbedPaneのタブを閉じるボタンを、タブにフォーカスがある場合だけ表示します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTN-acwv2I/AAAAAAAAAbo/gFaIpQr1XGc/s800/HoverCloseButton.png
comments: true
---
## 概要
`JTabbedPane`のタブを閉じるボタンを、タブにフォーカスがある場合だけ表示します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTN-acwv2I/AAAAAAAAAbo/gFaIpQr1XGc/s800/HoverCloseButton.png %}

## サンプルコード
<pre class="prettyprint"><code>class HoverCloseButtonTabbedPane extends JTabbedPane {
  private transient MouseMotionListener hoverHandler;
  public HoverCloseButtonTabbedPane() {
    super(TOP, SCROLL_TAB_LAYOUT);
  }
  public HoverCloseButtonTabbedPane(int tabPlacement) {
    super(tabPlacement, SCROLL_TAB_LAYOUT);
  }
  @Override public void updateUI() {
    removeMouseMotionListener(hoverHandler);
    super.updateUI();
    if (hoverHandler == null) {
      hoverHandler = new MouseMotionAdapter() {
        private int prev = -1;
        @Override public void mouseMoved(MouseEvent e) {
          JTabbedPane source = (JTabbedPane) e.getComponent();
          int focussed = source.indexAtLocation(e.getX(), e.getY());
          if (focussed == prev) {
            return;
          }
          for (int i = 0; i &lt; source.getTabCount(); i++) {
            TabPanel tab = (TabPanel) source.getTabComponentAt(i);
            tab.setButtonVisible(i == focussed);
          }
          prev = focussed;
        }
      };
    }
    addMouseMotionListener(hoverHandler);
  }
  @Override public void addTab(String title, final Component content) {
    super.addTab(title, content);
    setTabComponentAt(getTabCount() - 1, new TabPanel(this, title, content));
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JDK 6`で導入されたタブにコンポーネントを追加する機能を使って、タブ上にマウスカーソルがある場合だけそのタブを閉じるための`JButton`を表示しています。

- `JButton`が表示されても、そのタブ幅は常に一定
- `JButton`が表示されて、内部のタブタイトル表示幅が短くなった場合は、タブ文字列を`...`でクリップ

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTabbedPaneにタブを閉じるボタンを追加](https://ateraimemo.com/Swing/TabWithCloseButton.html)
- [JTabbedPaneのタブ文字列をハイライト](https://ateraimemo.com/Swing/TabTitleHighlight.html)

<!-- dummy comment line for breaking list -->

## コメント
- タブが選択されている場合も`JButton`を表示していたが、これを変更してタブ上にマウスカーソルがある場合だけ`JButton`を表示するように変更。 -- *aterai* 2008-03-19 (水) 21:09:18

<!-- dummy comment line for breaking list -->
