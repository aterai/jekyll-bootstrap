---
layout: post
category: swing
folder: ProgressBarSelectionColor
title: JProgressBarの進捗状況と進捗文字列色を変更する
tags: [JProgressBar, UIManager, LookAndFeel]
author: aterai
pubdate: 2014-08-25T00:01:25+09:00
description: JProgressBarの進捗状況の色や、それで塗り潰された場合の進捗文字列色を変更します。
image: https://lh3.googleusercontent.com/-GXTDLsaFDf0/U_nV4WbEi0I/AAAAAAAACL0/09g79mFs9ZE/s800/ProgressBarSelectionColor.png
comments: true
---
## 概要
`JProgressBar`の進捗状況の色や、それで塗り潰された場合の進捗文字列色を変更します。

{% download https://lh3.googleusercontent.com/-GXTDLsaFDf0/U_nV4WbEi0I/AAAAAAAACL0/09g79mFs9ZE/s800/ProgressBarSelectionColor.png %}

## サンプルコード
<pre class="prettyprint"><code>// progressBar1: UIManager.put(...)
UIManager.put("ProgressBar.foreground", Color.RED);
UIManager.put("ProgressBar.selectionForeground", Color.ORANGE);
UIManager.put("ProgressBar.background", Color.WHITE);
UIManager.put("ProgressBar.selectionBackground", Color.RED);

// progressBar2: BasicProgressBarUI
progressBar2.setForeground(Color.BLUE);
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
- 中: `UIManager.put(...)`
    - 文字色: `ProgressBar.foreground`
    - 背景色: `ProgressBar.background`
    - 進捗状況で塗り潰された場合の文字色: `ProgressBar.selectionForeground`
    - 進捗状況の塗り潰し色: `ProgressBar.selectionBackground`
    - `NimbusLookAndFeel`ではすべて無効
    - `WindowsLookAndFeel`では`ProgressBar.background`が無効
- 下: `BasicProgressBarUI`
    - 文字色: `JProgressBar#setForeground(Color)`で設定
    - 背景色: `JProgressBar#setBackground(Color)`で設定
    - 進捗状況で塗り潰された場合の文字色: `BasicProgressBarUI#getSelectionForeground()`をオーバーライドして設定
    - 進捗状況の塗り潰し色: `BasicProgressBarUI#getSelectionBackground()`をオーバーライドして設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JLayerを使ってJProgressBarの色相を変更する](https://ateraimemo.com/Swing/ColorChannelSwapFilter.html)

<!-- dummy comment line for breaking list -->

## コメント
