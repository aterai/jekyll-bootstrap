---
layout: post
category: swing
folder: RotateTabRuns
title: JTabbedPaneのタブ・ランの回転を無効にする
tags: [JTabbedPane, LookAndFeel]
author: aterai
pubdate: 2019-08-26T15:08:32+09:00
description: JTabbedPaneで複数のランにタブをラップする場合でもタブ選択によるランの回転を無効にします。
image: https://drive.google.com/uc?id=16rk3I7OgmEfeRwOrYTrLp-3WcplBDOet
comments: true
---
## 概要
`JTabbedPane`で複数のランにタブをラップする場合でもタブ選択によるランの回転を無効にします。

{% download https://drive.google.com/uc?id=16rk3I7OgmEfeRwOrYTrLp-3WcplBDOet %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("TabbedPane.tabRunOverlay", 0);
UIManager.put("TabbedPane.selectedLabelShift", 0);
UIManager.put("TabbedPane.labelShift", 0);
UIManager.put("TabbedPane.selectedTabPadInsets", new Insets(0, 0, 0, 0));

JTabbedPane tabbedPane = new JTabbedPane() {
  @Override public void updateUI() {
    super.updateUI();
    setUI(new WindowsTabbedPaneUI() {
      @Override protected boolean shouldRotateTabRuns(int tabPlacement) {
        return false;
      }
    });
  }
};
</code></pre>

## 解説
- 上: `Default`
    - `MetalLookAndFeel`以外の`LookAndFeel`では`JTabbedPane`が`WRAP_TAB_LAYOUT`で複数のランにタブをラップするレイアウトモードの場合、選択されたタブがタブコンテンツに接地するようランの回転が発生する
    - `MetalLookAndFeel`の場合、`MetalTabbedPaneUI.TabbedPaneLayout#rotateTabRuns(int tabPlacement, int selectedRun)`メソッドがオーバーライドされて空(なにも実行しない)になっているため、タブ・ランの回転は発生しない
    - `MetalTabbedPaneUI#shouldRotateTabRuns(int tabPlacement, int selectedRun)`が常に`false`を返すよう設定されているが引数が`2`つあるこのメソッドは他では全く使用されておらず、`BasicTabbedPaneUI#shouldRotateTabRuns(int tabPlacement)`メソッドがオーバーライドされていないので無意味
        - 少なくとも`Java 5`以前から存在するコピペミスのバグ？かも(`@Override`が使用可能なら発覚していたはず)
- 下: `Override BasicTabbedPaneUI#shouldRotateTabRuns(...)`
    - `BasicTabbedPaneUI#shouldRotateTabRuns(int tabPlacement)`メソッドをオーバーライドして常に`false`を返すよう設定し、タブ・ランの回転を無効化
    - `UIManager.put("TabbedPane.tabRunOverlay", 0);`を設定してタブ・ランの重なりを除去
    - `UIManager.put("TabbedPane.labelShift", 0);`と`UIManager.put("TabbedPane.selectedLabelShift", 0);`を設定して、タブテキストのシフトを無効化
        - [JTabbedPaneのタブのテキストシフト量を変更する](https://ateraimemo.com/Swing/TabbedPaneLabelShift.html)
    - `UIManager.put("TabbedPane.selectedTabPadInsets", new Insets(0, 0, 0, 0));`を設定して、選択タブのサイズ拡張を無効化

<!-- dummy comment line for breaking list -->

## 参考リンク
- [BasicTabbedPaneUI#shouldRotateTabRuns(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/BasicTabbedPaneUI.html#shouldRotateTabRuns-int-)
- [JTabbedPaneのタブのテキストシフト量を変更する](https://ateraimemo.com/Swing/TabbedPaneLabelShift.html)
- [&#91;JDK-6855659&#93; Ability to disable tab run rotation - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6855659)

<!-- dummy comment line for breaking list -->

## コメント
