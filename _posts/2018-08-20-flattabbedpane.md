---
layout: post
category: swing
folder: FlatTabbedPane
title: JTabbedPaneのタブ描画をフラットデザイン風に変更する
tags: [JTabbedPane, BasicLookAndFeel]
author: aterai
pubdate: 2018-08-20T16:17:33+09:00
description: JTabbedPaneのタブに描画される縁やテキストシフトなどを無効にしてフラットデザイン風に変更します。
image: https://drive.google.com/uc?id=1HQCaLqj1ikLRJCljsjabjF2MS_a-UDhuNw
hreflang:
    href: https://java-swing-tips.blogspot.com/2018/08/change-tab-of-jtabbedpane-to-flat.html
    lang: en
comments: true
---
## 概要
`JTabbedPane`のタブに描画される縁やテキストシフトなどを無効にしてフラットデザイン風に変更します。

{% download https://drive.google.com/uc?id=1HQCaLqj1ikLRJCljsjabjF2MS_a-UDhuNw %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("TabbedPane.tabInsets", new Insets(5, 10, 5, 10));
UIManager.put("TabbedPane.tabAreaInsets", new Insets(0, 0, 0, 0));
UIManager.put("TabbedPane.selectedLabelShift", 0);
UIManager.put("TabbedPane.labelShift", 0);

// UIManager.put("TabbedPane.foreground", Color.WHITE);
// UIManager.put("TabbedPane.selectedForeground", Color.WHITE);
// UIManager.put("TabbedPane.unselectedBackground", UNSELECTED_BG);
UIManager.put("TabbedPane.tabAreaBackground", UNSELECTED_BG);

JTabbedPane tabs = new JTabbedPane() {
  @Override public void updateUI() {
    super.updateUI();
    setUI(new BasicTabbedPaneUI() {
      @Override protected void paintFocusIndicator(
          Graphics g, int tabPlacement, Rectangle[] rects, int tabIndex,
          Rectangle iconRect, Rectangle textRect, boolean isSelected) {
        // Do not paint anything
      }
      @Override protected void paintTabBorder(
          Graphics g, int tabPlacement, int tabIndex,
          int x, int y, int w, int h, boolean isSelected) {
        // Do not paint anything
      }
      @Override  protected void paintTabBackground(
          Graphics g, int tabPlacement, int tabIndex,
          int x, int y, int w, int h, boolean isSelected) {
        g.setColor(isSelected ? SELECTED_BG : UNSELECTED_BG);
        g.fillRect(x, y, w, h);
      }
    });
    setOpaque(true);
    setForeground(Color.WHITE);
    setTabPlacement(SwingConstants.LEFT);
    setTabLayoutPolicy(JTabbedPane.SCROLL_TAB_LAYOUT);
  }
};
</code></pre>

## 解説
上記のサンプルでは、タブの縁やフォーカスなどの描画を無効にした`BasicTabbedPaneUI`を作成して`JTabbedPane`に設定することで、フラットデザイン風の`JTabbedPane`を実現しています。

- `TabbedPane.selectedLabelShift`と`TabbedPane.labelShift`を`0`にして選択時の文字列シフトを無効化
    - 参考: [JDK-7010561 Tab text position with Synth based LaF is different to Java 5/6 - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-7010561)
- `JTabbedPane#setOpaque(true)`と`TabbedPane.tabAreaBackground`を設定して、タブエリアの背景色を変更
- `BasicTabbedPaneUI#paintFocusIndicator(...)`メソッドをオーバーライドして、フォーカスの点線を非表示
- `BasicTabbedPaneUI#paintTabBorder(...)`メソッドをオーバーライドして、タブの縁を非表示
- `BasicTabbedPaneUI#paintTabBackground(...)`メソッドをオーバーライドして、タブの背景を塗りつぶす
    - 例えば`JTabbedPane#setTabPlacement(SwingConstants.LEFT)`でタブエリアが左にある場合、タブの左側に`1px`の隙間ができる
    - `UIManager.put("TabbedPane.tabAreaInsets", new Insets(0, 0, 0, 0));`で除去できた
    - ~~`TabbedPane.selectedLabelShift`または`TabbedPane.labelShift`のデフォルト値が決め打ちで入っている？~~
    - ~~このサンプルでは左に`1px`タブ領域を拡大して対応~~
- タブコンテンツの縁飾りを無くす場合は、`UIManager.put("TabbedPane.contentBorderInsets", new Insets(0, 0, 0, 0));`などが使用可能
    - 縁飾りを選択背景色でベタ塗りする場合は、`BasicTabbedPaneUI#paintContentBorderLeftEdge(...)`メソッドなどをオーバーライドすることで対応可能
        - 参考: [swing - JAVA JTabbedPane - border of stacked tabs removal - Stack Overflow](https://stackoverflow.com/questions/51944426/java-jtabbedpane-border-of-stacked-tabs-removal)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTabbedPaneのタブエリア背景色などをテスト](https://ateraimemo.com/Swing/TabAreaBackground.html)
- [JDK-7010561 Tab text position with Synth based LaF is different to Java 5/6 - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-7010561)
- [swing - JAVA JTabbedPane - border of stacked tabs removal - Stack Overflow](https://stackoverflow.com/questions/51944426/java-jtabbedpane-border-of-stacked-tabs-removal)

<!-- dummy comment line for breaking list -->

## コメント
