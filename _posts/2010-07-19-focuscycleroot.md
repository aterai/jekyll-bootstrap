---
layout: post
category: swing
folder: FocusCycleRoot
title: JPanelをフォーカストラバーサルサイクルのルートにする
tags: [JPanel, Focus, KeyboardFocusManager]
author: aterai
pubdate: 2010-07-19T23:07:24+09:00
description: JPanelがフォーカストラバーサルサイクルのルートになるように設定します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTNCX36INI/AAAAAAAAAaI/xunzBpsDJLk/s800/FocusCycleRoot.png
comments: true
---
## 概要
`JPanel`がフォーカストラバーサルサイクルのルートになるように設定します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTNCX36INI/AAAAAAAAAaI/xunzBpsDJLk/s800/FocusCycleRoot.png %}

## サンプルコード
<pre class="prettyprint"><code>JPanel p1 = new JPanel();
p1.setFocusCycleRoot(true);
p1.add(new JTextField(16));
</code></pre>

## 解説
上記のサンプルでは、各`JPanel`がそれぞれフォーカストラバーサルサイクルのルートコンテナになるように設定しています。

- 左`JPanel`
    - `setFocusCycleRoot(true);`
- 右`JPanel`
    - `setFocusCycleRoot(true);`
    - `setFocusTraversalPolicyProvider(true);`
    - 順方向キーボードトラバーサルとリバースキーボードトラバーサルを入れ替え

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Container#setFocusCycleRoot(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Container.html#setFocusCycleRoot-boolean-)
- [Container#setFocusTraversalPolicyProvider(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Container.html#setFocusTraversalPolicyProvider-boolean-)
- [Focusの移動](https://ateraimemo.com/Swing/FocusTraversal.html)

<!-- dummy comment line for breaking list -->

## コメント
