---
layout: post
title: ClassLoaderでリソース(URL)を取得
category: swing
folder: ClassLoader
tags: [ClassLoader, Resource, URL]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-05-22

## ClassLoaderでリソース(URL)を取得
クラスパスからのエントリ(相対パス風)を使って、`ClassLoader`から`URL`を取得します。


{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTI-UTFN-I/AAAAAAAAATo/6sdQoVO0Kc4/s800/ClassLoader.png %}

### サンプルコード
<pre class="prettyprint"><code>URL url = getClass().getClassLoader().getResource("example/test.png");
//URL url = getClass().getResource("test.png");
JLabel icon = new JLabel(new ImageIcon(url));
JLabel path = new JLabel(url.toString());
</code></pre>

### 解説
`ClassLoader`を使用して、位置に依存しない方法でリソース(`URL`)を取得します。

- 例えば`new ImageIcon(String filename)`のようにファイルパスを文字列で指定した場合、このファイルパスが位置(カレントディレクトリ)に依存しているため、実行時にカレントディレクトリを変更したり、`jar`ファイルにまとめたりするとファイルが参照できなくなります。

<!-- dummy comment line for breaking list -->

以下、`.\target\classes\example\test.png`にある画像ファイルの`URL`をクラスパスからのエントリ(相対パス風)を使って取得する場合を考えます。

上記のサンプルに添付しているバッチファイルでは、クラスパスは次のように設定しています。
	java -classpath ".\target\classes" example.MainPanel

`ClassLoader#getResource`メソッドを使用する場合は、以下のようにクラスパスからのエントリを使用します。このエントリは、相対パス風で頭に`/`は付けず、`/`区切りで記述します。

<pre class="prettyprint"><code>getClass().getClassLoader().getResource("example/test.png");
//ただし、getClass().getClassLoader().getResource("./example/test.png");
//だとjar内にパッケージした時うまくいかない。
</code></pre>

- - - -
`ClassLoader`からでは無く、`Class#getResource`メソッドを使う方法もあります。この場合、エントリ名がメソッド内で以下のように変換されます。

- 相対パス風(頭に/が付かない)の場合
    - `.`が`/`に変換された、`modified_package_name`が名前の前に補完される
    - 例えば、`com.example.Test`クラスなら、`com/example/`
    - このサンプルでは`example.MainPanel`クラスなので、`example/`が補完されて、`example/test.png`になる

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>getClass().getResource("test.png"); //or MainPanel.class.getResource("test.png");
//getClass().getClassLoader().getResource("example/test.png");と同じ
</code></pre>

- 絶対パス風(頭に`/`が付く)の場合
    - `modified_package_name`は補完せず、頭の`/`は削除される

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>getClass().getResource("/test.png");
//getClass().getClassLoader().getResource("test.png");と同じ
//上記の相対パスと同じリソースを取得する場合は、
//getClass().getResource("/example/test.png");としなくてはならない
</code></pre>

- - - -
クラスパス上に同名のリソースが複数存在する場合は、最初に見つかったものが使用されます。

- `src.zip`をダウンロードして適当な場所に展開する
- `c:\temp\example\test.png`という画像ファイルを別途用意する
- 展開したフォルダにある`run.bat`の`6`行目(クラスパス)を以下のように変更

<!-- dummy comment line for breaking list -->

	set LOCALCLASSPATH=c:\temp;.\target\classes

- `ant`などでコンパイルして、修正した`run.bat`で実行

<!-- dummy comment line for breaking list -->

この場合、`src.zip`に元々入っていた`適当な場所/test.png`ではなく、`file:/C:/temp/example/test.png`という`URL`が`getResource`で取得できます。

### 参考リンク
- [位置に依存しない方法でのリソースへのアクセス](http://docs.oracle.com/javase/jp/6/technotes/guides/lang/resources.html)
- [Loading Images Using getResource](http://docs.oracle.com/javase/tutorial/uiswing/components/icon.html#getresource)

<!-- dummy comment line for breaking list -->

### コメント
- 「クラスパスからのパス」などの意味が分かり辛いので、[JarURLConnection (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/java/net/JarURLConnection.html)を参考にして「パス」を「エントリ」に変更してみました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-02-15 (金) 18:04:14
- `.jar`ファイルのクラスで -- [kind](http://terai.xrea.jp/kind.html) 2012-03-02 (金) 14:04:06
    - 見落としてました。最近なんか重いので途切れてしまったのでしょうか。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-03-05 (月) 16:26:35

<!-- dummy comment line for breaking list -->

