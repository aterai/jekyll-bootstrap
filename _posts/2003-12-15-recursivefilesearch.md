---
layout: post
category: swing
folder: RecursiveFileSearch
title: Fileの再帰的検索
tags: [File, JProgressBar, SwingWorker]
author: aterai
pubdate: 2003-12-15
description: 指定したDirectory以下のFileを再帰的に検索し、その進捗状況をJProgressBarで表示します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTRh7du1II/AAAAAAAAAhU/jcMUoOTcbTU/s800/RecursiveFileSearch.png
comments: true
---
## 概要
指定した`Directory`以下の`File`を再帰的に検索し、その進捗状況を`JProgressBar`で表示します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTRh7du1II/AAAAAAAAAhU/jcMUoOTcbTU/s800/RecursiveFileSearch.png %}

## サンプルコード
<pre class="prettyprint"><code>private void recursiveSearch(File dir, final List&lt;File&gt; list)
        throws InterruptedException {
  for (String fname : dir.list()) {
    if (Thread.interrupted()) {
      throw new InterruptedException();
    }
    File sdir = new File(dir, fname);
    if (sdir.isDirectory()) {
      recursiveSearch(sdir, list);
    } else {
      scount++;
      if (scount % 100 == 0) {
        publish(new Message("Results:" + scount + "\n", false));
      }
      list.add(sdir);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、選択したフォルダ以下のファイルを再帰的にすべて検索して表示しています。`JProgressBar`を使った進捗状況の表示とキャンセルには、`SwingWorker`を利用しています。

- - - -
`JDK 1.7.0`以上の場合は、`Files.walkFileTree(...)`などを使用する方法もあります。

- [Files#walkFileTree(...) (Java Platform SE 7)](http://docs.oracle.com/javase/jp/7/api/java/nio/file/Files.html#walkFileTree%28java.nio.file.Path,%20java.nio.file.FileVisitor%29)
- [Walking the File Tree (The Java™ Tutorials > Essential Classes > Basic I/O)](https://docs.oracle.com/javase/tutorial/essential/io/walk.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private void recursiveSearch(Path dir, final ArrayList&lt;Path&gt; list) throws IOException {
  Files.walkFileTree(dir, new SimpleFileVisitor&lt;Path&gt;() {
    @Override public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
      if (Thread.interrupted()) {
        throw new IOException();
      }
      if (attrs.isRegularFile()) {
        list.add(file);
      }
      return FileVisitResult.CONTINUE;
    }
  });
}
</code></pre>

- - - -
`JDK 1.8.0`以上の場合は、`Files.walk(Path)`を使用する方法もあります。

- [Files#walk(Path) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/nio/file/Files.html#walk-java.nio.file.Path-java.nio.file.FileVisitOption...-)
- [Javaファイル関連メモ2(Hishidama's Java Files Memo)](http://www.ne.jp/asahi/hishidama/home/tech/java/files.html#walk)
- [java - Read all files in a folder - Stack Overflow](http://stackoverflow.com/questions/1844688/read-all-files-in-a-folder)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.util.*;
import java.util.stream.*;
import java.io.IOException;
import java.nio.file.*;
public class FilesWalkTest {
  public static void main(String[] args) {
    Path dir = Paths.get(".");
    //Files.walk(dir).forEach(System.out::println);
    try (Stream&lt;Path&gt; s = Files.walk(dir)
                               .filter(Files::isRegularFile)) {
      List&lt;Path&gt; l = s.collect(Collectors.toList());
      System.out.println(l.size());
    } catch (IOException ex) {
      ex.printStackTrace();
    }
  }
}
</code></pre>

## 参考リンク
- [Java入門 ファイル](http://msugai.fc2web.com/java/IO/fileObj.html)
- [How to Use Progress Bars](https://docs.oracle.com/javase/tutorial/uiswing/components/progress.html)
- [SwingWorker (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/SwingWorker.html)
- [Using a Swing Worker Thread](http://web.archive.org/web/20090830092511/http://java.sun.com/products/jfc/tsc/articles/threads/threads2.html)

<!-- dummy comment line for breaking list -->

## コメント
- 実際に動作するサンプルを追加してみました。 -- *aterai* 2006-04-28 (金) 21:50:55
- `JDK 6`の`SwingWorker`を使用するように変更しました。 -- *aterai* 2008-07-11 (金) 15:32:26

<!-- dummy comment line for breaking list -->
