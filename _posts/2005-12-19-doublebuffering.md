---
layout: post
title: DoubleBufferingで自由曲線を描画
category: swing
folder: DoubleBuffering
nofollow: true
comments: true
---

Posted by [](http://terai.xrea.jp/.html) at 2005-12-19

以前ここに在ったサンプルは修正して、[JPanelにマウスで自由曲線を描画](http://terai.xrea.jp/Swing/PaintPanel.html)に移動しました。

- `Swing`のコンポーネントでは、自動的に`Double Buffering`が行われる
    - [Painting in AWT and Swing](http://www.oracle.com/technetwork/java/painting-140037.html)
    - [se-ji-cafe翻訳日記 - AwtとSwingにおける描画処理](http://d.hatena.ne.jp/se-ji-cafe/20070306/1173231679)

<!-- dummy comment line for breaking list -->

自前での`Double Buffering`は、[JComboBoxのモデルとしてenumを使用する](http://terai.xrea.jp/Swing/SortingAnimations.html)のアニメーション部分などを参考にしてみてください。
