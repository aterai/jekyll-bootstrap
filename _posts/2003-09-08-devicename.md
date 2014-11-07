---
layout: post
category: swing
folder: DeviceName
title: Device Nameのチェック
tags: [File]
author: aterai
pubdate: 2003-09-08
description: ファイルチューザーなどで入力されたファイル名が、デバイスファイル名(con、prn、nul、auxなど)でないかチェックします。
comments: true
---
## 概要
ファイルチューザーなどで入力されたファイル名が、デバイスファイル名(`con`、`prn`、`nul`、`aux`など)でないかチェックします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTKz2LmiiI/AAAAAAAAAWk/HOTsKRHPAVo/s800/DeviceName.png %}

## サンプルコード
<pre class="prettyprint"><code>private boolean isCanonicalPath(File file) {
  if(file==null) return false;
  try{
    if(file.getCanonicalPath()==null) return false;
  }catch(IOException ioe) {
    return false;
  }
  return true;
}
</code></pre>

## 解説
`Windows`環境で、`Device Name`を含むような**正しくないファイルパス**(`c:\con.txt`など)を読み書きしようとすると、`Exception`が発生します。正しいファイルパスかどうかは、`File#getCanonicalPath()`メソッドが`null`を返すかどうかでチェックすることができます。

- 追記: `1.5.0_08`で以下のように修正された
    - [File.isFile() は Windows プラットフォームで "con" に "false" を返すべき](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=6176051)
- [Java SE 6 の拡張機能 - Java I/O の拡張機能](http://docs.oracle.com/javase/jp/6/technotes/guides/io/enhancements.html#6)
    - 引用:「`CON`、`NUL`、`AUX`、`LPT`などの予約されたデバイス名には必ず`false`を返すように、`File.isFile()`の`Windows`実装が変更されました。 以前の戻り値は`true`で、それが`Unix`で使用するデバイスの動作と整合していないことから、対象ユーザーはこれをバグとみなしていました。」

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Windowsパス名の落とし穴](http://www.ipa.go.jp/security/awareness/vendor/programming/b08_01_main.html)

<!-- dummy comment line for breaking list -->

## コメント
