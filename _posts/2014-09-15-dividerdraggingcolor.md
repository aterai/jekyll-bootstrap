---
layout: post
title: JSplitPaneでドラッグ中のDividerの背景色を設定する
category: swing
folder: DividerDraggingColor
tags: [JSplitPane, UIManager]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-09-15

## 概要
`JSplitPane`の`Divider`がドラッグ中の場合に、その移動先を示す矩形の色を変更します。

{% download https://lh5.googleusercontent.com/-M9cMsnuWpL0/VBWl0TfGYyI/AAAAAAAACNI/qvejKL7NGVk/s800/DividerDraggingColor.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("SplitPaneDivider.draggingColor", new Color(255, 100, 100, 100));
</code></pre>

## 解説
上記のサンプルでは、`JSplitPane#setContinuousLayout(false)`で、`JSplitPane`の`Divider`がドラッグ中の場合に、`Divider`の移動先を示す矩形の色を変更しています。

- - - -
ドラッグ中ではない`Divider`の色は、`LookAndFeel`によっては、以下のような方法で変更することができます。

<pre class="prettyprint"><code>BasicSplitPaneDivider divider = ((BasicSplitPaneUI) getUI()).getDivider();
divider.setBackground(Color.ORANGE);
</code></pre>

## 参考リンク
- [JSplitPaneでディバイダの移動を連続的に再描画](http://terai.xrea.jp/Swing/ContinuousLayout.html)

<!-- dummy comment line for breaking list -->

## コメント
