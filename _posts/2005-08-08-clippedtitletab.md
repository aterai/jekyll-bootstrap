---
layout: post
category: swing
folder: ClippedTitleTab
title: JTabbedPaneのタブを等幅にしてタイトルをクリップ
tags: [JTabbedPane]
author: aterai
pubdate: 2005-08-08T01:49:21+09:00
description: JTabbedPaneのタブを等幅にし、長いタイトルはクリップして表示します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTJXdZi5MI/AAAAAAAAAUQ/5nvfRoEEDEM/s800/ClippedTitleTab.png
comments: true
---
## 概要
`JTabbedPane`のタブを等幅にし、長いタイトルはクリップして表示します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTJXdZi5MI/AAAAAAAAAUQ/5nvfRoEEDEM/s800/ClippedTitleTab.png %}

## サンプルコード
<pre class="prettyprint"><code>final Insets tabInsets = UIManager.getInsets("TabbedPane.tabInsets");
tab1.setUI(new BasicTabbedPaneUI() {
  @Override protected int calculateTabWidth(
      int tabPlacement, int tabIndex, FontMetrics metrics) {
    Insets insets = tabPane.getInsets();
    Insets tabAreaInsets = getTabAreaInsets(tabPlacement);
    int width = tabPane.getWidth() - insets.left - insets.right
                                   - tabAreaInsets.left - tabAreaInsets.right;
    switch (tabPlacement) {
      case LEFT: case RIGHT:
        return (int) (width / 4);
      case BOTTOM: case TOP: default:
        return (int) (width / tabPane.getTabCount());
      }
  }
  @Override protected void paintText(
      Graphics g, int tabPlacement, Font font, FontMetrics metrics,
      int tabIndex, String title, Rectangle textRect, boolean isSelected) {
    Rectangle tabRect = rects[tabIndex];
    Rectangle rect = new Rectangle(textRect.x + tabInsets.left, textRect.y,
      tabRect.width - tabInsets.left - tabInsets.right, textRect.height);
    String clippedText = SwingUtilities.layoutCompoundLabel(metrics, title, null,
                                    SwingUtilities.CENTER, SwingUtilities.CENTER,
                                    SwingUtilities.CENTER, SwingUtilities.TRAILING,
                                    rect, new Rectangle(), rect, 0);
    if (title.equals(clippedText)) {
      super.paintText(g, tabPlacement, font, metrics, tabIndex,
                      title, textRect, isSelected);
    } else {
      rect = new Rectangle(textRect.x + tabInsets.left, textRect.y,
        tabRect.width - tabInsets.left - tabInsets.right, textRect.height);
      super.paintText(g, tabPlacement, font, metrics, tabIndex,
                      clippedText, rect, isSelected);
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`BasicTabbedPaneUI#calculateTabWidth(...)`メソッドをオーバーライドして、`JTabbedPane`のタブ幅が、すべて等しくなるように設定しています。

- タイトル文字列のほうが、このタブ幅より長い場合は、`SwingUtilities.layoutCompoundLabel(...)`メソッドで文字列をクリップして表示
- タイトルがクリップされていても、ツールチップで元の文字列を表示する
- タブの位置を左右にした場合、このサンプルでは全体の幅の`1/4`のタブ幅になるように設定

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJZ71XT7I/AAAAAAAAAUU/bO4iaEaR_xU/s800/ClippedTitleTab1.png)

- - - -
`JDK 1.6.0`なら、[JTabbedPaneのタイトルをクリップ](https://ateraimemo.com/Swing/ClippedTabLabel.html)のように、`JTabbedPane#setTabComponentAt`メソッドを使って、`JLabel`のクリップ機能をそのまま利用する方法もあります。

## 参考リンク
- [JTabbedPaneのタイトルをクリップ](https://ateraimemo.com/Swing/ClippedTabLabel.html)
- [JTabbedPaneのTabTitleを左揃えに変更](https://ateraimemo.com/Swing/TabTitleAlignment.html)
- [JTabbedPaneのタブ文字列のあふれをフェードアウト効果に変更する](https://ateraimemo.com/Swing/TextOverflowFadeTabbedPane.html)

<!-- dummy comment line for breaking list -->

## コメント
- `tabAreaInsets`を考慮するように修正しました。 -- *aterai* 2008-02-26 (火) 22:18:27

<!-- dummy comment line for breaking list -->
