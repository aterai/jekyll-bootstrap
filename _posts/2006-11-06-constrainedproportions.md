---
layout: post
category: swing
folder: ConstrainedProportions
title: JFrameの縦横比を一定にする
tags: [JFrame]
author: aterai
pubdate: 2006-11-06T14:28:33+09:00
description: JFrameの幅と高さの比率が一定になるように制限します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTKJeWlAAI/AAAAAAAAAVg/GMclfo0TYBM/s800/ConstrainedProportions.png
comments: true
---
## 概要
`JFrame`の幅と高さの比率が一定になるように制限します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTKJeWlAAI/AAAAAAAAAVg/GMclfo0TYBM/s800/ConstrainedProportions.png %}

## サンプルコード
<pre class="prettyprint"><code>private static final int MW = 320;
private static final int MH = 200;
//...
frame.addComponentListener(new ComponentAdapter() {
  @Override public void componentResized(ComponentEvent e) {
    int fw = frame.getSize().width;
    int fh = MH * fw / MW;
    frame.setSize(MW &gt; fw ? MW : fw, MH &gt; fh ? MH : fh);
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JFrame`のサイズを変更した後、その幅から縦横比が変更前と同じになるような高さを計算して`JFrame#setSize(int,int)`で設定し直しています。

- 注:
    - 現状`Windows 10` + `JDK 1.8.0_141`の環境では正常に動作していない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JFrameの最小サイズ](http://ateraimemo.com/Swing/MinimumFrame.html)
- [DynamicLayoutでレイアウトの動的評価](http://ateraimemo.com/Swing/DynamicLayout.html)

<!-- dummy comment line for breaking list -->

## コメント
- これはドラッグ中は自由なサイズでボタンを離したときにサイズが正しく変更されます。ドラッグ中も正しい比率になるのは無理でしょうか？ --  2007-11-10 (土) 00:17:13
    - ども。今の`Java`だけだと難しいかもしれません。すこし調べてみます。 -- *aterai* 2007-11-12 (月) 11:45:22

<!-- dummy comment line for breaking list -->
