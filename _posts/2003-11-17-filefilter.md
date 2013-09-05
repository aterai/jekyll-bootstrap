---
layout: post
title: JFileChooserにファイルフィルタを追加
category: swing
folder: FileFilter
tags: [JFileChooser, FileFilter]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2003-11-17

## JFileChooserにファイルフィルタを追加
`JFileChooser`にファイルフィルタを追加します。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTMc7NJ5UI/AAAAAAAAAZM/p-hliI-ZnLs/s800/FileFilter.png)

### サンプルコード
<pre class="prettyprint"><code>JFileChooser fileChooser = new JFileChooser();
fileChooser.addChoosableFileFilter(new FileFilter() {
  @Override public boolean accept(File file) {
    if(file.isDirectory()) return true;
    return file.getName().toLowerCase().endsWith(".jpg");
  }
  @Override public String getDescription() {
    return "JPEGファイル(*.jpg)";
  }
});
</code></pre>

### 解説
上記のサンプルでは、フィルタを匿名インナークラスで書いていますが、複数のフィルタを追加する場合は、それぞれクラスを作ったほうがすっきり書けるかもしれません。

`addChoosableFileFilter(FileFilter)`メソッドを使うと、そのフィルタが現在選択されているフィルタになります。例えば「すべてのファイル」をデフォルト(選択された状態)に戻したい場合は、以下のようにします。

<pre class="prettyprint"><code>fileChooser.addChoosableFileFilter(myFilter);
fileChooser.setFileFilter(fileChooser.getAcceptAllFileFilter());
</code></pre>

- - - -
`JDK 6`では、新しく`javax.swing.filechooser.FileNameExtensionFilter`クラスが追加されており、拡張子で選択できるファイルフィルタを簡単に作成することが出来ます(参考:[JavaSE6の便利クラス - きしだのはてな](http://d.hatena.ne.jp/nowokay/20070228#1172660818))。

<pre class="prettyprint"><code>//FileNameExtensionFilter(String description, String... extensions)
FileFilter filter = new FileNameExtensionFilter("JPEGファイル(*.jpg)", "jpg", "jpeg");
fileChooser.addChoosableFileFilter(filter);
</code></pre>

上記のように説明の後に、可変長引数で拡張子を複数指定することが可能です。ドットは必要なく、大文字小文字も区別されないようです。

### 参考リンク
- [Bug ID: 6400960 Swing File*Filters should extend java.io.File*Filters](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6400960)

<!-- dummy comment line for breaking list -->

### コメント
- `jpg` → `.jpg` -- [MT](http://terai.xrea.jp/MT.html) 2003-12-24 (水) 12:15:54
    - 直しておきました。どもです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2003-12-24 (水) 12:41:13
- `addChoosableFileFilter`を何度も呼ぶと最後に追加されたものがデフォルトになるが、例えば`2`番目に追加した`filter`を最後に再び追加すると`2`番目がデフォルトになる。 -- [Y](http://terai.xrea.jp/Y.html) 2006-11-27 (月) 15:21:26
    - `addChoosableFileFilter(FileFilter)`は、その`FileFilter`がすでに含まれている場合は、`setFileFilter(FileFilter)`だけ実行するみたいですね。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-11-28 (火) 16:44:40

<!-- dummy comment line for breaking list -->