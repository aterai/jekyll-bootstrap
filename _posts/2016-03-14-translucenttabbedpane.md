---
layout: post
category: swing
folder: TranslucentTabbedPane
title: JTabbedPaneのタブなどを半透明にする
tags: [JTabbedPane, UIManager, LookAndFeel]
author: aterai
pubdate: 2016-03-14T00:04:15+09:00
description: JTabbedPaneのタブ、タブエリア、コンテンツエリアなどを半透明に設定します。
comments: true
---
## 概要
`JTabbedPane`のタブ、タブエリア、コンテンツエリアなどを半透明に設定します。

{% download https://lh3.googleusercontent.com/-GLtzHl48JaY/VuWAq1hSxSI/AAAAAAAAOQk/HbrQluUnNH8_5fTM2gOIHhcoJMU21hmEgCCo/s800-Ic42/TranslucentTabbedPane.png %}

## サンプルコード
<pre class="prettyprint"><code>Color bgc = new Color(110, 110, 0, 100);
Color fgc = new Color(255, 255, 0, 100);
UIManager.put("TabbedPane.shadow",                fgc);
UIManager.put("TabbedPane.darkShadow",            fgc);
UIManager.put("TabbedPane.light",                 fgc);
UIManager.put("TabbedPane.highlight",             fgc);
UIManager.put("TabbedPane.tabAreaBackground",     fgc);
UIManager.put("TabbedPane.unselectedBackground",  fgc);
UIManager.put("TabbedPane.background",            bgc);
UIManager.put("TabbedPane.foreground",            Color.WHITE);
UIManager.put("TabbedPane.focus",                 fgc);
UIManager.put("TabbedPane.contentAreaColor",      fgc);
UIManager.put("TabbedPane.selected",              fgc);
UIManager.put("TabbedPane.selectHighlight",       fgc);
UIManager.put("TabbedPane.borderHightlightColor", fgc);
</code></pre>

## 解説
`UIManager.put(...)`を使用して、JTabbedPaneのタブやコンテンツエリアなどに、半透明の色を設定します。

- 注:
    - `Swing`のコンポーネントは、背景色が半透明かどうかを判断して再描画しているわけではないので、マウスカーソルのイベントなどで景色が重複して上書きされて残像が発生し、色が濃くなる場合がある
        - 半透明色で全体を再描画するように`JPanel#paintComponent(...)`をオーバーライドしたコンポーネントを挟んで回避する必要がある
        - [Backgrounds With Transparency « Java Tips Weblog](https://tips4java.wordpress.com/2009/05/31/backgrounds-with-transparency/)
        - [JFrameの透明化と再描画](http://ateraimemo.com/Swing/TranslucentFrameRepaint.html)
    - `UIManager.put(...)`で半透明になるかどうかは`LookAndFeel`に依存する
        - `NimbusLookAndFeel`では、タブなどが半透明にならない
        - `Classic`ではない`WindowsLookAndFeel`では、半透明にならない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTabbedPaneのタブエリア背景色などをテスト](http://ateraimemo.com/Swing/TabAreaBackground.html)

<!-- dummy comment line for breaking list -->

## コメント