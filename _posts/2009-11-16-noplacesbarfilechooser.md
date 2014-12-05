---
layout: post
category: swing
folder: NoPlacesBarFileChooser
title: JFileChooserのPlacesBarを非表示にする
tags: [JFileChooser, PlacesBar]
author: aterai
pubdate: 2009-11-16T19:20:02+09:00
description: JFileChooser(WindowsLookAndFeel)のPlacesBarを非表示にします。
comments: true
---
## 概要
`JFileChooser`(`WindowsLookAndFeel`)の`PlacesBar`を非表示にします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTQZdQnWAI/AAAAAAAAAfg/Cne_bKrk8BU/s800/NoPlacesBarFileChooser.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("FileChooser.noPlacesBar", Boolean.TRUE);
</code></pre>

## 解説
上記のサンプルでは、`WindowsLookAndFeel`で、`JFileChooser`の左に表示される`PlacesBar`を非表示にしています。

## 参考リンク
- [Swing - Disable something -- JFileChooser](https://community.oracle.com/thread/1354867)

<!-- dummy comment line for breaking list -->

## コメント
