---
layout: post
category: swing
folder: AnimatedToolTip
title: JToolTipのアニメーション
tags: [JToolTip, JLabel, Animation, Html]
author: aterai
pubdate: 2007-04-23T09:48:54+09:00
description: JToolTipが表示されたとき、内部のJLabelでアイコンのアニメーションを行う方法をテストします。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTHpat_rFI/AAAAAAAAARg/fzkRLOHGb7I/s800/AnimatedToolTip.png
comments: true
---
## 概要
`JToolTip`が表示されたとき、内部の`JLabel`でアイコンのアニメーションを行う方法をテストします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTHpat_rFI/AAAAAAAAARg/fzkRLOHGb7I/s800/AnimatedToolTip.png %}

## サンプルコード
<pre class="prettyprint"><code>JLabel l3 = new JLabel("Gif Animated ToolTip(html)");
l3.setToolTipText("&lt;html&gt;&lt;img src='" + url + "'&gt;Test3&lt;/html&gt;");
</code></pre>

## 解説
- 上
    - `javax.swing.Timer`を使ってアニメーションを行う`JLabel`を作成し、`JToolTip`にその`JLabel`を追加
    - [Timerでアニメーションするアイコンを作成](https://ateraimemo.com/Swing/AnimeIcon.html)
        
        <pre class="prettyprint"><code>JLabel l1 = new JLabel("Timer Animated ToolTip") {
          @Override public JToolTip createToolTip() {
            JToolTip tip = new AnimatedToolTip(new AnimatedLabel(""));
            tip.setComponent(this);
            return tip;
          }
        };
        l1.setToolTipText("dummy");
</code></pre>
- 中
    - `Animated GIF`ファイルを`JLabel#setIcon(Icon)`で設定し、`JToolTip`にその`JLabel`を追加
        
        <pre class="prettyprint"><code>JLabel l2 = new JLabel("Gif Animated ToolTip") {
          @Override public JToolTip createToolTip() {
            JToolTip tip = new AnimatedToolTip(
                new JLabel("", new ImageIcon(url), SwingConstants.LEFT));
            tip.setComponent(this);
            return tip;
          }
        };
</code></pre>
- 下
    - `Animated GIF`ファイルを`<html>`タグを使って`setToolTipText(...)`メソッドで設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JToolTipにアイコンを表示](https://ateraimemo.com/Swing/ToolTipIcon.html)
- [Timerでアニメーションするアイコンを作成](https://ateraimemo.com/Swing/AnimeIcon.html)
- [TrayIconのアニメーション](https://ateraimemo.com/Swing/AnimatedTrayIcon.html)

<!-- dummy comment line for breaking list -->

## コメント
