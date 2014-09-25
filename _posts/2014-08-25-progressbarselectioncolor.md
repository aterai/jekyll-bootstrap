---
layout: post
title: JProgressBarの進捗状況と進捗文字列色を変更する
category: swing
folder: ProgressBarSelectionColor
tags: [JProgressBar, UIManager, LookAndFeel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-08-25

## 概要
`JProgressBar`の進捗状況の色や、それで塗り潰された場合の進捗文字列色を変更します。

{% download https://lh3.googleusercontent.com/-GXTDLsaFDf0/U_nV4WbEi0I/AAAAAAAACL0/09g79mFs9ZE/s800/ProgressBarSelectionColor.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("ProgressBar.foreground", Color.RED);
UIManager.put("ProgressBar.selectionForeground", Color.ORANGE);
UIManager.put("ProgressBar.background", Color.WHITE);
UIManager.put("ProgressBar.selectionBackground", Color.RED);
</code></pre>

<pre class="prettyprint"><code>progressBar2.setForeground(Color.BLUE);
progressBar2.setBackground(Color.CYAN.brighter());
progressBar2.setUI(new BasicProgressBarUI() {
  @Override protected Color getSelectionForeground() {
    return Color.PINK;
  }
  @Override protected Color getSelectionBackground() {
    return Color.BLUE;
  }
});
</code></pre>


## 解説
- 上: `Default`
- 中: `UIManager.put(...);`
    - 文字色: `"ProgressBar.foreground"`
    - 背景色: `"ProgressBar.background"`
    - 進捗状況で塗り潰された場合の文字色: `"ProgressBar.selectionForeground"`
    - 進捗状況の塗り潰し色: `"ProgressBar.selectionBackground"`
    - `NimbusLookAndFeel`では、すべて無効
    - `WindowsLookAndFeel`では、`"ProgressBar.background"`が無効
- 下: `BasicProgressBarUI`
    - 文字色: `JProgressBar#setForeground(Color)`で設定
    - 背景色: `JProgressBar#setBackground(Color)`で設定
    - 進捗状況で塗り潰された場合の文字色: `BasicProgressBarUI#getSelectionForeground()`をオーバーライド
    - 進捗状況の塗り潰し色: `BasicProgressBarUI#getSelectionBackground()`をオーバーライド

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JLayerを使ってJProgressBarの色相を変更する](http://terai.xrea.jp/Swing/ColorChannelSwapFilter.html)

<!-- dummy comment line for breaking list -->

## コメント