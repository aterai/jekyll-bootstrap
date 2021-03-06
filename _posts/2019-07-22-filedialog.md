---
layout: post
category: swing
folder: FileDialog
title: FileDialogでファイルを選択する
tags: [FileDialog, File]
author: aterai
pubdate: 2019-07-22T16:47:18+09:00
description: FileDialogを使用してファイルを選択します。
image: https://drive.google.com/uc?id=160UZBhnWm9tvyAZVDT76viFOmqNicVDQ
comments: true
---
## 概要
`FileDialog`を使用してファイルを選択します。

{% download https://drive.google.com/uc?id=160UZBhnWm9tvyAZVDT76viFOmqNicVDQ %}

## サンプルコード
<pre class="prettyprint"><code>JButton button1 = new JButton("FileDialog(Frame)");
button1.addActionListener(e -&gt; {
  Frame frame = JOptionPane.getFrameForComponent(this);
  FileDialog fd = new FileDialog(frame, "title");
  fd.setTitle("FileDialog(Frame frame, String title)");
  fd.setDirectory(System.getProperty("user.home"));
  fd.setVisible(true);
  if (fd.getFile() != null) {
    File file = new File(fd.getDirectory(), fd.getFile());
    append(file.getAbsolutePath());
  }
});
</code></pre>

## 解説
- `FileDialog(Frame)`
    - [new FileDialog(Frame frame, String title)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/FileDialog.html#FileDialog-java.awt.Frame-java.lang.String-)で`FileDialog`を作成
    - `FileDialog#setVisible(true)`で`FileDialog`を開く前の場合、`FileDialog#setTitle(...)`でタイトルを変更可能
    - `FileDialog`に`WindowListener`を追加して`windowOpened`後に`FileDialog#setTitle(...)`でタイトル変更は不可
    - `FileDialog#setLocation(...)`などで表示位置の変更は不可
        - 値は変更されるが、実際の表示位置には反映されない
    - `FileDialog`に`WindowListener`は有効だが、`WindowStateListener`は無効？
    - `FileDialog#getFile()`メソッドで選択されたファイルの名前が文字列で取得可能
    - フルパスが必要な場合は`FileDialog#getDirectory()`で親ディレクトリを取得て`new File(String parent, String child)`などで`File`を生成し、`File#getAbsolutePath()`メソッドを使用する
- `FileDialog(Dialog)`
    - [new FileDialog(Dialog dialog, String title)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/FileDialog.html#FileDialog-java.awt.Frame-java.lang.String-)で`FileDialog`を作成
    - `new FileDialog(Frame)`で作成した場合との違いは不明

<!-- dummy comment line for breaking list -->

## 参考リンク
- [FileDialog (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/FileDialog.html)
- [How do I center a java.awt.FileDialog on the screen - Stack Overflow](https://stackoverflow.com/questions/2467180/how-do-i-center-a-java-awt-filedialog-on-the-screen)

<!-- dummy comment line for breaking list -->

## コメント
