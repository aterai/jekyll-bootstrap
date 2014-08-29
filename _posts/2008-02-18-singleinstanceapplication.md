---
layout: post
title: ServerSocketを使ってアプリケーションの複数起動を禁止
category: swing
folder: SingleInstanceApplication
tags: [ServerSocket, SingleInstance]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-02-18

## ServerSocketを使ってアプリケーションの複数起動を禁止
`ServerSocket`を使ってポートをロック代わりに使用し、アプリケーションの複数起動を禁止します。[Java Swing Hacks #68 単一インスタンスのアプリケーションを作る](http://www.oreilly.co.jp/books/4873112788/toc.html) を参考にしています。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTTF6N0NjI/AAAAAAAAAj0/Ld2Nyv4QXsI/s800/SingleInstanceApplication.png %}

### サンプルコード
<pre class="prettyprint"><code>ServerSocket socket = null;
try {
  socket = new ServerSocket(38765);
}catch(IOException e) {
  socket = null;
}
if(socket==null) {
  JOptionPane.showMessageDialog(null, "An instance of the application is already running...");
  return;
}
</code></pre>

### 解説
`Java Swing Hacks #68`で紹介されている、ポートをロック代わりに使用する方法(任意のポートにバインドできるアプリケーションは一つだけ)で、起動できるアプリケーションを一つに制限しています。

上記のサンプルでは、警告ダイアログを表示して二番目のアプリケーションは終了するだけですが、`#68`のサンプルでは、ポートへの接続要求が来るまで待機し、要求が発生するとソケット入力ストリームを開いて、コマンドラインオプションを取得する例(タブブラウザなどのように既に起動しているアプリケーションで別のコンテンツを開く場合に使用する)も記述されています。

- - - -
以下のように、ポートを使用せずに`JDK 6`にある`Attach API`を使ったり、ロックファイルを使用して起動するアプリケーションの数を制御する方法もあります。

- 参考
    - [PseudoFileSemaphore (アプリケーションのインスタンス数を制御するには-その3) - KazzzのJとNのはざまで](http://d.hatena.ne.jp/Kazzz/20071218/p1)
    - [Attach API (アプリケーションのインスタンス数を制御するには-その4) - KazzzのJとNのはざまで](http://d.hatena.ne.jp/Kazzz/20071221/p1)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Java Swing Hacks #68 単一インスタンスのアプリケーションを作る](http://www.oreilly.co.jp/books/4873112788/toc.html)
- [SingleInstanceServiceを使って Web Start アプリケーションの重複起動を禁止](http://terai.xrea.jp/Swing/SingleInstanceService.html)

<!-- dummy comment line for breaking list -->

### コメント
