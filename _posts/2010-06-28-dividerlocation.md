---
layout: post
category: swing
folder: DividerLocation
title: JSplitPaneを等分割する
tags: [JSplitPane, Divider]
author: aterai
pubdate: 2010-06-28T22:43:18+09:00
description: JSplitPaneのディバイダが中央にくるように設定します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLR0Z5M_I/AAAAAAAAAXU/R6r6dvVJa9M/s800/DividerLocation.png
comments: true
---
## 概要
`JSplitPane`のディバイダが中央にくるように設定します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLR0Z5M_I/AAAAAAAAAXU/R6r6dvVJa9M/s800/DividerLocation.png %}

## サンプルコード
<pre class="prettyprint"><code>EventQueue.invokeLater(new Runnable() {
  @Override public void run() {
    sp.setDividerLocation(0.5);
    // sp.setResizeWeight(0.5);
  }
});
</code></pre>

## 解説
上記のサンプルの`JSplitPane`は、初期状態でそのディバイダが中央に配置されるよう、`JSplitPane#setDividerLocation(.5);`を設定しています。

- `JFrame#pack()`や`JFrame#setSize(int, int)`などが実行されて親コンポーネントのサイズが決定した後に`JSplitPane#setDividerLocation(...)`メソッドを実行しないと効果がない
- ディバイダ自身の幅(`JSplitPane#getDividerSize()`)は含まれない
- 内部では、切り捨てで`JSplitPane#setDividerLocation(int)`を使用: [JSplitPaneのDividerの位置を最大化後に変更する](https://ateraimemo.com/Swing/DividerSplitRatio.html)
- `JSplitPane#setResizeWeight(double)`を使用し、`JSplitPane`内に配置したコンポーネント(`JScrollPane`)の余ったスペースの配分が同じになるよう設定してディバイダを中央に配置する方法もある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JSplitPane#setDividerLocation(double) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JSplitPane.html#setDividerLocation-double-)
- [JSplitPaneのDividerの位置を最大化後に変更する](https://ateraimemo.com/Swing/DividerSplitRatio.html)

<!-- dummy comment line for breaking list -->

## コメント
