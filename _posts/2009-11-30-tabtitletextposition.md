---
layout: post
category: swing
folder: TabTitleTextPosition
title: JTabbedPaneのタブアイコンとタイトルの位置
tags: [JTabbedPane, Icon, JLabel]
author: aterai
pubdate: 2009-11-30T13:18:03+09:00
description: JTabbedPaneのタブ中に配置するタイトルとアイコンの位置を変更します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTU96IMXGI/AAAAAAAAAm4/LydkDv26XY8/s800/TabTitleTextPosition.png
comments: true
---
## 概要
`JTabbedPane`のタブ中に配置するタイトルとアイコンの位置を変更します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTU96IMXGI/AAAAAAAAAm4/LydkDv26XY8/s800/TabTitleTextPosition.png %}

## サンプルコード
<pre class="prettyprint"><code>tabbedPane.addTab(title, c);
JLabel label = new JLabel(title, icon, SwingConstants.CENTER);
//label.setVerticalAlignment(SwingConstants.CENTER);
label.setVerticalTextPosition(SwingConstants.BOTTOM);
//label.setHorizontalAlignment(SwingConstants.CENTER);
label.setHorizontalTextPosition(SwingConstants.CENTER);
//Dimension dim = label.getPreferredSize();
//label.setPreferredSize(new Dimension(60, dim.height));
tabbedPane.setTabComponentAt(tabbedPane.getTabCount() - 1, label);
</code></pre>

## 解説
上記のサンプルでは、タブにアイコンとラベルの位置を変更した`JLabel`を配置しています。

- `JDK 1.6`以前の場合はタブにコンポーネントを直接配置する方法がないので、以下のような`html`タグを使用する必要がある
    
    <pre class="prettyprint"><code>JTabbedPane tabs = new JTabbedPane();
    tabs.addTab(makeTitle("Title","a32x32.png"), new JLabel("a"));
    tabs.addTab(makeTitle("Help", "b32x32.png"), new JLabel("b"));
    // ...
    private String makeTitle(String t, String p) {
      return "&lt;html&gt;&lt;center&gt;&lt;img src='"+getClass().getResource(p)+"'/&gt;&lt;br/&gt;"+t;
    }
</code></pre>
- * 参考リンク [#reference]
- [XP Style Icons - Download](https://xp-style-icons.en.softonic.com/)
- [JLabelのアイコンと文字列の位置](https://ateraimemo.com/Swing/TextPositionAndAlignment.html)
- [JTabbedPaneのタイトルをクリップ](https://ateraimemo.com/Swing/ClippedTabLabel.html)

<!-- dummy comment line for breaking list -->

## コメント
