---
layout: post
category: swing
folder: SystemIcon
title: FileのSystemIconを取得する
tags: [SystemIcon, FileSystemView, ShellFolder]
author: aterai
pubdate: 2008-06-30T17:25:49+09:00
description: ファイル、ディレクトリなどのSystemIconを取得します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUG6tI4SI/AAAAAAAAAlg/bci1geT80EM/s800/SystemIcon.png
comments: true
---
## 概要
ファイル、ディレクトリなどの`SystemIcon`を取得します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUG6tI4SI/AAAAAAAAAlg/bci1geT80EM/s800/SystemIcon.png %}

## サンプルコード
<pre class="prettyprint"><code>// 16x16
smallLabel.setIcon(FileSystemView.getFileSystemView().getSystemIcon(file));
// 32x32
largeLabel.setIcon(new ImageIcon(ShellFolder.getShellFolder(file).getIcon(true)));
</code></pre>

## 解説
上記のサンプルでは、`Windows`環境などからファイルをドロップするとそのファイルの`SystemIcon`を表示できます。

- `16x16`
    - `FileSystemView#getSystemIcon(File)`メソッドで小さいアイコンを取得
- `32x32`
    - `ShellFolder.getShellFolder(file).getIcon(true)`で大きいアイコンを取得
    - コンパイル時に「`ShellFolder`は内部所有の`API`であり、今後のリリースで削除される可能性があります」と警告される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [FileSystemView#getSystemIcon(File) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/filechooser/FileSystemView.html#getSystemIcon-java.io.File-)
- [Code Beach: Get the File Type Icon with Java](http://blog.codebeach.com/2008/02/get-file-type-icon-with-java.html)

<!-- dummy comment line for breaking list -->

## コメント
