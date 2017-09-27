---
layout: post
category: swing
folder: SingleInstanceService
title: SingleInstanceServiceを使って Web Start アプリケーションの重複起動を禁止
tags: [SingleInstanceService, ServiceManager, SingleInstance]
author: aterai
pubdate: 2008-02-25T02:06:56+09:00
description: SingleInstanceServiceを使って、Web Startアプリケーションの重複起動を禁止したり、引数の取得を行います。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTTIU5TktI/AAAAAAAAAj4/muKNMFrhEcE/s800/SingleInstanceService.png
comments: true
---
## 概要
`SingleInstanceService`を使って、`Web Start`アプリケーションの重複起動を禁止したり、引数の取得を行います。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTTIU5TktI/AAAAAAAAAj4/muKNMFrhEcE/s800/SingleInstanceService.png %}

## サンプルコード
<pre class="prettyprint"><code>final JFrame frame = new JFrame("@title@");
try {
  SingleInstanceService sis =
      (SingleInstanceService) ServiceManager.lookup("javax.jnlp.SingleInstanceService");
  sis.addSingleInstanceListener(new SingleInstanceListener() {
    private int count = 0;
    @Override public void newActivation(String[] args) {
      //System.out.println(EventQueue.isDispatchThread());
      EventQueue.invokeLater(new Runnable() {
        @Override public void run() {
          JOptionPane.showMessageDialog(frame, "");
          frame.setTitle("title:" + count);
          count++;
        }
      });
    }
  });
} catch (UnavailableServiceException use) {
  use.printStackTrace();
  return;
}
</code></pre>

## 解説
`Web Start`アプリケーションの場合、`javax.jnlp.SingleInstanceService`に、`SingleInstanceListener`を追加することで、新しい次のインスタンスの起動やその時の引数を取得することが簡単に出来ます。

- ~~メモ: `JDK 1.6.0_03`では、`SingleInstanceService`は正常に動作しない~~
    - `JDK 1.6.0_10`で修正済み

<!-- dummy comment line for breaking list -->

- - - -
コンパイルに、`javaws.jar`が必要なので、以下のようなクラスパスを設定します。

	set CLASSPATH=%JAVA_HOME%/jre/lib/javaws.jar

または、`build.xml`などに記入してください。

<pre class="prettyprint"><code>&lt;path id="project.class.path"&gt;
  &lt;pathelement location="${build.dest}" /&gt;
  &lt;pathelement location="${java.home}/lib/javaws.jar" /&gt;
  &lt;pathelement path="${java.class.path}" /&gt;
&lt;/path&gt;
</code></pre>

- [Java How To ...: JAVA_HOME vs java.home](http://javahowto.blogspot.com/2006/05/javahome-vs-javahome.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [SingleInstanceService (JNLP API リファレンス 1.7.0_45)](https://docs.oracle.com/javase/jp/7/jre/api/javaws/jnlp/javax/jnlp/SingleInstanceService.html)
- [Bug ID: 6631056 SingleInstanceService does not work on JRE 1.6.0_03](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=6631056)
    - via: [Java Web Start & JNLP - How to use singleinstance service with a JWS application](https://community.oracle.com/thread/1307009)
- [Java Web Start SingleInstanceService - appframework(JSR-296)](https://appframework.dev.java.net/servlets/ReadMsg?listName=users&msgNo=396)
- [ServerSocketを使ってアプリケーションの複数起動を禁止](http://ateraimemo.com/Swing/SingleInstanceApplication.html)

<!-- dummy comment line for breaking list -->

## コメント
