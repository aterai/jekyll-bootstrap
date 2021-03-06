---
layout: post
category: swing
folder: ROFileChooser
title: JFileChooserを編集不可にする
tags: [JFileChooser, UIManager]
author: aterai
pubdate: 2005-05-16T06:02:26+09:00
description: JFileChooser内でのファイル名変更や新規フォルダ作成などの編集を不可にします。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTR_zuU1UI/AAAAAAAAAiE/nZgj97xKO24/s800/ROFileChooser.png
comments: true
---
## 概要
`JFileChooser`内でのファイル名変更や新規フォルダ作成などの編集を不可にします。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTR_zuU1UI/AAAAAAAAAiE/nZgj97xKO24/s800/ROFileChooser.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("FileChooser.readOnly", Boolean.TRUE);
</code></pre>

## 解説
`JDK 1.5.0`以上で`UIManager.put("FileChooser.readOnly", Boolean.TRUE);`を設定すると、`JFileChooser`がリードオンリーになり、ファイル名の変更や新規フォルダの作成などが禁止されます。

## 参考リンク
- [Swing - disabling "rename" on JFileChooser](https://community.oracle.com/thread/1377535)
- [JFileChooserで読み取り専用ファイルのリネームを禁止](https://ateraimemo.com/Swing/RenameIfCanWriteFileChooser.html)
- [&#91;JDK-8021379&#93; JFileChooser Create New Folder button enabled in write proteced directory - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8021379)
    - `Java 8`で修正済み

<!-- dummy comment line for breaking list -->

## コメント
