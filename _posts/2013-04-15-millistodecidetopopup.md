---
layout: post
title: ProgressMonitorがダイアログを表示するまでの待ち時間
category: swing
folder: MillisToDecideToPopup
tags: [ProgressMonitor, SwingWorker, JProgressBar]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-04-15

## 概要
`ProgressMonitor`のダイアログが表示されるまでの待ち時間を設定します。

{% download https://lh6.googleusercontent.com/-R5-8dJERlmk/UWrm3iXBukI/AAAAAAAABpk/i7YjNRcIkpM/s800/MillisToDecideToPopup.png %}

## サンプルコード
<pre class="prettyprint"><code>monitor = new ProgressMonitor(w, "message", "note", 0, 100);
monitor.setMillisToDecideToPopup((int)millisToDecideToPopup.getValue());
monitor.setMillisToPopup((int)millisToPopup.getValue());
</code></pre>

## 解説
- [`ProgressMonitor#setMillisToDecideToPopup(int)`](http://docs.oracle.com/javase/jp/6/api/javax/swing/ProgressMonitor.html#getMillisToDecideToPopup%28%29)
    - `ProgressMonitor`のダイアログを表示するかどうかを決めるまでの待ち時間を設定
    - デフォルト: `500`ミリ秒
    - この待ち時間の間は`ProgressMonitor`のダイアログは表示されない
        - `ProgressMonitor`で使用する`JProgressBar`が`null`でない場合(`ProgressMonitor`を使い回しして`ProgressMonitor#close()`されていないなど)は、無視してダイアログが表示される場合がある
- [`ProgressMonitor#setMillisToPopup(int)`](http://docs.oracle.com/javase/jp/6/api/javax/swing/ProgressMonitor.html#getMillisToPopup%28%29)
    - `ProgressMonitor`のダイアログが表示されるまでの待ち時間を設定
    - デフォルト: `2000`ミリ秒
    - 予想残り時間がこの時間より短い場合、ダイアログは表示されない
        - 予想残り時間は、`JProgressBar`の進捗状況(パーセント)と処理開始からの時間で計算される
    - `ProgressMonitor#getMillisToDecideToPopup()`からの待ち時間ではなく独立している(処理開始からの待ち時間になる)
        - `ProgressMonitor#getMillisToDecideToPopup()`以下の場合は、その直後にダイアログが表示される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [ProgressMonitorで処理の進捗を表示](http://terai.xrea.jp/Swing/ProgressMonitor.html)

<!-- dummy comment line for breaking list -->

## コメント
