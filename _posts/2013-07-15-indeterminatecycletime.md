---
layout: post
category: swing
folder: IndeterminateCycleTime
title: JProgressBarの不確定進捗サイクル時間を設定
tags: [JProgressBar, UIManager]
author: aterai
pubdate: 2013-07-15T00:07:35+09:00
description: JProgressBarの不確定進捗状態アニメーションで使用するサイクル時間などを設定します。
image: https://lh3.googleusercontent.com/--xwJeUKsm8k/UeK6iFE0vkI/AAAAAAAABvw/SNNt1mvM4_c/s800/IndeterminateCycleTime.png
comments: true
---
## 概要
`JProgressBar`の不確定進捗状態アニメーションで使用するサイクル時間などを設定します。

{% download https://lh3.googleusercontent.com/--xwJeUKsm8k/UeK6iFE0vkI/AAAAAAAABvw/SNNt1mvM4_c/s800/IndeterminateCycleTime.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("ProgressBar.repaintInterval", (Integer) repaintIntervalSpinner.getValue());
UIManager.put("ProgressBar.cycleTime", (Integer) cycleTimeSpinner.getValue());
progressBar.setIndeterminate(true);
</code></pre>

## 解説
上記のサンプルでは、`UIManager`を使って`JProgressBar`の不確定進捗のアニメーションで使用するサイクル時間と再ペイント間隔をミリ秒で指定しています。

- サイクル時間: `ProgressBar.cycleTime`
    - `UIManager.put("ProgressBar.cycleTime", 1000)`
- 再ペイント間隔: `ProgressBar.repaintInterval`
    - `UIManager.put("ProgressBar.repaintInterval", 10)`
- 注:
    - サイクル時間が再ペイント間隔の偶数倍でない場合、サイクル時間は自動的にそうなるように増加する
    - `WindowsLookAndFeel`などの場合、`JProgressBar#setIndeterminate(true)`が実行されるタイミングでこれらの値は更新される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [不確定進捗バーのサポート](https://docs.oracle.com/javase/jp/8/docs/technotes/guides/swing/1.4/pb.html)
    - via: [Java™ 2 SDK, Standard Edition, v 1.4 での Swing の変更点および新機能](https://docs.oracle.com/javase/jp/8/docs/technotes/guides/swing/1.4/SwingChanges.html)

<!-- dummy comment line for breaking list -->

## コメント
