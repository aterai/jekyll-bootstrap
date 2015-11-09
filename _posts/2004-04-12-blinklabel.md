---
layout: post
category: swing
folder: BlinkLabel
title: JLabelの文字列を点滅させる
tags: [JLabel, Timer]
author: aterai
pubdate: 2004-04-12
description: javax.swing.Timerを使って文字列が点滅するJLabelを作成します。
comments: true
---
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
`javax.swing.Timer`を使って、`JLabel`にテキスト文字列と空文字列を交互に設定することで点滅を表現しています。

## コメント
- `Timer`があいまいなら`javax.swing.Timer`で解決 -- *666* 2007-06-22 (金) 11:51:42
    - ですね。 -- *aterai* 2007-06-26 (火) 14:53:53

<!-- dummy comment line for breaking list -->
