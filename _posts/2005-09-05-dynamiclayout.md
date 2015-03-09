---
layout: post
category: swing
folder: DynamicLayout
title: DynamicLayoutでレイアウトの動的評価
tags: [DefaultToolkit, LayoutManager]
author: aterai
pubdate: 2005-09-05T12:06:35+09:00
description: ウィンドウのリサイズなどに応じてレイアウトを再評価するように、DynamicLayoutを設定します。
comments: true
---
## 概要
ウィンドウのリサイズなどに応じてレイアウトを再評価するように、`DynamicLayout`を設定します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTMDyaDeJI/AAAAAAAAAYk/-EIAq3TyJbw/s800/DynamicLayout.png %}

## サンプルコード
<pre class="prettyprint"><code>Toolkit.getDefaultToolkit().setDynamicLayout(true);
</code></pre>

## 解説
上記のサンプルでは、`DynamicLayout`にチェックするとウィンドウのリサイズなどに応じて内部のレイアウトを再評価するように、`DefaultToolkit`の`setDynamicLayout`メソッドを使って`DynamicLayout`の設定をしています。

- - - -
`OS`などが、この機能をサポートしているかどうかは、以下のメソッドで調べることができます。

<pre class="prettyprint"><code>Toolkit.getDefaultToolkit().getDesktopProperty("awt.dynamicLayoutSupported");
</code></pre>

## 参考リンク
- [Toolkit#setDynamicLayout(boolean) (Java Platform SE 8)](http://docs.oracle.com/javase/jp/8/api/docs/java/awt/Toolkit.html#setDynamicLayout-boolean-)

<!-- dummy comment line for breaking list -->

## コメント
