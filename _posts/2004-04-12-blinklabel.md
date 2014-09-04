---
layout: post
title: JLabelの文字列を点滅させる
category: swing
folder: BlinkLabel
tags: [JLabel, Timer]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-04-12

## 概要
`javax.swing.Timer`を使って文字列が点滅する`JLabel`を作成します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTIHWUuKaI/AAAAAAAAASQ/gfrtJsq0Xck/s800/BlinkLabel.png %}

## サンプルコード
<pre class="prettyprint"><code>final JLabel label = new JLabel();
Timer timer = new Timer(600, new ActionListener() {
  private boolean flg = true;
  @Override public void actionPerformed(ActionEvent e) {
    flg ^= true;
    label.setText(flg ? "!!!Warning!!!" : "");
  }
});
timer.start();
</code></pre>

## 解説
`javax.swing.Timer`を使って、ラベルのテキスト文字列と空文字列を交互に表示しています。点滅の間隔や、文字列の色を変えたりして実験してみてください。

## コメント
- `Timer`があいまいなら`javax.swing.Timer`で解決 -- [666](http://terai.xrea.jp/666.html) 2007-06-22 (金) 11:51:42
    - ですね。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-06-26 (火) 14:53:53

<!-- dummy comment line for breaking list -->

