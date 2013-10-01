---
layout: post
title: Fileの再帰的検索
category: swing
folder: RecursiveFileSearch
tags: [File, JProgressBar, SwingWorker]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2003-12-15

## Fileの再帰的検索
ファイルを再帰的に検索します。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTRh7du1II/AAAAAAAAAhU/jcMUoOTcbTU/s800/RecursiveFileSearch.png)

### サンプルコード
<pre class="prettyprint"><code>public void recursiveSearch(File dir, final Vector list)
    throws InterruptedException {
  String[] contents = dir.list();
  for(int i=0;i&lt;contents.length;i++) {
    if(Thread.interrupted()) {
      throw new InterruptedException();
    }
    File sdir = new File(dir, contents[i]);
    if(sdir.isDirectory()) {
      recursiveSearch(sdir, list);
    }else if(isGraphicsFile(sdir.getName())) {
      list.add(sdir);
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、選択したフォルダ以下のファイルを再帰的にすべて検索して表示するようになっています。

- - - -
`JProgressBar`を使った進捗状況の表示とキャンセルには、`SwingWorker`を利用しています。

- - - -
`JDK 7`の場合は、`Files.walkFileTree(...)`などを使用する方法もあります。

- [Walking the File Tree (The Java™ Tutorials > Essential Classes > Basic I/O)](http://docs.oracle.com/javase/tutorial/essential/io/walk.html)
- [Files (Java Platform SE 7 )](http://docs.oracle.com/javase/7/docs/api/java/nio/file/Files.html#walkFileTree%28java.nio.file.Path,%20java.nio.file.FileVisitor%29)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private void recursiveSearch(Path dir, final ArrayList&lt;Path&gt; list) throws IOException {
  Files.walkFileTree(dir, new SimpleFileVisitor&lt;Path&gt;() {
    @Override public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
      if(Thread.interrupted()) {
        throw new IOException();
      }
      if(attrs.isRegularFile()) {
        list.add(file);
      }
      return FileVisitResult.CONTINUE;
    }
  });
}
</code></pre>

### 参考リンク
- [Java入門 ファイル](http://msugai.fc2web.com/java/IO/fileObj.html)
- [How to Use Progress Bars](http://docs.oracle.com/javase/tutorial/uiswing/components/progress.html)
- [SwingWorker (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/SwingWorker.html)
- [Using a Swing Worker Thread](http://web.archive.org/web/20090830092511/http://java.sun.com/products/jfc/tsc/articles/threads/threads2.html)
- [SwingWorker.java](http://web.archive.org/web/20090811085550/http://java.sun.com/products/jfc/tsc/articles/threads/src/SwingWorker.java)
- [Customize SwingWorker to improve Swing GUIs](http://www.javaworld.com/javaworld/jw-06-2003/jw-0606-swingworker-p3.html)

<!-- dummy comment line for breaking list -->

### コメント
- 実際に動作するサンプルを追加してみました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-04-28 (金) 21:50:55
- `JDK 6`の`SwingWorker`を使用するように変更しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-07-11 (金) 15:32:26

<!-- dummy comment line for breaking list -->

