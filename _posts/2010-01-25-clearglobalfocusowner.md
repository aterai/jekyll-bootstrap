---
layout: post
title: GlobalFocusをクリアする
category: swing
folder: ClearGlobalFocusOwner
tags: [Focus, KeyboardFocusManager, JFrame]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-01-25

## 概要
`GlobalFocus`をクリアして、フォーカスをもつコンポーネントがない状態に戻します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTJA-Nc1vI/AAAAAAAAATs/mH0hhS2R1n8/s800/ClearGlobalFocusOwner.png %}

## サンプルコード
<pre class="prettyprint"><code>KeyboardFocusManager.getCurrentKeyboardFocusManager().clearGlobalFocusOwner();
</code></pre>

## 解説
上記のサンプルでは、`JFrame`をクリックしたときに、`KeyboardFocusManager#clearGlobalFocusOwner()`メソッドを使用して、`GlobalFocus`をクリアしています。

## コメント
