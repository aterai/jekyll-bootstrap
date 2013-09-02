---
layout: post
title: GlobalFocusをクリアする
category: swing
folder: ClearGlobalFocusOwner
tags: [Focus, KeyboardFocusManager, JFrame]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-01-25

## GlobalFocusをクリアする
`GlobalFocus`をクリアして、フォーカスをもつコンポーネントがない状態に戻します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTJA-Nc1vI/AAAAAAAAATs/mH0hhS2R1n8/s800/ClearGlobalFocusOwner.png)

### サンプルコード
<pre class="prettyprint"><code>KeyboardFocusManager.getCurrentKeyboardFocusManager().clearGlobalFocusOwner();
</code></pre>

### 解説
上記のサンプルでは、`JFrame`をクリックしたときに、`KeyboardFocusManager#clearGlobalFocusOwner()`メソッドを使用して、`GlobalFocus`をクリアしています。

### コメント
