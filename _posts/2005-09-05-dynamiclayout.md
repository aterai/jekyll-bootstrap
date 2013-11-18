---
layout: post
title: DynamicLayoutでレイアウトの動的評価
category: swing
folder: DynamicLayout
tags: [DefaultToolkit, LayoutManager]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-09-05

## DynamicLayoutでレイアウトの動的評価
ウインドウのリサイズなどに応じてレイアウトを再評価するように、`DynamicLayout`を設定します。

{% download %}

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTMDyaDeJI/AAAAAAAAAYk/-EIAq3TyJbw/s800/DynamicLayout.png)

### サンプルコード
<pre class="prettyprint"><code>Toolkit.getDefaultToolkit().setDynamicLayout(true);
</code></pre>

### 解説
上記のサンプルでは、`DynamicLayout`にチェックするとウインドウのリサイズなどに応じて内部のレイアウトを再評価するように、`DefaultToolkit`の`setDynamicLayout`メソッドを使って`DynamicLayout`の設定をしています。

- - - -
`OS`などが、この機能をサポートしているかどうかは、以下のメソッドで調べることができます。

<pre class="prettyprint"><code>Toolkit.getDefaultToolkit().getDesktopProperty("awt.dynamicLayoutSupported");
</code></pre>

### 参考リンク
- [Toolkit (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/java/awt/Toolkit.html#setDynamicLayout%28boolean%29)

<!-- dummy comment line for breaking list -->

### コメント
