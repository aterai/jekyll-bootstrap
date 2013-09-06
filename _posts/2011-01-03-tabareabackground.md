---
layout: post
title: JTabbedPaneのタブエリア背景色などをテスト
category: swing
folder: TabAreaBackground
tags: [JTabbedPane, UIManager]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-01-03

## JTabbedPaneのタブエリア背景色などをテスト
`MetalLookAndFeel`の`JTabbedPane`で、タブエリアの背景色などを変更するテストをしています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TSFbcaeJLEI/AAAAAAAAAw0/zQFscoerEGk/s800/TabAreaBackground.png)

### サンプルコード
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
UIManager.put("TabbedPane.borderHightlightColor", Color.WHITE);
</code></pre>

### 解説
上記のサンプルでは、`JPanel`タブの`JCheckBox`で`JTabbedPane`を不透明にしたり、`JComboBox`でキーを指定し、`UIManager.put("TabbedPane.unselectedBackground",  Color.GREEN);`などとして色を変更することができます。

- - - -
タブ文字色は、`JTabbedPane#setForegroundAt(...)`メソッドを使用して切り替えています。

- [JTabbedPaneの選択文字色を変更](http://terai.xrea.jp/Swing/ColorTab.html)
- [JTabbedPaneのタブ文字列をハイライト](http://terai.xrea.jp/Swing/TabTitleHighlight.html)

<!-- dummy comment line for breaking list -->

### コメント
