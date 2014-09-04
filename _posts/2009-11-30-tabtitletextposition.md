---
layout: post
title: JTabbedPaneのタブアイコンとタイトルの位置
category: swing
folder: TabTitleTextPosition
tags: [JTabbedPane, Icon, JLabel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-11-30

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
tabbedPane.setTabComponentAt(tabbedPane.getTabCount()-1, label);
</code></pre>

## 解説
上記のサンプルでは、タブにアイコンとラベルの位置を変更した`JLabel`を配置しています。

- - - -
`Java 1.6.0`以前の場合は、以下のように、`html`タグを使用しても良いかもしれません。

<pre class="prettyprint"><code>JTabbedPane tabs = new JTabbedPane();
tabs.addTab(makeTitle("Title","a32x32.png"), new JLabel("a"));
tabs.addTab(makeTitle("Help", "b32x32.png"), new JLabel("b"));
//...
private String makeTitle(String t, String p) {
  return "&lt;html&gt;&lt;center&gt;&lt;img src='"+getClass().getResource(p)+"'/&gt;&lt;br/&gt;"+t;
}
</code></pre>

## 参考リンク
- [XP Style Icons - Windows Application Icon, Software XP Icons](http://www.icongalore.com/)
- [JLabelのアイコンと文字列の位置](http://terai.xrea.jp/Swing/TextPositionAndAlignment.html)
- [JTabbedPaneのタイトルをクリップ](http://terai.xrea.jp/Swing/ClippedTabLabel.html)

<!-- dummy comment line for breaking list -->

## コメント
