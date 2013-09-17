---
layout: post
title: FileのSystemIconを取得する
category: swing
folder: SystemIcon
tags: [SystemIcon, FileSystemView, ShellFolder]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-06-30

## FileのSystemIconを取得する
ファイル、ディレクトリなどの`SystemIcon`を取得します。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUG6tI4SI/AAAAAAAAAlg/bci1geT80EM/s800/SystemIcon.png)

### サンプルコード
<pre class="prettyprint"><code>smallLabel.setIcon(FileSystemView.getFileSystemView().getSystemIcon(file));
</code></pre>
<pre class="prettyprint"><code>largeLabel.setIcon(new ImageIcon(ShellFolder.getShellFolder(file).getIcon(true)));
</code></pre>

### 解説
上記のサンプルでは、`Windows`環境でファイルをドロップするとそのファイルの`SystemIcon`を表示することが出来ます。

- `16x16`
    - `FileSystemView#getSystemIcon(File f)`で小さいアイコンを取得

<!-- dummy comment line for breaking list -->

- `32x32`
    - `ShellFolder.getShellFolder(file).getIcon(true)`で大きいアイコンを取得
    - ~~「`sun.awt.shell.ShellFolder` は Sun が所有する `API` であり、今後のリリースで削除される可能性があります。」と警告される~~
    - 「`ShellFolder`は内部所有の`API`であり、今後のリリースで削除される可能性があります」と警告される

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Code Beach: Get the File Type Icon with Java](http://blog.codebeach.com/2008/02/get-file-type-icon-with-java.html)

<!-- dummy comment line for breaking list -->

### コメント
