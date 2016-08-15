---
layout: post
category: swing
folder: NoPlacesBarFileChooser
title: JFileChooserのPlacesBarを非表示にする
tags: [JFileChooser, PlacesBar]
author: aterai
pubdate: 2009-11-16T19:20:02+09:00
description: JFileChooser(WindowsLookAndFeel)のPlacesBarを非表示にします。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTQZdQnWAI/AAAAAAAAAfg/Cne_bKrk8BU/s800/NoPlacesBarFileChooser.png
comments: true
---
## 概要
`JFileChooser`(`WindowsLookAndFeel`)の`PlacesBar`を非表示にします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTQZdQnWAI/AAAAAAAAAfg/Cne_bKrk8BU/s800/NoPlacesBarFileChooser.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("FileChooser.noPlacesBar", Boolean.TRUE);
</code></pre>

## 解説
上記のサンプルでは、`PlacesBar`(`WindowsLookAndFeel`を使用している場合の`JFileChooser`で左側に表示されるパネル)が非表示になるように、`UIManager.put("FileChooser.noPlacesBar", Boolean.TRUE);`を使用しています。

`WindowsLookAndFeel`以外の`JFileChooser`場合、`FileChooser.noPlacesBar`の指定は無視されます。

## 参考リンク
- [Swing - Disable something -- JFileChooser](https://community.oracle.com/thread/1354867)

<!-- dummy comment line for breaking list -->

## コメント
