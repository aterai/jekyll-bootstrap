---
layout: post
title: JFileChooserを編集不可にする
category: swing
folder: ROFileChooser
tags: [JFileChooser, UIManager]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-05-16

## JFileChooserを編集不可にする
`JFileChooser`内でのファイル名変更や新規フォルダ作成などの編集を不可にします。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTR_zuU1UI/AAAAAAAAAiE/nZgj97xKO24/s800/ROFileChooser.png)

### サンプルコード
<pre class="prettyprint"><code>UIManager.put("FileChooser.readOnly", Boolean.TRUE);
</code></pre>

### 解説
`JDK 1.5.0`以上の場合、`UIManager.put("FileChooser.readOnly", Boolean.TRUE)`とすることで、簡単に`JFileChooser`でのファイル名の変更や新規フォルダの作成を禁止することができます。

### 参考リンク
- [Swing - disabling "rename" on JFileChooser](https://forums.oracle.com/thread/1377535)

<!-- dummy comment line for breaking list -->

### コメント
