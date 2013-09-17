---
layout: post
title: JFileChooserのPlacesBarを非表示にする
category: swing
folder: NoPlacesBarFileChooser
tags: [JFileChooser, PlacesBar]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-11-16

## JFileChooserのPlacesBarを非表示にする
`JFileChooser`(`WindowsLookAndFeel`)の`PlacesBar`を非表示にします。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTQZdQnWAI/AAAAAAAAAfg/Cne_bKrk8BU/s800/NoPlacesBarFileChooser.png)

### サンプルコード
<pre class="prettyprint"><code>UIManager.put("FileChooser.noPlacesBar", Boolean.TRUE);
</code></pre>

### 解説
上記のサンプルでは、`WindowsLookAndFeel`で、`JFileChooser`の左に表示される`PlacesBar`を非表示にしています。

### 参考リンク
- [Swing - Disable something -- JFileChooser](https://forums.oracle.com/thread/1354867)

<!-- dummy comment line for breaking list -->

### コメント
