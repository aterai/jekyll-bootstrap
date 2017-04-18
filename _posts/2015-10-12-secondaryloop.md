---
layout: post
category: swing
folder: SecondaryLoop
title: SecondaryLoopを使用してイベント・ディスパッチ・スレッド上で別途イベント・ループを実行する
tags: [SecondaryLoop, InputEvent, JLayer]
author: aterai
pubdate: 2015-10-12T05:29:04+09:00
description: SecondaryLoopを使用して、イベント・ディスパッチ・スレッドをブロックせずに、別スレッドをイベント・ループを実行します。
image: https://lh3.googleusercontent.com/-eAqnf0aNSsQ/VhrDDmUQQeI/AAAAAAAAODs/fwDgjYwjTbk/s800-Ic42/SecondaryLoop.png
comments: true
---
## 概要
`SecondaryLoop`を使用して、イベント・ディスパッチ・スレッドをブロックせずに、別スレッドをイベント・ループを実行します。

{% download https://lh3.googleusercontent.com/-eAqnf0aNSsQ/VhrDDmUQQeI/AAAAAAAAODs/fwDgjYwjTbk/s800-Ic42/SecondaryLoop.png %}

## サンプルコード
<pre class="prettyprint"><code>layerUI.setInputBlock(true);
final SecondaryLoop loop = Toolkit.getDefaultToolkit().getSystemEventQueue().createSecondaryLoop();
Thread work = new Thread() {
  @Override public void run() {
    doInBackground();
    layerUI.setInputBlock(false);
    loop.exit();
  }
};
work.start();
loop.enter();
</code></pre>

## 解説
上記のサンプルでは、[JLayerで指定したコンポーネントへの入力を禁止](http://ateraimemo.com/Swing/DisableInputLayer.html)と同様の`JLayer`を使用して任意のコンポーネントへの入力可不可を切り替えていますが、`SwingWorker`を使用するのではなく、`SecondaryLoop`を使用して、バックグラウンドで処理を実行している間でも、イベント・ディスパッチ・スレッドをブロックしないようにしています。

## 参考リンク
- [Hidden Java 7 Features – SecondaryLoop @ sellmic.com](http://sellmic.com/blog/2012/02/29/hidden-java-7-features-secondaryloop/)
    - [java - SecondaryLoop instead of SwingWorker? - Stack Overflow](https://stackoverflow.com/questions/10196809/secondaryloop-instead-of-swingworker)
- [SecondaryLoop (Java Platform SE 8)](http://docs.oracle.com/javase/jp/8/docs/api/java/awt/SecondaryLoop.html)
- [JLayerで指定したコンポーネントへの入力を禁止](http://ateraimemo.com/Swing/DisableInputLayer.html)

<!-- dummy comment line for breaking list -->

## コメント
