---
layout: post
category: swing
folder: SystemIcon
title: FileのSystemIconを取得する
tags: [SystemIcon, FileSystemView, ShellFolder]
author: aterai
pubdate: 2008-06-30T17:25:49+09:00
description: ファイル、ディレクトリなどのSystemIconを取得します。
comments: true
---
## 概要
ファイル、ディレクトリなどの`SystemIcon`を取得します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUG6tI4SI/AAAAAAAAAlg/bci1geT80EM/s800/SystemIcon.png %}

## サンプルコード
<pre class="prettyprint"><code>smallLabel.setIcon(FileSystemView.getFileSystemView().getSystemIcon(file));
</code></pre>
<pre class="prettyprint"><code>largeLabel.setIcon(new ImageIcon(ShellFolder.getShellFolder(file).getIcon(true)));
</code></pre>

## 解説
上記のサンプルでは、`Windows`環境でファイルをドロップするとそのファイルの`SystemIcon`を表示することが出来ます。

- `16x16`
    - `FileSystemView#getSystemIcon(File f)`で小さいアイコンを取得

<!-- dummy comment line for breaking list -->

- `32x32`
    - `ShellFolder.getShellFolder(file).getIcon(true)`で大きいアイコンを取得
    - ~~「`sun.awt.shell.ShellFolder` は Sun が所有する `API` であり、今後のリリースで削除される可能性があります。」と警告される~~
    - 「`ShellFolder`は内部所有の`API`であり、今後のリリースで削除される可能性があります」と警告される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Code Beach: Get the File Type Icon with Java](http://blog.codebeach.com/2008/02/get-file-type-icon-with-java.html)

<!-- dummy comment line for breaking list -->

## コメント
