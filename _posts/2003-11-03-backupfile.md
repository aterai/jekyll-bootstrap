---
layout: post
category: swing
folder: BackupFile
title: Backup Fileを番号付きで作成
tags: [File]
author: aterai
pubdate: 2003-11-03T02:48:53+09:00
description: 拡張子に番号を付けたバックアップファイルを作成します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTH9enrSII/AAAAAAAAASA/du4XRgNsIZs/s800/BackupFile.png
comments: true
---
## 概要
拡張子に番号を付けたバックアップファイルを作成します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTH9enrSII/AAAAAAAAASA/du4XRgNsIZs/s800/BackupFile.png %}

## サンプルコード
<pre class="prettyprint"><code>private File makeBackupFile(File file, int intold, int intnew) {
  File testFile = null;
  String newfilename = file.getAbsolutePath();
  if (intold == 0 &amp;&amp; intnew == 0) {
    file.delete();
    return new File(newfilename);
  }
  boolean testFileFlag = false;
  for (int i = 1; i &lt;= intold; i++) {
    testFile = new File(file.getParentFile(), file.getName() + "." + i + "~");
    if (!testFile.exists()) {
      testFileFlag = true;
      break;
    }
  }
  if (!testFileFlag) {
    for (int i = intold + 1; i &lt;= intold + intnew; i++) {
      testFile = new File(file.getParentFile(), file.getName() + "." + i + "~");
      if (!testFile.exists()) {
        testFileFlag = true;
        break;
      }
    }
  }
  if (testFileFlag) {
    System.out.println("createBKUP1" + testFile.getAbsolutePath());
    file.renameTo(testFile);
  } else {
    File tmpFile3 = new File(file.getParentFile(),
                             file.getName() + "." + (intold + 1) + "~");
    tmpFile3.delete();
    for (int i = intold + 2; i &lt;= intold + intnew; i++) {
      File tmpFile1 = new File(file.getParentFile(),
                               file.getName() + "." + i + "~");
      File tmpFile2 = new File(file.getParentFile(),
                               file.getName() + "." + (i - 1) + "~");
      tmpFile1.renameTo(tmpFile2);
    }
    File tmpFile = new File(file.getParentFile(),
                            file.getName() + "." + (intold + intnew) + "~");
    System.out.println("changeBKUP2" + tmpFile.getAbsolutePath());
    file.renameTo(tmpFile);
  }
  // System.out.println(newfilename);
  return new File(newfilename);
}
</code></pre>

## 解説
上記のサンプルでは、`xyzzy`風の番号付きバックアップファイル作成のテストを行っています。

以下の例では、古いバージョンを`2`つ、新しいバージョンを`3`つバックアップとして残します。

- `tmp.foo.1~`から`tmp.foo.5~`が残る
- `tmp.foo.1~`がもっとも古いバージョンのファイルになる

<!-- dummy comment line for breaking list -->

バックアップファイルが`5`個以上になった場合、古い方のバージョン`2`つはそのまま残し、新しいバージョンをずらしてバックアップが更新されます。

- `tmp.foo.1~`, `tmp.foo.2~`は残る
- `tmp.foo.3~`は削除
- `tmp.foo.4~`は`tmp.foo.3~`にリネーム
- `tmp.foo.5~`は`tmp.foo.4~`にリネーム
- `tmp.foo.5~`が新にバックアップとして生成

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>File tmpFile = File.createTempFile("tmp", ".foo~", file.getParentFile());
File file = makeBackupFile(file, 2, 3);
tmpFile.renameTo(file);
</code></pre>

## 参考リンク
- [File#createTempFile(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/io/File.html#createTempFile-java.lang.String-java.lang.String-java.io.File-)

<!-- dummy comment line for breaking list -->

## コメント
