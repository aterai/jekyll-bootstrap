---
layout: post
category: swing
folder: SelectedTabHeight
title: JTabbedPaneで選択したタブの高さを変更
tags: [JTabbedPane]
author: aterai
pubdate: 2010-04-05T04:28:58+09:00
description: JTabbedPaneで選択したタブの高さを変更します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTS0RHzbTI/AAAAAAAAAjY/__rqkPO3bsk/s800/SelectedTabHeight.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2010/04/jtabbedpane-selected-tab-height.html
    lang: en
comments: true
---
## 概要
`JTabbedPane`で選択したタブの高さを変更します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTS0RHzbTI/AAAAAAAAAjY/__rqkPO3bsk/s800/SelectedTabHeight.png %}

## サンプルコード
<pre class="prettyprint"><code>class WindowsTabHeightTabbedPaneUI extends WindowsTabbedPaneUI {
  private static final int TAB_AREA_HEIGHT = 32;
  @Override protected int calculateTabHeight(
      int tabPlacement, int tabIndex, int fontHeight) {
    return TAB_AREA_HEIGHT;
  }
  @Override protected void paintTab(
      Graphics g, int tabPlacement, Rectangle[] rects,
      int tabIndex, Rectangle iconRect, Rectangle textRect) {
    if (tabPane.getSelectedIndex() != tabIndex
        &amp;&amp; tabPlacement != JTabbedPane.LEFT
        &amp;&amp; tabPlacement != JTabbedPane.RIGHT) {
      int tabHeight = TAB_AREA_HEIGHT / 2 + 3;
      rects[tabIndex].height = tabHeight;
      if (tabPlacement == JTabbedPane.TOP) {
        rects[tabIndex].y = TAB_AREA_HEIGHT - tabHeight + 3;
      }
    }
    super.paintTab(g, tabPlacement, rects, tabIndex, iconRect, textRect);
  }
}
</code></pre>

## 解説
上記のサンプルでは、選択されていないタブの高さを低くすることで、選択されたタブの高さが目立つように設定しています。

- `BasicTabbedPaneUI#calculateTabHeight(...)`などをオーバーライドして、タブ領域の高さを変更
- `BasicTabbedPaneUI#paintTab(...)`などをオーバーライドして、描画されるタブの高さを`BasicTabbedPaneUI#calculateTabHeight(...)`で設定した高さの半分程度に変更
    - `JTabbedPane.TOP`の場合、選択されていないタブの`y`座標を下に移動
- 対応しているのは、`JTabbedPane.SCROLL_TAB_LAYOUT`の場合のみ
    - `JTabbedPane.TOP`と`JTabbedPane.BOTTOM`の場合、選択したタブの高さが変化する
    - `JTabbedPane.LEFT`と`JTabbedPane.RIGHT`の場合、すべてのタブが`BasicTabbedPaneUI#calculateTabHeight(...)`で設定した高さになる

<!-- dummy comment line for breaking list -->

- - - -
- タブの位置を変更する`JComboBox`を追加
    
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
    // ...
    comboBox.addItemListener(new ItemListener() {
      @Override public void itemStateChanged(ItemEvent e) {
        if (e.getStateChange() == ItemEvent.SELECTED) {
          tabbedPane.setTabPlacement(((TabPlacements) e.getItem()).tabPlacement);
        }
      }
    });
</code></pre>
- * 参考リンク [#reference]
- [BasicTabbedPaneUI#calculateTabHeight(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/BasicTabbedPaneUI.html#calculateTabHeight-int-int-int-)

<!-- dummy comment line for breaking list -->

## コメント
