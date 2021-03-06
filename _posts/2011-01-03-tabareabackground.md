---
layout: post
category: swing
folder: TabAreaBackground
title: JTabbedPaneのタブエリア背景色などをテスト
tags: [JTabbedPane, UIManager, MetalLookAndFeel]
author: aterai
pubdate: 2011-01-03T14:25:13+09:00
description: MetalLookAndFeelのJTabbedPaneで、タブエリアの背景色などを変更するテストをしています。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TSFbcaeJLEI/AAAAAAAAAw0/zQFscoerEGk/s800/TabAreaBackground.png
comments: true
---
## 概要
`MetalLookAndFeel`の`JTabbedPane`で、タブエリアの背景色などを変更するテストをしています。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TSFbcaeJLEI/AAAAAAAAAw0/zQFscoerEGk/s800/TabAreaBackground.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("TabbedPane.shadow",                Color.GRAY);
UIManager.put("TabbedPane.darkShadow",            Color.GRAY);
UIManager.put("TabbedPane.light",                 Color.GRAY);
UIManager.put("TabbedPane.highlight",             Color.GRAY);
UIManager.put("TabbedPane.tabAreaBackground",     Color.GRAY);
UIManager.put("TabbedPane.unselectedBackground",  Color.GRAY);
UIManager.put("TabbedPane.background",            Color.GRAY);
UIManager.put("TabbedPane.foreground",            Color.WHITE);
UIManager.put("TabbedPane.focus",                 Color.WHITE);
UIManager.put("TabbedPane.contentAreaColor",      Color.WHITE);
UIManager.put("TabbedPane.selected",              Color.WHITE);
UIManager.put("TabbedPane.selectHighlight",       Color.WHITE);
// UIManager.put("TabbedPane.borderHighlightColor",  Color.WHITE);
// Maybe typo but defined in MetalTabbedPaneUI
UIManager.put("TabbedPane.borderHightlightColor",  Color.WHITE);
</code></pre>

## 解説
上記のサンプルでは、`UIManager.put("TabbedPane.unselectedBackground", Color.GREEN);`などを利用して、`MetalLookAndFeel`でのタブエリアの背景色などを変更できます。

- `BasicLookAndFeel`、`MetalLookAndFeel`でのみ有効
- `JPanel`タブ内に配置されている`JCheckBox`で、`JTabbedPane`を不透明に設定可能
- `JPanel`タブ内に配置されている`JComboBox`で、`TabbedPane.tabAreaBackground`などのキーを指定し、その色の変更が可能
- タブ文字色は、`JTabbedPane#setForegroundAt(...)`メソッドを使用して切り替え可能
- `TabbedPane.borderHightlightColor`は`TabbedPane.borderHighlightColor`の書き間違いだと思うが、現状(`Java 11`で確認)の`MetalTabbedPaneUI`では`TabbedPane.borderHightlightColor`が定義されているため、こちらで色変更が可能になっている

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTabbedPaneの選択文字色を変更](https://ateraimemo.com/Swing/ColorTab.html)
- [JTabbedPaneのタブ文字列をハイライト](https://ateraimemo.com/Swing/TabTitleHighlight.html)
- [JDK-8078269 JTabbedPane UI Property TabbedPane.tabAreaBackground no longer works - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8078269)

<!-- dummy comment line for breaking list -->

## コメント
