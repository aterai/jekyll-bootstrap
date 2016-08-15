---
layout: post
category: swing
folder: ClearGlobalFocusOwner
title: GlobalFocusをクリアする
tags: [Focus, KeyboardFocusManager, JFrame]
author: aterai
pubdate: 2010-01-25T13:19:35+09:00
description: GlobalFocusをクリアして、フォーカスをもつコンポーネントがない状態に戻します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTJA-Nc1vI/AAAAAAAAATs/mH0hhS2R1n8/s800/ClearGlobalFocusOwner.png
comments: true
---
## 概要
`GlobalFocus`をクリアして、フォーカスをもつコンポーネントがない状態に戻します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTJA-Nc1vI/AAAAAAAAATs/mH0hhS2R1n8/s800/ClearGlobalFocusOwner.png %}

## サンプルコード
<pre class="prettyprint"><code>KeyboardFocusManager.getCurrentKeyboardFocusManager().clearGlobalFocusOwner();
</code></pre>

## 解説
上記のサンプルでは、`JFrame`をクリックしたときに、`KeyboardFocusManager#clearGlobalFocusOwner()`メソッドを使用して、`GlobalFocus`をクリアしています。

- - - -
`JDK1.8.0`以降の場合は、[KeyboardFocusManager#clearFocusOwner()](http://docs.oracle.com/javase/jp/8/docs/api/java/awt/KeyboardFocusManager.html#clearFocusOwner--)を使用したほうがよさそう？

## 参考リンク
- [KeyboardFocusManager#clearGlobalFocusOwner() (Java Platform SE 8)](http://docs.oracle.com/javase/jp/8/docs/api/java/awt/KeyboardFocusManager.html#clearGlobalFocusOwner--)
- [KeyboardFocusManager#clearFocusOwner() (Java Platform SE 8)](http://docs.oracle.com/javase/jp/8/docs/api/java/awt/KeyboardFocusManager.html#clearFocusOwner--)

<!-- dummy comment line for breaking list -->

## コメント
