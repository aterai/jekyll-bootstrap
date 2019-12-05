---
layout: post
category: swing
folder: FileFilter
title: JFileChooserにファイルフィルタを追加
tags: [JFileChooser, FileFilter]
author: aterai
pubdate: 2003-11-17
description: JFileChooserにファイルフィルタを追加します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMc7NJ5UI/AAAAAAAAAZM/p-hliI-ZnLs/s800/FileFilter.png
comments: true
---
## 概要
`JFileChooser`にファイルフィルタを追加します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMc7NJ5UI/AAAAAAAAAZM/p-hliI-ZnLs/s800/FileFilter.png %}

## サンプルコード
<pre class="prettyprint"><code>JFileChooser fileChooser = new JFileChooser();
fileChooser.addChoosableFileFilter(new FileFilter() {
  @Override public boolean accept(File file) {
    if (file.isDirectory()) {
      return true;
    }
    return file.getName().toLowerCase(Locale.ENGLISH).endsWith(".jpg");
  }

  @Override public String getDescription() {
    return "JPEGファイル(*.jpg)";
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JFileChooser#addChoosableFileFilter(FileFilter)`メソッドを使用して拡張子がたとえば`.jpg`のファイルのみを表示する`FileFilter`を追加設定しています。

- - - -
- ~~`addChoosableFileFilter(FileFilter)`メソッドを使うと、そのフィルタが現在選択されているフィルタになります。例えば「すべてのファイル」をデフォルト(選択された状態)に戻したい場合は、`JFileChooser#getAcceptAllFileFilter()`を再設定する~~ -
- `JDK 7`から`JFileChooser#addChoosableFileFilter(...)`内で`JFileChooser#setFileFilter(...)`を呼ばなくなった
    - [JDK-4776197 JFileChooser has an easy-to-fix but serious performance bug - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-4776197)

<!-- dummy comment line for breaking list -->

- - - -
- `java.awt.FileDialog`は以下のように`java.io.FilenameFilter`を使用する
    - [FileDialog#setFilenameFilter(FilenameFilter) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/FileDialog.html#setFilenameFilter-java.io.FilenameFilter-)
    - `JFileChooser`に`java.io.FilenameFilter`は設定不可

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>FileDialog fd = new FileDialog(frame, "title");
FilenameFilter filter = (dir, file) -&gt; file.toLowerCase(Locale.ENGLISH).endsWith(".jpg");
fd.setFilenameFilter(filter);
</code></pre>

- - - -
- `JDK 6`では、新しく[javax.swing.filechooser.FileNameExtensionFilter](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/filechooser/FileNameExtensionFilter.html)クラスが追加された
    - [JavaSE6の便利クラス - きしだのはてな](http://d.hatena.ne.jp/nowokay/20070228#1172660818)
    - 説明の後に可変長引数で拡張子を複数指定可能
    - 拡張子に`.`ドットは不要で、大文字小文字も区別しない

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>// FileNameExtensionFilter(String description, String... extensions)
FileFilter filter = new FileNameExtensionFilter("JPEGファイル(*.jpg)", "jpg", "jpeg");
fileChooser.addChoosableFileFilter(filter);
</code></pre>

## 参考リンク
- [JFileChooser#addChoosableFileFilter(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JFileChooser.html#addChoosableFileFilter-javax.swing.filechooser.FileFilter-)
- [Bug ID: 6400960 Swing File*Filters should extend java.io.File*Filters](https://bugs.openjdk.java.net/browse/JDK-6400960)
- [JDK-4776197 JFileChooser has an easy-to-fix but serious performance bug - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-4776197)

<!-- dummy comment line for breaking list -->

## コメント
- `jpg` → `.jpg` -- *MT* 2003-12-24 (水) 12:15:54
    - 直しておきました。どもです。 -- *aterai* 2003-12-24 (水) 12:41:13
- `addChoosableFileFilter`を何度も呼ぶと最後に追加されたものがデフォルトになるが、例えば`2`番目に追加した`filter`を最後に再び追加すると`2`番目がデフォルトになる。 -- *Y* 2006-11-27 (月) 15:21:26
    - `addChoosableFileFilter(FileFilter)`は、その`FileFilter`がすでに含まれている場合は、`setFileFilter(FileFilter)`だけ実行するみたいですね。 -- *aterai* 2006-11-28 (火) 16:44:40
    - 追記: [JDK-4776197 JFileChooser has an easy-to-fix but serious performance bug - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-4776197)で、この動作は修正されたようです。 -- *aterai* 2018-03-13 (火) 20:46:52

<!-- dummy comment line for breaking list -->
