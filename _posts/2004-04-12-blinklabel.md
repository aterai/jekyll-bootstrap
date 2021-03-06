---
layout: post
category: swing
folder: BlinkLabel
title: JLabelの文字列を点滅させる
tags: [JLabel, Timer]
author: aterai
pubdate: 2004-04-12T03:14:13+09:00
description: javax.swing.Timerを使って文字列が点滅するJLabelを作成します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTIHWUuKaI/AAAAAAAAASQ/gfrtJsq0Xck/s800/BlinkLabel.png
comments: true
---
## 概要
`javax.swing.Timer`を使って文字列が点滅する`JLabel`を作成します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTIHWUuKaI/AAAAAAAAASQ/gfrtJsq0Xck/s800/BlinkLabel.png %}

## サンプルコード
<pre class="prettyprint"><code>JLabel label = new JLabel();
Timer timer = new Timer(300, e -&gt; {
  label.setText("".equals(label.getText()) ? "!!!Warning!!!" : "");
});
timer.start();
</code></pre>

## 解説
`javax.swing.Timer`を使って、`JLabel`にテキスト文字列と空文字列を交互に設定することで点滅を表現しています。

新しい`java.util.Timer`は汎用的で多くの機能を持っていますが、`Swing`などの`GUI`コンポーネントを更新する場合はアクションが`EDT`(イベント・ディスパッチ・スレッド)で実行される`javax.swing.Timer`を使用します。

## 参考リンク
- [Timer (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/Timer.html)

<!-- dummy comment line for breaking list -->

## コメント
- `Timer`があいまいなら`javax.swing.Timer`で解決 -- *666* 2007-06-22 (金) 11:51:42
    - ですね。 -- *aterai* 2007-06-26 (火) 14:53:53

<!-- dummy comment line for breaking list -->
