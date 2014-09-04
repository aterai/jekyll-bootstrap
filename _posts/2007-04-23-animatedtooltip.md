---
layout: post
title: JToolTipのアニメーション
category: swing
folder: AnimatedToolTip
tags: [JToolTip, Animation, Html]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-04-23

## 概要
ツールチップにアニメーションするアイコンを使用します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTHpat_rFI/AAAAAAAAARg/fzkRLOHGb7I/s800/AnimatedToolTip.png %}

## サンプルコード
<pre class="prettyprint"><code>JLabel l3 = new JLabel("Gif Animated ToolTip(html)");
l3.setToolTipText("&lt;html&gt;&lt;img src='"+url+"'&gt;Test3&lt;/html&gt;");
</code></pre>

## 解説
- 上
    - `javax.swing.Timer`を使ってアニメーションするラベルを使用しています。

<!-- dummy comment line for breaking list -->

- 中
    - アニメ`GIF`ファイルをアイコンとして使用しています。

<!-- dummy comment line for breaking list -->

- 下
    - アニメ`GIF`ファイルを`html`タグを使って貼り付けています。

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JToolTipにアイコンを表示](http://terai.xrea.jp/Swing/ToolTipIcon.html)
- [Timerでアニメーションするアイコンを作成](http://terai.xrea.jp/Swing/AnimeIcon.html)
- [TrayIconのアニメーション](http://terai.xrea.jp/Swing/AnimatedTrayIcon.html)

<!-- dummy comment line for breaking list -->

## コメント
