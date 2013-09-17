---
layout: post
title: JProgressBarの不確定進捗サイクル時間を設定
category: swing
folder: IndeterminateCycleTime
tags: [JProgressBar, UIManager]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-07-15

## JProgressBarの不確定進捗サイクル時間を設定
`JProgressBar`の不確定進捗状態アニメーションで使用するサイクル時間などを設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/--xwJeUKsm8k/UeK6iFE0vkI/AAAAAAAABvw/SNNt1mvM4_c/s800/IndeterminateCycleTime.png)

### サンプルコード
<pre class="prettyprint"><code>UIManager.put("ProgressBar.repaintInterval", (Integer)repaintIntervalSpinner.getValue());
UIManager.put("ProgressBar.cycleTime",       (Integer)cycleTimeSpinner.getValue());
progressBar.setIndeterminate(true);
</code></pre>

### 解説
上記のサンプルでは、`UIManager`を使って`JProgressBar`の不確定進捗のアニメーションで使用するサイクル時間と再ペイント間隔をミリ秒で指定しています。

- サイクル時間
    - `UIManager.put("ProgressBar.cycleTime", 1000);`
- 再ペイント間隔
    - `UIManager.put("ProgressBar.repaintInterval", 10);`

<!-- dummy comment line for breaking list -->

- 注
    - サイクル時間が再ペイント間隔の偶数倍でない場合、サイクル時間は自動的にそうなるように増加する
    - `WindowsLookAndFeel`などの場合、`JProgressBar#setIndeterminate(true);`が実行されたときに、これらの値は更新される

<!-- dummy comment line for breaking list -->

### 参考リンク
- [不確定進捗バー - Java™ 2 SDK, Standard Edition, v 1.4 での Swing の変更点および新機能](http://docs.oracle.com/javase/jp/7/technotes/guides/swing/1.4/pb.html)

<!-- dummy comment line for breaking list -->

### コメント
