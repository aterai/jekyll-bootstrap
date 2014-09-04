---
layout: post
title: JTabbedPaneで選択したタブの高さを変更
category: swing
folder: SelectedTabHeight
tags: [JTabbedPane]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-04-05

## 概要
`JTabbedPane`で選択したタブの高さを変更します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTS0RHzbTI/AAAAAAAAAjY/__rqkPO3bsk/s800/SelectedTabHeight.png %}

## サンプルコード
<pre class="prettyprint"><code>tabbedPane.setUI(new com.sun.java.swing.plaf.windows.WindowsTabbedPaneUI() {
  private static final int tabAreaHeight = 32;
  @Override protected int calculateTabHeight(
      int tabPlacement, int tabIndex, int fontHeight) {
    return tabAreaHeight;
  }
  @Override protected void paintTab(
      Graphics g, int tabPlacement, Rectangle[] rects,
      int tabIndex, Rectangle iconRect, Rectangle textRect) {
    if(tabPane.getSelectedIndex()!=tabIndex &amp;&amp;
       tabPlacement!=JTabbedPane.LEFT &amp;&amp;
       tabPlacement!=JTabbedPane.RIGHT) {
      int tabHeight = tabAreaHeight/2 + 3;
      rects[tabIndex].height = tabHeight;
      if(tabPlacement==JTabbedPane.TOP) {
        rects[tabIndex].y = tabAreaHeight - tabHeight + 3;
      }
    }
    super.paintTab(g, tabPlacement, rects, tabIndex, iconRect, textRect);
  }
});
</code></pre>

## 解説
上記のサンプルでは、選択されていないタブの高さを低くすることで、選択されたタブの高さが目立つように設定しています。

- `BasicTabbedPaneUI#calculateTabHeight(...)`などをオーバーライドして、タブ(領域)の高さを変更
- `BasicTabbedPaneUI#paintTab(...)`などをオーバーライドして、描画されるタブの高さを`BasicTabbedPaneUI#calculateTabHeight(...)`で設定した高さの半分程度に変更
    - `JTabbedPane.TOP`の場合、選択されていないタブの`y`座標を下に移動
- 対応しているのは、`JTabbedPane.SCROLL_TAB_LAYOUT`の場合のみ
    - `JTabbedPane.TOP`と`JTabbedPane.BOTTOM`の場合、選択したタブの高さが変化する
    - `JTabbedPane.LEFT`と`JTabbedPane.RIGHT`の場合、すべてのタブが`BasicTabbedPaneUI#calculateTabHeight(...)`で設定した高さになる

<!-- dummy comment line for breaking list -->

- - - -
注: 以下のようにタブの位置を変更する`JComboBox`を追加したので、`JDK 1.7.0`以上が必要

<pre class="prettyprint"><code>private static enum TabPlacements {
  TOP(JTabbedPane.TOP), BOTTOM(JTabbedPane.BOTTOM),
  LEFT(JTabbedPane.LEFT), RIGHT(JTabbedPane.RIGHT);
  public final int tabPlacement;
  private TabPlacements(int tabPlacement) {
    this.tabPlacement = tabPlacement;
  }
}
private final JComboBox&lt;TabPlacements&gt; comboBox =
    new JComboBox&lt;&gt;(TabPlacements.values());
private final JTabbedPane tabbedPane = new JTabbedPane(
    JTabbedPane.TOP, JTabbedPane.SCROLL_TAB_LAYOUT);
//...
comboBox.addItemListener(new ItemListener() {
  @Override public void itemStateChanged(ItemEvent e) {
    if(e.getStateChange()==ItemEvent.SELECTED) {
      tabbedPane.setTabPlacement(((TabPlacements)e.getItem()).tabPlacement);
    }
  }
});
</code></pre>

## コメント
